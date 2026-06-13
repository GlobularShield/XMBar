#include "MDRNativeBridge.h"

#include <algorithm>
#include <cctype>
#include <cstring>
#include <exception>
#include <memory>
#include <string>
#include <vector>

#include <mdr-c/Base.h>
#include <mdr-c/Connection.h>
#include <mdr-c/Platform/PlatformMacOS.h>
#include <mdr/Headphones.hpp>
#include <mdr/Generated/ProtocolV2Enum.hpp>
#include <mdr/Generated/ProtocolV2T1Enum.hpp>

struct NativeDevice
{
    std::string name;
    std::string address;
};

struct MDRNativeApp
{
    MDRConnectionMacOS* platformConnection = nullptr;
    MDRConnection* connection = nullptr;
    std::unique_ptr<mdr::MDRHeadphones> headphones;
    std::vector<NativeDevice> devices;
    std::string lastError;
    int phase = MDR_NATIVE_PHASE_IDLE;

    MDRNativeApp()
    {
        platformConnection = mdrConnectionMacOSCreate();
        connection = mdrConnectionMacOSGet(platformConnection);
    }

    ~MDRNativeApp()
    {
        headphones.reset();
        if (connection)
            mdrConnectionDisconnect(connection);
        if (platformConnection)
            mdrConnectionMacOSDestroy(platformConnection);
    }
};

namespace
{
    void CopyCString(const std::string& source, char* out, int outSize)
    {
        if (!out || outSize <= 0)
            return;
        std::strncpy(out, source.c_str(), static_cast<size_t>(outSize - 1));
        out[outSize - 1] = '\0';
    }

    std::string Lower(std::string value)
    {
        std::ranges::transform(value, value.begin(),
                               [](unsigned char ch) { return static_cast<char>(std::tolower(ch)); });
        return value;
    }

    int DeviceSortRank(const NativeDevice& device)
    {
        const std::string name = Lower(device.name);
        if (name.find("wh-") != std::string::npos || name.find("wf-") != std::string::npos)
            return 0;
        if (name.find("sony") != std::string::npos || name.find("headphone") != std::string::npos)
            return 1;
        return 2;
    }

    bool SetError(MDRNativeApp* app, const std::string& message)
    {
        if (!app)
            return false;
        app->lastError = message;
        app->phase = MDR_NATIVE_PHASE_ERROR;
        return false;
    }

    bool SetConnectionError(MDRNativeApp* app, const std::string& prefix)
    {
        if (!app)
            return false;

        std::string message = prefix;
        if (app->connection)
        {
            const char* connectionError = mdrConnectionGetLastError(app->connection);
            if (connectionError && connectionError[0] != '\0')
            {
                message += ": ";
                message += connectionError;
            }
        }
        return SetError(app, message);
    }

    bool SetHeadphonesError(MDRNativeApp* app, const std::string& prefix)
    {
        if (!app)
            return false;

        std::string message = prefix;
        if (app->headphones)
        {
            const char* headphoneError = app->headphones->GetLastError();
            if (headphoneError && headphoneError[0] != '\0')
            {
                message += ": ";
                message += headphoneError;
            }
        }
        return SetError(app, message);
    }

    bool HasHeadphones(MDRNativeApp* app) { return app && app->headphones; }

    int RequestCommit(MDRNativeApp* app);

    bool SupportsNoiseCancelling(const mdr::MDRHeadphones& headphones)
    {
        using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
        return headphones.mSupport.contains(F1::NOISE_CANCELLING_ONOFF) ||
            headphones.mSupport.contains(F1::NOISE_CANCELLING_ONOFF_AND_AMBIENT_SOUND_MODE_ONOFF) ||
            headphones.mSupport.contains(F1::NOISE_CANCELLING_DUAL_SINGLE_OFF_AND_AMBIENT_SOUND_MODE_ONOFF) ||
            headphones.mSupport.contains(F1::NOISE_CANCELLING_ONOFF_AND_AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT) ||
            headphones.mSupport.contains(F1::NOISE_CANCELLING_DUAL_SINGLE_OFF_AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT) ||
            headphones.mSupport.contains(
                F1::MODE_NC_ASM_NOISE_CANCELLING_DUAL_AUTO_AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT) ||
            headphones.mSupport.contains(
                F1::MODE_NC_ASM_NOISE_CANCELLING_DUAL_SINGLE_AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT) ||
            headphones.mSupport.contains(F1::MODE_NC_ASM_NOISE_CANCELLING_DUAL_AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT) ||
            headphones.mSupport.contains(
                F1::MODE_NC_NCSS_ASM_NOISE_CANCELLING_DUAL_AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT_WITH_TEST_MODE) ||
            headphones.mSupport.contains(
                F1::MODE_NC_ASM_NOISE_CANCELLING_DUAL_AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT_NOISE_ADAPTATION);
    }

    bool SupportsAmbientSound(const mdr::MDRHeadphones& headphones)
    {
        using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
        return headphones.mSupport.contains(F1::NOISE_CANCELLING_ONOFF_AND_AMBIENT_SOUND_MODE_ONOFF) ||
            headphones.mSupport.contains(F1::NOISE_CANCELLING_DUAL_SINGLE_OFF_AND_AMBIENT_SOUND_MODE_ONOFF) ||
            headphones.mSupport.contains(F1::NOISE_CANCELLING_ONOFF_AND_AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT) ||
            headphones.mSupport.contains(F1::NOISE_CANCELLING_DUAL_SINGLE_OFF_AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT) ||
            headphones.mSupport.contains(F1::AMBIENT_SOUND_MODE_ONOFF) ||
            headphones.mSupport.contains(F1::AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT) ||
            headphones.mSupport.contains(
                F1::MODE_NC_ASM_NOISE_CANCELLING_DUAL_AUTO_AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT) ||
            headphones.mSupport.contains(F1::AMBIENT_SOUND_CONTROL_MODE_SELECT) ||
            headphones.mSupport.contains(
                F1::MODE_NC_ASM_NOISE_CANCELLING_DUAL_SINGLE_AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT) ||
            headphones.mSupport.contains(F1::MODE_NC_ASM_NOISE_CANCELLING_DUAL_AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT) ||
            headphones.mSupport.contains(
                F1::MODE_NC_NCSS_ASM_NOISE_CANCELLING_DUAL_AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT_WITH_TEST_MODE) ||
            headphones.mSupport.contains(
                F1::MODE_NC_ASM_NOISE_CANCELLING_DUAL_AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT_NOISE_ADAPTATION);
    }

