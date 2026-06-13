#pragma once

#ifdef __cplusplus
extern "C" {
#endif

typedef struct MDRNativeApp MDRNativeApp;

enum
{
    MDR_NATIVE_PHASE_IDLE = 0,
    MDR_NATIVE_PHASE_CONNECTING = 1,
    MDR_NATIVE_PHASE_INITIALIZING = 2,
    MDR_NATIVE_PHASE_SYNCING = 3,
    MDR_NATIVE_PHASE_READY = 4,
    MDR_NATIVE_PHASE_COMMITTING = 5,
    MDR_NATIVE_PHASE_ERROR = 6,
};

enum
{
    MDR_NATIVE_NOISE_MODE_OFF = 0,
    MDR_NATIVE_NOISE_MODE_NOISE_CANCELLING = 1,
    MDR_NATIVE_NOISE_MODE_AMBIENT = 2,
    MDR_NATIVE_NOISE_MODE_ADAPTIVE = 3,
};

MDRNativeApp* mdrNativeCreate(void);
void mdrNativeDestroy(MDRNativeApp* app);

int mdrNativeRefreshDevices(MDRNativeApp* app);
int mdrNativeGetDeviceCount(MDRNativeApp* app);
int mdrNativeCopyDevice(MDRNativeApp* app, int index, char* nameOut, int nameOutSize, char* addressOut,
                        int addressOutSize);

int mdrNativeConnect(MDRNativeApp* app, const char* address);
void mdrNativeDisconnect(MDRNativeApp* app);
int mdrNativePoll(MDRNativeApp* app);
int mdrNativeRequestSync(MDRNativeApp* app);

int mdrNativeGetPhase(MDRNativeApp* app);
int mdrNativeGetNoiseControlMode(MDRNativeApp* app);
int mdrNativeGetAmbientLevel(MDRNativeApp* app);
int mdrNativeGetFocusOnVoice(MDRNativeApp* app);
int mdrNativeSetNoiseControl(MDRNativeApp* app, int mode, int ambientLevel, int focusOnVoice);

int mdrNativeSupportsNoiseCancelling(MDRNativeApp* app);
int mdrNativeSupportsAmbientSound(MDRNativeApp* app);
int mdrNativeSupportsAutoAmbientSound(MDRNativeApp* app);
int mdrNativeSupportsSpeakToChat(MDRNativeApp* app);
int mdrNativeSupportsListeningMode(MDRNativeApp* app);
int mdrNativeSupportsConnectionQuality(MDRNativeApp* app);
int mdrNativeSupportsUpscaling(MDRNativeApp* app);
int mdrNativeSupportsAssignableSettings(MDRNativeApp* app);
int mdrNativeSupportsNcAsmButtonSettings(MDRNativeApp* app);
int mdrNativeSupportsHeadGesture(MDRNativeApp* app);
int mdrNativeSupportsAutoPowerOff(MDRNativeApp* app);
int mdrNativeSupportsAutoPowerOffWearingDetection(MDRNativeApp* app);
int mdrNativeSupportsAutoPause(MDRNativeApp* app);
int mdrNativeSupportsVoiceGuidance(MDRNativeApp* app);
int mdrNativeSupportsVoiceGuidanceVolume(MDRNativeApp* app);
int mdrNativeSupportsPlaybackControl(MDRNativeApp* app);
int mdrNativeSupportsPowerOff(MDRNativeApp* app);
int mdrNativeSupportsPairingDeviceManagement(MDRNativeApp* app);
int mdrNativeSupportsSafeListening(MDRNativeApp* app);
int mdrNativeGetSpeakToChatEnabled(MDRNativeApp* app);
int mdrNativeSetSpeakToChatEnabled(MDRNativeApp* app, int enabled);
int mdrNativeGetSpeakToChatSensitivity(MDRNativeApp* app);
int mdrNativeSetSpeakToChatSensitivity(MDRNativeApp* app, int sensitivity);
int mdrNativeGetSpeakToChatModeOutTime(MDRNativeApp* app);
int mdrNativeSetSpeakToChatModeOutTime(MDRNativeApp* app, int modeOutTime);

int mdrNativeGetEqAvailable(MDRNativeApp* app);
int mdrNativeGetEqPreset(MDRNativeApp* app);
int mdrNativeSetEqPreset(MDRNativeApp* app, int preset);
int mdrNativeGetEqClearBass(MDRNativeApp* app);
int mdrNativeSetEqClearBass(MDRNativeApp* app, int value);
int mdrNativeGetEqBandCount(MDRNativeApp* app);
int mdrNativeGetEqBand(MDRNativeApp* app, int index);
int mdrNativeSetEqBand(MDRNativeApp* app, int index, int value);

int mdrNativeGetPlayVolume(MDRNativeApp* app);
int mdrNativeSetPlayVolume(MDRNativeApp* app, int volume);
int mdrNativeGetPlaybackStatus(MDRNativeApp* app);
int mdrNativeSetPlaybackControl(MDRNativeApp* app, int control);
void mdrNativeCopyTrackTitle(MDRNativeApp* app, char* out, int outSize);
void mdrNativeCopyTrackAlbum(MDRNativeApp* app, char* out, int outSize);
void mdrNativeCopyTrackArtist(MDRNativeApp* app, char* out, int outSize);
int mdrNativeGetUpscalingEnabled(MDRNativeApp* app);
int mdrNativeSetUpscalingEnabled(MDRNativeApp* app, int enabled);
int mdrNativeGetUpscalingAvailable(MDRNativeApp* app);
int mdrNativeGetAudioPriorityMode(MDRNativeApp* app);
int mdrNativeSetAudioPriorityMode(MDRNativeApp* app, int mode);
int mdrNativeGetAutoPauseEnabled(MDRNativeApp* app);
int mdrNativeSetAutoPauseEnabled(MDRNativeApp* app, int enabled);
int mdrNativeGetHeadGestureEnabled(MDRNativeApp* app);
int mdrNativeSetHeadGestureEnabled(MDRNativeApp* app, int enabled);

int mdrNativeGetVoiceGuidanceEnabled(MDRNativeApp* app);
int mdrNativeSetVoiceGuidanceEnabled(MDRNativeApp* app, int enabled);
int mdrNativeGetVoiceGuidanceVolume(MDRNativeApp* app);
int mdrNativeSetVoiceGuidanceVolume(MDRNativeApp* app, int volume);

int mdrNativeGetPowerAutoOff(MDRNativeApp* app);
int mdrNativeSetPowerAutoOff(MDRNativeApp* app, int value);
int mdrNativeGetPowerAutoOffWearingDetection(MDRNativeApp* app);
int mdrNativeSetPowerAutoOffWearingDetection(MDRNativeApp* app, int value);

int mdrNativeGetNcAsmButtonFunction(MDRNativeApp* app);
int mdrNativeSetNcAsmButtonFunction(MDRNativeApp* app, int value);
int mdrNativeGetTouchFunctionLeft(MDRNativeApp* app);
int mdrNativeSetTouchFunctionLeft(MDRNativeApp* app, int value);
int mdrNativeGetTouchFunctionRight(MDRNativeApp* app);
int mdrNativeSetTouchFunctionRight(MDRNativeApp* app, int value);

int mdrNativeGetBgmModeEnabled(MDRNativeApp* app);
int mdrNativeSetBgmModeEnabled(MDRNativeApp* app, int enabled);
int mdrNativeGetBgmRoomSize(MDRNativeApp* app);
int mdrNativeSetBgmRoomSize(MDRNativeApp* app, int value);
int mdrNativeGetUpmixCinemaEnabled(MDRNativeApp* app);
int mdrNativeSetUpmixCinemaEnabled(MDRNativeApp* app, int enabled);
int mdrNativeGetListeningMode(MDRNativeApp* app);
int mdrNativeSetListeningMode(MDRNativeApp* app, int mode);
int mdrNativeGetNoiseAdaptiveSensitivity(MDRNativeApp* app);
int mdrNativeSetNoiseAdaptiveSensitivity(MDRNativeApp* app, int value);

int mdrNativeGetBatteryLeft(MDRNativeApp* app);
int mdrNativeGetBatteryRight(MDRNativeApp* app);
int mdrNativeGetBatteryCase(MDRNativeApp* app);
int mdrNativeGetBatteryLeftCharging(MDRNativeApp* app);
int mdrNativeGetBatteryRightCharging(MDRNativeApp* app);
int mdrNativeGetBatteryCaseCharging(MDRNativeApp* app);
int mdrNativeGetBatteryLeftThreshold(MDRNativeApp* app);
int mdrNativeGetBatteryRightThreshold(MDRNativeApp* app);
int mdrNativeGetBatteryCaseThreshold(MDRNativeApp* app);
void mdrNativeCopyModelName(MDRNativeApp* app, char* out, int outSize);
void mdrNativeCopyFirmwareVersion(MDRNativeApp* app, char* out, int outSize);
void mdrNativeCopyUniqueId(MDRNativeApp* app, char* out, int outSize);
void mdrNativeCopyModelSeries(MDRNativeApp* app, char* out, int outSize);
void mdrNativeCopyModelColor(MDRNativeApp* app, char* out, int outSize);
void mdrNativeCopyAudioCodec(MDRNativeApp* app, char* out, int outSize);
void mdrNativeCopyUpscalingType(MDRNativeApp* app, char* out, int outSize);
void mdrNativeCopyLastAlert(MDRNativeApp* app, char* out, int outSize);
void mdrNativeCopyLastInteraction(MDRNativeApp* app, char* out, int outSize);
void mdrNativeCopyLastDeviceJSON(MDRNativeApp* app, char* out, int outSize);

int mdrNativeSetShutdown(MDRNativeApp* app);

int mdrNativeGetPairedDeviceCount(MDRNativeApp* app);
int mdrNativeCopyPairedDevice(MDRNativeApp* app, int index, char* nameOut, int nameOutSize, char* addressOut,
                              int addressOutSize, int* connectedOut, int* activePlaybackOut);
void mdrNativeCopyMultipointDeviceMac(MDRNativeApp* app, char* out, int outSize);
int mdrNativeSetMultipointDeviceMac(MDRNativeApp* app, const char* address);
int mdrNativeGetPairingMode(MDRNativeApp* app);
int mdrNativeSetPairingMode(MDRNativeApp* app, int enabled);
int mdrNativeConnectPairedDevice(MDRNativeApp* app, const char* address);
int mdrNativeDisconnectPairedDevice(MDRNativeApp* app, const char* address);
int mdrNativeUnpairDevice(MDRNativeApp* app, const char* address);

int mdrNativeGetGeneralSettingCount(MDRNativeApp* app);
int mdrNativeCopyGeneralSetting(MDRNativeApp* app, int index, char* titleOut, int titleOutSize, char* summaryOut,
                                int summaryOutSize, int* enabledOut);
int mdrNativeSetGeneralSetting(MDRNativeApp* app, int index, int enabled);

int mdrNativeGetSafeListeningSoundPressure(MDRNativeApp* app);
int mdrNativeGetSafeListeningPreviewMode(MDRNativeApp* app);
int mdrNativeSetSafeListeningPreviewMode(MDRNativeApp* app, int enabled);

const char* mdrNativeGetLastError(MDRNativeApp* app);

#ifdef __cplusplus
}
#endif