    bool SupportsAutoAmbientSound(const mdr::MDRHeadphones& headphones)
    {
        using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
        return headphones.mSupport.contains(
            F1::MODE_NC_ASM_NOISE_CANCELLING_DUAL_AMBIENT_SOUND_MODE_LEVEL_ADJUSTMENT_NOISE_ADAPTATION);
    }

    bool SupportsSpeakToChat(const mdr::MDRHeadphones& headphones)
    {
        using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
        return headphones.mSupport.contains(F1::SMART_TALKING_MODE_TYPE2);
    }

    bool SupportsPlaybackControl(const mdr::MDRHeadphones& headphones)
    {
        using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
        return headphones.mSupport.contains(F1::PLAYBACK_CONTROLLER_WITH_CALL_VOLUME_ADJUSTMENT) ||
            headphones.mSupport.contains(F1::PLAYBACK_CONTROLLER_WITH_CALL_VOLUME_ADJUSTMENT_AND_MUTE) ||
            headphones.mSupport.contains(F1::PLAYBACK_CONTROLLER_WITH_CALL_VOLUME_ADJUSTMENT_AND_FUNCTION_CHANGE) ||
            headphones.mSupport.contains(F1::PLAYBACK_CONTROLLER_WITH_FUNCTION_CHANGE);
    }

    bool SupportsPairingDeviceManagement(const mdr::MDRHeadphones& headphones)
    {
        using F2 = mdr::v2::MessageMdrV2FunctionType_Table2;
        return headphones.mSupport.contains(F2::PAIRING_DEVICE_MANAGEMENT_CLASSIC_BT) ||
            headphones.mSupport.contains(F2::PAIRING_DEVICE_MANAGEMENT_WITH_BLUETOOTH_CLASS_OF_DEVICE_CLASSIC_BT) ||
            headphones.mSupport.contains(F2::PAIRING_DEVICE_MANAGEMENT_WITH_BLUETOOTH_CLASS_OF_DEVICE_CLASSIC_LE);
    }

    bool SupportsSafeListening(const mdr::MDRHeadphones& headphones)
    {
        using F2 = mdr::v2::MessageMdrV2FunctionType_Table2;
        return headphones.mSupport.contains(F2::SAFE_LISTENING_HBS_1) ||
            headphones.mSupport.contains(F2::SAFE_LISTENING_HBS_2) ||
            headphones.mSupport.contains(F2::SAFE_LISTENING_TWS_1) ||
            headphones.mSupport.contains(F2::SAFE_LISTENING_TWS_2);
    }

    bool IsMacAddress(const char* address)
    {
        return address && std::strlen(address) == 17;
    }

    int CommitIfReady(MDRNativeApp* app)
    {
        if (!app || !app->headphones)
            return MDR_RESULT_ERROR_NO_CONNECTION;
        if (app->phase != MDR_NATIVE_PHASE_READY)
            return MDR_RESULT_INPROGRESS;
        return RequestCommit(app);
    }

    struct GeneralSettingSlot
    {
        int number;
        mdr::MDRHeadphones::GsCapability* capability;
        mdr::MDRProperty<bool>* value;
    };

    std::vector<GeneralSettingSlot> GeneralSettingSlots(MDRNativeApp* app)
    {
        std::vector<GeneralSettingSlot> slots;
        if (!HasHeadphones(app))
            return slots;

        using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
        auto& headphones = *app->headphones;
        if (headphones.mSupport.contains(F1::GENERAL_SETTING_1))
            slots.push_back({1, &headphones.mGsCapability1, &headphones.mGsParamBool1});
        if (headphones.mSupport.contains(F1::GENERAL_SETTING_2))
            slots.push_back({2, &headphones.mGsCapability2, &headphones.mGsParamBool2});
        if (headphones.mSupport.contains(F1::GENERAL_SETTING_3))
            slots.push_back({3, &headphones.mGsCapability3, &headphones.mGsParamBool3});
        if (headphones.mSupport.contains(F1::GENERAL_SETTING_4))
            slots.push_back({4, &headphones.mGsCapability4, &headphones.mGsParamBool4});

        std::erase_if(slots,
                      [](const GeneralSettingSlot& slot)
                      {
                          return slot.capability->type != mdr::v2::t1::GsSettingType::BOOLEAN_TYPE ||
                              slot.capability->value.subject.value.empty();
                      });
        return slots;
    }

    bool SupportsTable1(MDRNativeApp* app, mdr::v2::MessageMdrV2FunctionType_Table1 function)
    {
        return HasHeadphones(app) && app->headphones->mSupport.contains(function);
    }

    bool SupportsTable2(MDRNativeApp* app, mdr::v2::MessageMdrV2FunctionType_Table2 function)
    {
        return HasHeadphones(app) && app->headphones->mSupport.contains(function);
    }

    int RequestInit(MDRNativeApp* app)
    {
        if (!app || !app->headphones)
            return MDR_RESULT_ERROR_NO_CONNECTION;

        const int result = app->headphones->Invoke(app->headphones->RequestInitV2());
        if (result == MDR_RESULT_OK)
        {
            app->phase = MDR_NATIVE_PHASE_INITIALIZING;
            return MDR_RESULT_OK;
        }
        if (result == MDR_RESULT_INPROGRESS)
            return result;

        SetHeadphonesError(app, "Could not start initialization");
        return result;
    }

    int RequestSync(MDRNativeApp* app)
    {
        if (!app || !app->headphones)
            return MDR_RESULT_ERROR_NO_CONNECTION;

        const int result = app->headphones->Invoke(app->headphones->RequestSyncV2());
        if (result == MDR_RESULT_OK)
        {
            app->phase = MDR_NATIVE_PHASE_SYNCING;
            return MDR_RESULT_OK;
        }
        if (result == MDR_RESULT_INPROGRESS)
            return result;

        SetHeadphonesError(app, "Could not start sync");
        return result;
    }

    int RequestCommit(MDRNativeApp* app)
    {
        if (!app || !app->headphones)
            return MDR_RESULT_ERROR_NO_CONNECTION;

        const int result = app->headphones->Invoke(app->headphones->RequestCommitV2());
        if (result == MDR_RESULT_OK)
        {
            app->phase = MDR_NATIVE_PHASE_COMMITTING;
            return MDR_RESULT_OK;
        }
        if (result == MDR_RESULT_INPROGRESS)
            return result;

        SetHeadphonesError(app, "Could not commit settings");
        return result;
    }
} // namespace

extern "C" {

MDRNativeApp* mdrNativeCreate(void)
{
    try
    {
        return new MDRNativeApp();
    }
    catch (const std::exception&)
    {
        return nullptr;
    }
}

void mdrNativeDestroy(MDRNativeApp* app) { delete app; }

int mdrNativeRefreshDevices(MDRNativeApp* app)
{
    if (!app || !app->connection)
        return MDR_RESULT_ERROR_NO_CONNECTION;

    MDRDeviceInfo* rawDevices = nullptr;
    int count = 0;
    const int result = mdrConnectionGetDevicesList(app->connection, &rawDevices, &count);
    if (result != MDR_RESULT_OK)
    {
        SetConnectionError(app, "Could not list Bluetooth devices");
        return result;
    }

    app->devices.clear();
    app->devices.reserve(static_cast<size_t>(count));
    for (int i = 0; i < count; ++i)
    {
        app->devices.push_back({rawDevices[i].szDeviceName[0] ? rawDevices[i].szDeviceName : "Bluetooth Device",
                                rawDevices[i].szDeviceMacAddress});
    }

    std::stable_sort(app->devices.begin(), app->devices.end(),
                     [](const NativeDevice& lhs, const NativeDevice& rhs)
                     {
                         const int lhsRank = DeviceSortRank(lhs);
                         const int rhsRank = DeviceSortRank(rhs);
                         if (lhsRank != rhsRank)
                             return lhsRank < rhsRank;
                         return Lower(lhs.name) < Lower(rhs.name);
                     });

    if (rawDevices)
        mdrConnectionFreeDevicesList(app->connection, &rawDevices);
    return MDR_RESULT_OK;
}

int mdrNativeGetDeviceCount(MDRNativeApp* app)
{
    if (!app)
        return 0;
    return static_cast<int>(app->devices.size());
}

int mdrNativeCopyDevice(MDRNativeApp* app, int index, char* nameOut, int nameOutSize, char* addressOut,
                        int addressOutSize)
{
    if (!app || index < 0 || index >= static_cast<int>(app->devices.size()))
        return MDR_RESULT_ERROR_NOT_FOUND;

    const NativeDevice& device = app->devices[static_cast<size_t>(index)];
    CopyCString(device.name, nameOut, nameOutSize);
    CopyCString(device.address, addressOut, addressOutSize);
    return MDR_RESULT_OK;
}

int mdrNativeConnect(MDRNativeApp* app, const char* address)
{
    if (!app || !app->connection || !address || address[0] == '\0')
        return MDR_RESULT_ERROR_BAD_ADDRESS;

    app->headphones.reset();
    app->lastError.clear();
    mdrConnectionDisconnect(app->connection);

    const int result = mdrConnectionConnect(app->connection, address, MDR_SERVICE_UUID_XM5);
    if (result == MDR_RESULT_OK || result == MDR_RESULT_INPROGRESS)
    {
        app->phase = MDR_NATIVE_PHASE_CONNECTING;
        return result;
    }

    SetConnectionError(app, "Could not connect");
    return result;
}

void mdrNativeDisconnect(MDRNativeApp* app)
{
    if (!app)
        return;

    app->headphones.reset();
    if (app->connection)
        mdrConnectionDisconnect(app->connection);
    app->phase = MDR_NATIVE_PHASE_IDLE;
}

int mdrNativePoll(MDRNativeApp* app)
{
    if (!app || !app->connection)
        return MDR_NATIVE_PHASE_ERROR;

    if (app->phase == MDR_NATIVE_PHASE_CONNECTING)
    {
        const int result = mdrConnectionPoll(app->connection, 10);
        if (result == MDR_RESULT_OK)
        {
            app->headphones = std::make_unique<mdr::MDRHeadphones>(app->connection);
            RequestInit(app);
        }
        else if (result != MDR_RESULT_INPROGRESS && result != MDR_RESULT_ERROR_TIMEOUT)
        {
            SetConnectionError(app, "Connection failed");
        }
        return app->phase;
    }

    if (!app->headphones)
        return app->phase;

    const int event = app->headphones->PollEvents();
    if (event == MDR_HEADPHONES_ERROR)
    {
        SetHeadphonesError(app, "Headphones protocol error");
        return app->phase;
    }

    if (event == MDR_HEADPHONES_TASK_INIT_OK)
    {
        RequestSync(app);
    }
    else if (event == MDR_HEADPHONES_TASK_SYNC_OK || event == MDR_HEADPHONES_TASK_COMMIT_OK)
    {
        app->phase = MDR_NATIVE_PHASE_READY;
    }

    return app->phase;
}

int mdrNativeRequestSync(MDRNativeApp* app)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    return RequestSync(app);
}

int mdrNativeGetPhase(MDRNativeApp* app) { return app ? app->phase : MDR_NATIVE_PHASE_ERROR; }

int mdrNativeGetNoiseControlMode(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return MDR_NATIVE_NOISE_MODE_OFF;

    const auto& headphones = *app->headphones;
    if (!headphones.mNcAsmEnabled.desired)
        return MDR_NATIVE_NOISE_MODE_OFF;
    if (headphones.mNcAsmAutoAsmEnabled.desired)
        return MDR_NATIVE_NOISE_MODE_ADAPTIVE;
    if (headphones.mNcAsmMode.desired == mdr::v2::t1::NcAsmMode::NC)
        return MDR_NATIVE_NOISE_MODE_NOISE_CANCELLING;
    return MDR_NATIVE_NOISE_MODE_AMBIENT;
}

int mdrNativeGetAmbientLevel(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 20;
    return std::clamp(app->headphones->mNcAsmAmbientLevel.desired, 1, 20);
}

int mdrNativeGetFocusOnVoice(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return app->headphones->mNcAsmFocusOnVoice.desired ? 1 : 0;
}

int mdrNativeSetNoiseControl(MDRNativeApp* app, int mode, int ambientLevel, int focusOnVoice)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;

    auto& headphones = *app->headphones;
    ambientLevel = std::clamp(ambientLevel, 1, 20);

    switch (mode)
    {
    case MDR_NATIVE_NOISE_MODE_OFF:
        headphones.mNcAsmEnabled.desired = false;
        headphones.mNcAsmAutoAsmEnabled.desired = false;
        break;
    case MDR_NATIVE_NOISE_MODE_NOISE_CANCELLING:
        headphones.mNcAsmEnabled.desired = true;
        headphones.mNcAsmMode.desired = mdr::v2::t1::NcAsmMode::NC;
        headphones.mNcAsmAutoAsmEnabled.desired = false;
        break;
    case MDR_NATIVE_NOISE_MODE_AMBIENT:
        headphones.mNcAsmEnabled.desired = true;
        headphones.mNcAsmMode.desired = mdr::v2::t1::NcAsmMode::ASM;
        headphones.mNcAsmAmbientLevel.desired = ambientLevel;
        headphones.mNcAsmAutoAsmEnabled.desired = false;
        break;
    case MDR_NATIVE_NOISE_MODE_ADAPTIVE:
        if (!SupportsAutoAmbientSound(headphones))
            return MDR_RESULT_ERROR_NOT_SUPPORTED;
        headphones.mNcAsmEnabled.desired = true;
        headphones.mNcAsmMode.desired = mdr::v2::t1::NcAsmMode::ASM;
        headphones.mNcAsmAmbientLevel.desired = ambientLevel;
        headphones.mNcAsmAutoAsmEnabled.desired = true;
        break;
    default:
        return MDR_RESULT_ERROR_BAD_ADDRESS;
    }

    headphones.mNcAsmFocusOnVoice.desired = focusOnVoice != 0;
    return RequestCommit(app);
}

int mdrNativeSupportsNoiseCancelling(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return SupportsNoiseCancelling(*app->headphones) ? 1 : 0;
}

int mdrNativeSupportsAmbientSound(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return SupportsAmbientSound(*app->headphones) ? 1 : 0;
}

int mdrNativeSupportsAutoAmbientSound(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return SupportsAutoAmbientSound(*app->headphones) ? 1 : 0;
}

int mdrNativeSupportsSpeakToChat(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return SupportsSpeakToChat(*app->headphones) ? 1 : 0;
}

int mdrNativeSupportsListeningMode(MDRNativeApp* app)
{
    using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
    return SupportsTable1(app, F1::LISTENING_OPTION) ? 1 : 0;
}

int mdrNativeSupportsConnectionQuality(MDRNativeApp* app)
{
    using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
    return SupportsTable1(app, F1::CONNECTION_MODE_SOUND_QUALITY_CONNECTION_QUALITY) ? 1 : 0;
}

int mdrNativeSupportsUpscaling(MDRNativeApp* app)
{
    using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
    return SupportsTable1(app, F1::UPSCALING_AUTO_OFF) ? 1 : 0;
}

int mdrNativeSupportsAssignableSettings(MDRNativeApp* app)
{
    using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
    return SupportsTable1(app, F1::ASSIGNABLE_SETTING) ? 1 : 0;
}

int mdrNativeSupportsNcAsmButtonSettings(MDRNativeApp* app)
{
    using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
    return SupportsTable1(app, F1::AMBIENT_SOUND_CONTROL_MODE_SELECT) ? 1 : 0;
}

int mdrNativeSupportsHeadGesture(MDRNativeApp* app)
{
    using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
    return SupportsTable1(app, F1::HEAD_GESTURE_ON_OFF_TRAINING) ? 1 : 0;
}

int mdrNativeSupportsAutoPowerOff(MDRNativeApp* app)
{
    using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
    return SupportsTable1(app, F1::AUTO_POWER_OFF) ? 1 : 0;
}

int mdrNativeSupportsAutoPowerOffWearingDetection(MDRNativeApp* app)
{
    using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
    return SupportsTable1(app, F1::AUTO_POWER_OFF_WITH_WEARING_DETECTION) ? 1 : 0;
}

int mdrNativeSupportsAutoPause(MDRNativeApp* app)
{
    using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
    return SupportsTable1(app, F1::PLAYBACK_CONTROL_BY_WEARING_REMOVING_HEADPHONE_ON_OFF) ? 1 : 0;
}

int mdrNativeSupportsVoiceGuidance(MDRNativeApp* app)
{
    using F2 = mdr::v2::MessageMdrV2FunctionType_Table2;
    return SupportsTable2(app,
                          F2::VOICE_GUIDANCE_SETTING_MTK_TRANSFER_WITHOUT_DISCONNECTION_NOT_SUPPORT_LANGUAGE_SWITCH) ||
            SupportsTable2(app,
                           F2::VOICE_GUIDANCE_SETTING_MTK_TRANSFER_WITHOUT_DISCONNECTION_SUPPORT_LANGUAGE_SWITCH) ||
            SupportsTable2(
                app,
                F2::VOICE_GUIDANCE_SETTING_MTK_TRANSFER_WITHOUT_DISCONNECTION_SUPPORT_LANGUAGE_SWITCH_AND_VOLUME_ADJUSTMENT) ||
            SupportsTable2(app, F2::VOICE_GUIDANCE_SETTING_SUPPORT_LANGUAGE_SWITCH) ||
            SupportsTable2(app, F2::VOICE_GUIDANCE_SETTING_ONLY_ON_OFF_SWITCH)
        ? 1
        : 0;
}

int mdrNativeSupportsVoiceGuidanceVolume(MDRNativeApp* app)
{
    using F2 = mdr::v2::MessageMdrV2FunctionType_Table2;
    return SupportsTable2(
               app,
               F2::VOICE_GUIDANCE_SETTING_MTK_TRANSFER_WITHOUT_DISCONNECTION_SUPPORT_LANGUAGE_SWITCH_AND_VOLUME_ADJUSTMENT)
        ? 1
        : 0;
}

int mdrNativeSupportsPlaybackControl(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return SupportsPlaybackControl(*app->headphones) ? 1 : 0;
}

int mdrNativeSupportsPowerOff(MDRNativeApp* app)
{
    using F1 = mdr::v2::MessageMdrV2FunctionType_Table1;
    return SupportsTable1(app, F1::POWER_OFF) ? 1 : 0;
}

int mdrNativeSupportsPairingDeviceManagement(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return SupportsPairingDeviceManagement(*app->headphones) ? 1 : 0;
}

int mdrNativeSupportsSafeListening(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return SupportsSafeListening(*app->headphones) ? 1 : 0;
}

int mdrNativeGetSpeakToChatEnabled(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return app->headphones->mSpeakToChatEnabled.desired ? 1 : 0;
}

int mdrNativeSetSpeakToChatEnabled(MDRNativeApp* app, int enabled)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (!SupportsSpeakToChat(*app->headphones))
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mSpeakToChatEnabled.desired = enabled != 0;
    return RequestCommit(app);
}

int mdrNativeGetSpeakToChatSensitivity(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return static_cast<int>(app->headphones->mSpeakToChatDetectSensitivity.desired);
}

int mdrNativeSetSpeakToChatSensitivity(MDRNativeApp* app, int sensitivity)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (!SupportsSpeakToChat(*app->headphones))
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mSpeakToChatDetectSensitivity.desired =
        static_cast<mdr::v2::t1::DetectSensitivity>(std::clamp(sensitivity, 0, 2));
    return RequestCommit(app);
}

int mdrNativeGetSpeakToChatModeOutTime(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 1;
    return static_cast<int>(app->headphones->mSpeakToModeOutTime.desired);
}

int mdrNativeSetSpeakToChatModeOutTime(MDRNativeApp* app, int modeOutTime)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (!SupportsSpeakToChat(*app->headphones))
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mSpeakToModeOutTime.desired = static_cast<mdr::v2::t1::ModeOutTime>(std::clamp(modeOutTime, 0, 3));
    return RequestCommit(app);
}

int mdrNativeGetEqAvailable(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return app->headphones->mEqAvailable.desired ? 1 : 0;
}

int mdrNativeGetEqPreset(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return static_cast<int>(app->headphones->mEqPresetId.desired);
}

int mdrNativeSetEqPreset(MDRNativeApp* app, int preset)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (!app->headphones->mEqAvailable.desired)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mEqPresetId.desired = static_cast<mdr::v2::t1::EqPresetId>(std::clamp(preset, 0, 255));
    return RequestCommit(app);
}

int mdrNativeGetEqClearBass(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return app->headphones->mEqClearBass.desired;
}

int mdrNativeSetEqClearBass(MDRNativeApp* app, int value)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (!app->headphones->mEqAvailable.desired)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mEqClearBass.desired = std::clamp(value, -10, 10);
    return RequestCommit(app);
}

int mdrNativeGetEqBandCount(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return static_cast<int>(app->headphones->mEqConfig.desired.size());
}

int mdrNativeGetEqBand(MDRNativeApp* app, int index)
{
    if (!HasHeadphones(app))
        return 0;
    const auto& bands = app->headphones->mEqConfig.desired;
    if (index < 0 || index >= static_cast<int>(bands.size()))
        return 0;
    return bands[static_cast<size_t>(index)];
}

int mdrNativeSetEqBand(MDRNativeApp* app, int index, int value)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (!app->headphones->mEqAvailable.desired)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    auto& bands = app->headphones->mEqConfig.desired;
    if (index < 0 || index >= static_cast<int>(bands.size()))
        return MDR_RESULT_ERROR_BAD_ADDRESS;
    bands[static_cast<size_t>(index)] = std::clamp(value, -10, 10);
    return RequestCommit(app);
}

int mdrNativeGetPlayVolume(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return app->headphones->mPlayVolume.desired;
}

int mdrNativeSetPlayVolume(MDRNativeApp* app, int volume)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;

    app->headphones->mPlayVolume.desired = std::clamp(volume, 0, 30);
    return RequestCommit(app);
}

int mdrNativeGetPlaybackStatus(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return static_cast<int>(app->headphones->mPlayPause);
}

int mdrNativeSetPlaybackControl(MDRNativeApp* app, int control)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (!SupportsPlaybackControl(*app->headphones))
        return MDR_RESULT_ERROR_NOT_SUPPORTED;
    if (control <= 0 || control > 9)
        return MDR_RESULT_ERROR_BAD_ADDRESS;

    app->headphones->mPlayControl.desired = static_cast<mdr::v2::t1::PlaybackControl>(control);
    return RequestCommit(app);
}

void mdrNativeCopyTrackTitle(MDRNativeApp* app, char* out, int outSize)
{
    CopyCString(HasHeadphones(app) ? app->headphones->mPlayTrackTitle : "", out, outSize);
}

void mdrNativeCopyTrackAlbum(MDRNativeApp* app, char* out, int outSize)
{
    CopyCString(HasHeadphones(app) ? app->headphones->mPlayTrackAlbum : "", out, outSize);
}

void mdrNativeCopyTrackArtist(MDRNativeApp* app, char* out, int outSize)
{
    CopyCString(HasHeadphones(app) ? app->headphones->mPlayTrackArtist : "", out, outSize);
}

int mdrNativeGetUpscalingEnabled(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return app->headphones->mUpscalingEnabled.desired ? 1 : 0;
}

int mdrNativeSetUpscalingEnabled(MDRNativeApp* app, int enabled)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsUpscaling(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mUpscalingEnabled.desired = enabled != 0;
    return RequestCommit(app);
}

int mdrNativeGetUpscalingAvailable(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return app->headphones->mUpscalingAvailable ? 1 : 0;
}

int mdrNativeGetAudioPriorityMode(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return static_cast<int>(app->headphones->mAudioPriorityMode.desired);
}

int mdrNativeSetAudioPriorityMode(MDRNativeApp* app, int mode)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsConnectionQuality(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mAudioPriorityMode.desired = static_cast<mdr::v2::t1::PriorMode>(std::clamp(mode, 0, 2));
    return RequestCommit(app);
}

int mdrNativeGetAutoPauseEnabled(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return app->headphones->mAutoPauseEnabled.desired ? 1 : 0;
}

int mdrNativeSetAutoPauseEnabled(MDRNativeApp* app, int enabled)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsAutoPause(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mAutoPauseEnabled.desired = enabled != 0;
    return RequestCommit(app);
}

int mdrNativeGetHeadGestureEnabled(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return app->headphones->mHeadGestureEnabled.desired ? 1 : 0;
}

int mdrNativeSetHeadGestureEnabled(MDRNativeApp* app, int enabled)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsHeadGesture(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mHeadGestureEnabled.desired = enabled != 0;
    return RequestCommit(app);
}

int mdrNativeGetVoiceGuidanceEnabled(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return app->headphones->mVoiceGuidanceEnabled.desired ? 1 : 0;
}

int mdrNativeSetVoiceGuidanceEnabled(MDRNativeApp* app, int enabled)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsVoiceGuidance(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mVoiceGuidanceEnabled.desired = enabled != 0;
    return RequestCommit(app);
}

int mdrNativeGetVoiceGuidanceVolume(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return app->headphones->mVoiceGuidanceVolume.desired;
}

int mdrNativeSetVoiceGuidanceVolume(MDRNativeApp* app, int volume)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsVoiceGuidanceVolume(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mVoiceGuidanceVolume.desired = std::clamp(volume, -2, 2);
    return RequestCommit(app);
}

int mdrNativeGetPowerAutoOff(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0x11;
    return static_cast<int>(app->headphones->mPowerAutoOff.desired);
}

int mdrNativeSetPowerAutoOff(MDRNativeApp* app, int value)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsAutoPowerOff(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mPowerAutoOff.desired = static_cast<mdr::v2::t1::AutoPowerOffElements>(std::clamp(value, 0, 0x11));
    return RequestCommit(app);
}

int mdrNativeGetPowerAutoOffWearingDetection(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0x11;
    return static_cast<int>(app->headphones->mPowerAutoOffWearingDetection.desired);
}

int mdrNativeSetPowerAutoOffWearingDetection(MDRNativeApp* app, int value)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsAutoPowerOffWearingDetection(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mPowerAutoOffWearingDetection.desired =
        static_cast<mdr::v2::t1::AutoPowerOffWearingDetectionElements>(std::clamp(value, 0, 0x11));
    return RequestCommit(app);
}

int mdrNativeGetNcAsmButtonFunction(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return static_cast<int>(app->headphones->mNcAsmButtonFunction.desired);
}

int mdrNativeSetNcAsmButtonFunction(MDRNativeApp* app, int value)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsNcAsmButtonSettings(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mNcAsmButtonFunction.desired = static_cast<mdr::v2::t1::Function>(std::clamp(value, 0, 0x10));
    return RequestCommit(app);
}

int mdrNativeGetTouchFunctionLeft(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0xFF;
    return static_cast<int>(app->headphones->mTouchFunctionLeft.desired);
}

int mdrNativeSetTouchFunctionLeft(MDRNativeApp* app, int value)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsAssignableSettings(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mTouchFunctionLeft.desired = static_cast<mdr::v2::t1::Preset>(std::clamp(value, 0, 0xFF));
    return RequestCommit(app);
}

int mdrNativeGetTouchFunctionRight(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0xFF;
    return static_cast<int>(app->headphones->mTouchFunctionRight.desired);
}

int mdrNativeSetTouchFunctionRight(MDRNativeApp* app, int value)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsAssignableSettings(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mTouchFunctionRight.desired = static_cast<mdr::v2::t1::Preset>(std::clamp(value, 0, 0xFF));
    return RequestCommit(app);
}

int mdrNativeGetBgmModeEnabled(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return app->headphones->mBGMModeEnabled.desired ? 1 : 0;
}

int mdrNativeSetBgmModeEnabled(MDRNativeApp* app, int enabled)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsListeningMode(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mBGMModeEnabled.desired = enabled != 0;
    return RequestCommit(app);
}

int mdrNativeGetBgmRoomSize(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 1;
    return static_cast<int>(app->headphones->mBGMModeRoomSize.desired);
}

int mdrNativeSetBgmRoomSize(MDRNativeApp* app, int value)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsListeningMode(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mBGMModeRoomSize.desired = static_cast<mdr::v2::t1::RoomSize>(std::clamp(value, 0, 2));
    return RequestCommit(app);
}

int mdrNativeGetUpmixCinemaEnabled(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return app->headphones->mUpmixCinemaEnabled.desired ? 1 : 0;
}

int mdrNativeSetUpmixCinemaEnabled(MDRNativeApp* app, int enabled)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsListeningMode(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mUpmixCinemaEnabled.desired = enabled != 0;
    return RequestCommit(app);
}

int mdrNativeGetListeningMode(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    if (app->headphones->mBGMModeEnabled.desired)
        return 1;
    if (app->headphones->mUpmixCinemaEnabled.desired)
        return 2;
    return 0;
}

int mdrNativeSetListeningMode(MDRNativeApp* app, int mode)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsListeningMode(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    mode = std::clamp(mode, 0, 2);
    app->headphones->mBGMModeEnabled.desired = mode == 1;
    app->headphones->mUpmixCinemaEnabled.desired = mode == 2;
    return RequestCommit(app);
}

int mdrNativeGetNoiseAdaptiveSensitivity(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return static_cast<int>(app->headphones->mNcAsmNoiseAdaptiveSensitivity.desired);
}

int mdrNativeSetNoiseAdaptiveSensitivity(MDRNativeApp* app, int value)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (!SupportsAutoAmbientSound(*app->headphones))
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mNcAsmNoiseAdaptiveSensitivity.desired =
        static_cast<mdr::v2::t1::NoiseAdaptiveSensitivity>(std::clamp(value, 0, 2));
    return RequestCommit(app);
}

int mdrNativeGetBatteryLeft(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return -1;
    return app->headphones->mBatteryL.level;
}

int mdrNativeGetBatteryRight(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return -1;
    return app->headphones->mBatteryR.level;
}

int mdrNativeGetBatteryCase(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return -1;
    return app->headphones->mBatteryCase.level;
}

int mdrNativeGetBatteryLeftCharging(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return static_cast<int>(app->headphones->mBatteryL.charging);
}

int mdrNativeGetBatteryRightCharging(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return static_cast<int>(app->headphones->mBatteryR.charging);
}

int mdrNativeGetBatteryCaseCharging(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return static_cast<int>(app->headphones->mBatteryCase.charging);
}

int mdrNativeGetBatteryLeftThreshold(MDRNativeApp* app)
{
    if (!HasHeadphones(app) || app->headphones->mBatteryL.threshold == 0xFF)
        return -1;
    return app->headphones->mBatteryL.threshold;
}

int mdrNativeGetBatteryRightThreshold(MDRNativeApp* app)
{
    if (!HasHeadphones(app) || app->headphones->mBatteryR.threshold == 0xFF)
        return -1;
    return app->headphones->mBatteryR.threshold;
}

int mdrNativeGetBatteryCaseThreshold(MDRNativeApp* app)
{
    if (!HasHeadphones(app) || app->headphones->mBatteryCase.threshold == 0xFF)
        return -1;
    return app->headphones->mBatteryCase.threshold;
}

void mdrNativeCopyModelName(MDRNativeApp* app, char* out, int outSize)
{
    if (!HasHeadphones(app))
    {
        CopyCString("", out, outSize);
        return;
    }
    CopyCString(app->headphones->mModelName, out, outSize);
}

void mdrNativeCopyFirmwareVersion(MDRNativeApp* app, char* out, int outSize)
{
    if (!HasHeadphones(app))
    {
        CopyCString("", out, outSize);
        return;
    }
    CopyCString(app->headphones->mFWVersion, out, outSize);
}

void mdrNativeCopyUniqueId(MDRNativeApp* app, char* out, int outSize)
{
    CopyCString(HasHeadphones(app) ? app->headphones->mUniqueId : "", out, outSize);
}

void mdrNativeCopyModelSeries(MDRNativeApp* app, char* out, int outSize)
{
    CopyCString(HasHeadphones(app) ? mdr::v2::t1::format_as(app->headphones->mModelSeries) : "", out, outSize);
}

void mdrNativeCopyModelColor(MDRNativeApp* app, char* out, int outSize)
{
    CopyCString(HasHeadphones(app) ? mdr::v2::t1::format_as(app->headphones->mModelColor) : "", out, outSize);
}

void mdrNativeCopyAudioCodec(MDRNativeApp* app, char* out, int outSize)
{
    CopyCString(HasHeadphones(app) ? mdr::v2::t1::format_as(app->headphones->mAudioCodec) : "", out, outSize);
}

void mdrNativeCopyUpscalingType(MDRNativeApp* app, char* out, int outSize)
{
    CopyCString(HasHeadphones(app) ? mdr::v2::t1::format_as(app->headphones->mUpscalingType) : "", out, outSize);
}

void mdrNativeCopyLastAlert(MDRNativeApp* app, char* out, int outSize)
{
    CopyCString(HasHeadphones(app) ? mdr::v2::t1::format_as(app->headphones->mLastAlertMessage) : "", out, outSize);
}

void mdrNativeCopyLastInteraction(MDRNativeApp* app, char* out, int outSize)
{
    CopyCString(HasHeadphones(app) ? app->headphones->mLastInteractionMessage : "", out, outSize);
}

void mdrNativeCopyLastDeviceJSON(MDRNativeApp* app, char* out, int outSize)
{
    CopyCString(HasHeadphones(app) ? app->headphones->mLastDeviceJSONMessage : "", out, outSize);
}

int mdrNativeSetShutdown(MDRNativeApp* app)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (mdrNativeSupportsPowerOff(app) == 0)
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mShutdown.desired = true;
    return RequestCommit(app);
}

int mdrNativeGetPairedDeviceCount(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return static_cast<int>(app->headphones->mPairedDevices.size());
}

int mdrNativeCopyPairedDevice(MDRNativeApp* app, int index, char* nameOut, int nameOutSize, char* addressOut,
                              int addressOutSize, int* connectedOut, int* activePlaybackOut)
{
    if (!HasHeadphones(app))
        return MDR_RESULT_ERROR_NO_CONNECTION;

    const auto& devices = app->headphones->mPairedDevices;
    if (index < 0 || index >= static_cast<int>(devices.size()))
        return MDR_RESULT_ERROR_NOT_FOUND;

    const auto& device = devices[static_cast<size_t>(index)];
    CopyCString(device.name.empty() ? "Bluetooth Device" : device.name, nameOut, nameOutSize);
    CopyCString(device.macAddress, addressOut, addressOutSize);
    if (connectedOut)
        *connectedOut = device.connected ? 1 : 0;
    if (activePlaybackOut)
    {
        const auto& active = app->headphones->mMultipointDeviceMac.current.empty()
            ? app->headphones->mMultipointDeviceMac.desired
            : app->headphones->mMultipointDeviceMac.current;
        *activePlaybackOut = device.macAddress == active ? 1 : 0;
    }
    return MDR_RESULT_OK;
}

void mdrNativeCopyMultipointDeviceMac(MDRNativeApp* app, char* out, int outSize)
{
    CopyCString(HasHeadphones(app) ? app->headphones->mMultipointDeviceMac.current : "", out, outSize);
}

int mdrNativeSetMultipointDeviceMac(MDRNativeApp* app, const char* address)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (!SupportsPairingDeviceManagement(*app->headphones))
        return MDR_RESULT_ERROR_NOT_SUPPORTED;
    if (!IsMacAddress(address))
        return MDR_RESULT_ERROR_BAD_ADDRESS;

    app->headphones->mMultipointDeviceMac.desired = address;
    return RequestCommit(app);
}

int mdrNativeGetPairingMode(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return app->headphones->mPairingMode.desired ? 1 : 0;
}

int mdrNativeSetPairingMode(MDRNativeApp* app, int enabled)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (!SupportsPairingDeviceManagement(*app->headphones))
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mPairingMode.desired = enabled != 0;
    return RequestCommit(app);
}

int mdrNativeConnectPairedDevice(MDRNativeApp* app, const char* address)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (!SupportsPairingDeviceManagement(*app->headphones))
        return MDR_RESULT_ERROR_NOT_SUPPORTED;
    if (!IsMacAddress(address))
        return MDR_RESULT_ERROR_BAD_ADDRESS;

    app->headphones->mPairedDeviceConnectMac.desired = address;
    return RequestCommit(app);
}

int mdrNativeDisconnectPairedDevice(MDRNativeApp* app, const char* address)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (!SupportsPairingDeviceManagement(*app->headphones))
        return MDR_RESULT_ERROR_NOT_SUPPORTED;
    if (!IsMacAddress(address))
        return MDR_RESULT_ERROR_BAD_ADDRESS;

    app->headphones->mPairedDeviceDisconnectMac.desired = address;
    return RequestCommit(app);
}

int mdrNativeUnpairDevice(MDRNativeApp* app, const char* address)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (!SupportsPairingDeviceManagement(*app->headphones))
        return MDR_RESULT_ERROR_NOT_SUPPORTED;
    if (!IsMacAddress(address))
        return MDR_RESULT_ERROR_BAD_ADDRESS;

    app->headphones->mPairedDeviceUnpairMac.desired = address;
    return RequestCommit(app);
}

int mdrNativeGetGeneralSettingCount(MDRNativeApp* app)
{
    return static_cast<int>(GeneralSettingSlots(app).size());
}

int mdrNativeCopyGeneralSetting(MDRNativeApp* app, int index, char* titleOut, int titleOutSize, char* summaryOut,
                                int summaryOutSize, int* enabledOut)
{
    auto slots = GeneralSettingSlots(app);
    if (index < 0 || index >= static_cast<int>(slots.size()))
        return MDR_RESULT_ERROR_NOT_FOUND;

    const auto& slot = slots[static_cast<size_t>(index)];
    CopyCString(slot.capability->value.subject.value, titleOut, titleOutSize);
    CopyCString(slot.capability->value.summary.value, summaryOut, summaryOutSize);
    if (enabledOut)
        *enabledOut = slot.value->desired ? 1 : 0;
    return MDR_RESULT_OK;
}

int mdrNativeSetGeneralSetting(MDRNativeApp* app, int index, int enabled)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;

    auto slots = GeneralSettingSlots(app);
    if (index < 0 || index >= static_cast<int>(slots.size()))
        return MDR_RESULT_ERROR_NOT_FOUND;

    slots[static_cast<size_t>(index)].value->desired = enabled != 0;
    return RequestCommit(app);
}

int mdrNativeGetSafeListeningSoundPressure(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return -1;
    return app->headphones->mSafeListeningSoundPressure;
}

int mdrNativeGetSafeListeningPreviewMode(MDRNativeApp* app)
{
    if (!HasHeadphones(app))
        return 0;
    return app->headphones->mSafeListeningPreviewMode.desired ? 1 : 0;
}

int mdrNativeSetSafeListeningPreviewMode(MDRNativeApp* app, int enabled)
{
    if (!app || !app->headphones)
        return MDR_RESULT_ERROR_NO_CONNECTION;
    if (app->phase != MDR_NATIVE_PHASE_READY)
        return MDR_RESULT_INPROGRESS;
    if (!SupportsSafeListening(*app->headphones))
        return MDR_RESULT_ERROR_NOT_SUPPORTED;

    app->headphones->mSafeListeningPreviewMode.desired = enabled != 0;
    return RequestCommit(app);
}

const char* mdrNativeGetLastError(MDRNativeApp* app)
{
    if (!app)
        return "Invalid native app handle";
    if (!app->lastError.empty())
        return app->lastError.c_str();
    if (app->connection)
        return mdrConnectionGetLastError(app->connection);
    return "";
}
}
