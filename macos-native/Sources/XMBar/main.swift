import AppKit
import ApplicationServices
import Foundation
import IOBluetooth
import QuartzCore
import ServiceManagement

private typealias NativeHandle = OpaquePointer

@_silgen_name("mdrNativeCreate") private func mdrNativeCreate() -> NativeHandle?
@_silgen_name("mdrNativeDestroy") private func mdrNativeDestroy(_ app: NativeHandle?)
@_silgen_name("mdrNativeRefreshDevices") private func mdrNativeRefreshDevices(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetDeviceCount") private func mdrNativeGetDeviceCount(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeCopyDevice") private func mdrNativeCopyDevice(
    _ app: NativeHandle?,
    _ index: Int32,
    _ nameOut: UnsafeMutablePointer<CChar>?,
    _ nameOutSize: Int32,
    _ addressOut: UnsafeMutablePointer<CChar>?,
    _ addressOutSize: Int32
) -> Int32
@_silgen_name("mdrNativeConnect") private func mdrNativeConnect(_ app: NativeHandle?, _ address: UnsafePointer<CChar>?) -> Int32
@_silgen_name("mdrNativeDisconnect") private func mdrNativeDisconnect(_ app: NativeHandle?)
@_silgen_name("mdrNativePoll") private func mdrNativePoll(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeRequestSync") private func mdrNativeRequestSync(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetPhase") private func mdrNativeGetPhase(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetNoiseControlMode") private func mdrNativeGetNoiseControlMode(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetAmbientLevel") private func mdrNativeGetAmbientLevel(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetFocusOnVoice") private func mdrNativeGetFocusOnVoice(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetNoiseControl") private func mdrNativeSetNoiseControl(
    _ app: NativeHandle?,
    _ mode: Int32,
    _ ambientLevel: Int32,
    _ focusOnVoice: Int32
) -> Int32
@_silgen_name("mdrNativeSupportsNoiseCancelling") private func mdrNativeSupportsNoiseCancelling(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsAmbientSound") private func mdrNativeSupportsAmbientSound(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsAutoAmbientSound") private func mdrNativeSupportsAutoAmbientSound(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsSpeakToChat") private func mdrNativeSupportsSpeakToChat(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsListeningMode") private func mdrNativeSupportsListeningMode(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsConnectionQuality") private func mdrNativeSupportsConnectionQuality(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsUpscaling") private func mdrNativeSupportsUpscaling(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsAssignableSettings") private func mdrNativeSupportsAssignableSettings(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsNcAsmButtonSettings") private func mdrNativeSupportsNcAsmButtonSettings(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsHeadGesture") private func mdrNativeSupportsHeadGesture(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsAutoPowerOff") private func mdrNativeSupportsAutoPowerOff(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsAutoPowerOffWearingDetection") private func mdrNativeSupportsAutoPowerOffWearingDetection(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsAutoPause") private func mdrNativeSupportsAutoPause(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsVoiceGuidance") private func mdrNativeSupportsVoiceGuidance(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsVoiceGuidanceVolume") private func mdrNativeSupportsVoiceGuidanceVolume(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsPlaybackControl") private func mdrNativeSupportsPlaybackControl(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsPowerOff") private func mdrNativeSupportsPowerOff(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsPairingDeviceManagement") private func mdrNativeSupportsPairingDeviceManagement(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSupportsSafeListening") private func mdrNativeSupportsSafeListening(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetSpeakToChatEnabled") private func mdrNativeGetSpeakToChatEnabled(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetSpeakToChatEnabled") private func mdrNativeSetSpeakToChatEnabled(_ app: NativeHandle?, _ enabled: Int32) -> Int32
@_silgen_name("mdrNativeGetSpeakToChatSensitivity") private func mdrNativeGetSpeakToChatSensitivity(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetSpeakToChatSensitivity") private func mdrNativeSetSpeakToChatSensitivity(_ app: NativeHandle?, _ sensitivity: Int32) -> Int32
@_silgen_name("mdrNativeGetSpeakToChatModeOutTime") private func mdrNativeGetSpeakToChatModeOutTime(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetSpeakToChatModeOutTime") private func mdrNativeSetSpeakToChatModeOutTime(_ app: NativeHandle?, _ modeOutTime: Int32) -> Int32
@_silgen_name("mdrNativeGetEqAvailable") private func mdrNativeGetEqAvailable(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetEqPreset") private func mdrNativeGetEqPreset(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetEqPreset") private func mdrNativeSetEqPreset(_ app: NativeHandle?, _ preset: Int32) -> Int32
@_silgen_name("mdrNativeGetEqClearBass") private func mdrNativeGetEqClearBass(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetEqClearBass") private func mdrNativeSetEqClearBass(_ app: NativeHandle?, _ value: Int32) -> Int32
@_silgen_name("mdrNativeGetEqBandCount") private func mdrNativeGetEqBandCount(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetEqBand") private func mdrNativeGetEqBand(_ app: NativeHandle?, _ index: Int32) -> Int32
@_silgen_name("mdrNativeSetEqBand") private func mdrNativeSetEqBand(_ app: NativeHandle?, _ index: Int32, _ value: Int32) -> Int32
@_silgen_name("mdrNativeGetPlayVolume") private func mdrNativeGetPlayVolume(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetPlayVolume") private func mdrNativeSetPlayVolume(_ app: NativeHandle?, _ volume: Int32) -> Int32
@_silgen_name("mdrNativeGetPlaybackStatus") private func mdrNativeGetPlaybackStatus(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetPlaybackControl") private func mdrNativeSetPlaybackControl(_ app: NativeHandle?, _ control: Int32) -> Int32
@_silgen_name("mdrNativeCopyTrackTitle") private func mdrNativeCopyTrackTitle(
    _ app: NativeHandle?,
    _ out: UnsafeMutablePointer<CChar>?,
    _ outSize: Int32
)
@_silgen_name("mdrNativeCopyTrackAlbum") private func mdrNativeCopyTrackAlbum(
    _ app: NativeHandle?,
    _ out: UnsafeMutablePointer<CChar>?,
    _ outSize: Int32
)
@_silgen_name("mdrNativeCopyTrackArtist") private func mdrNativeCopyTrackArtist(
    _ app: NativeHandle?,
    _ out: UnsafeMutablePointer<CChar>?,
    _ outSize: Int32
)
@_silgen_name("mdrNativeGetUpscalingEnabled") private func mdrNativeGetUpscalingEnabled(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetUpscalingEnabled") private func mdrNativeSetUpscalingEnabled(_ app: NativeHandle?, _ enabled: Int32) -> Int32
@_silgen_name("mdrNativeGetUpscalingAvailable") private func mdrNativeGetUpscalingAvailable(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetAudioPriorityMode") private func mdrNativeGetAudioPriorityMode(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetAudioPriorityMode") private func mdrNativeSetAudioPriorityMode(_ app: NativeHandle?, _ mode: Int32) -> Int32
@_silgen_name("mdrNativeGetAutoPauseEnabled") private func mdrNativeGetAutoPauseEnabled(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetAutoPauseEnabled") private func mdrNativeSetAutoPauseEnabled(_ app: NativeHandle?, _ enabled: Int32) -> Int32
@_silgen_name("mdrNativeGetHeadGestureEnabled") private func mdrNativeGetHeadGestureEnabled(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetHeadGestureEnabled") private func mdrNativeSetHeadGestureEnabled(_ app: NativeHandle?, _ enabled: Int32) -> Int32
@_silgen_name("mdrNativeGetVoiceGuidanceEnabled") private func mdrNativeGetVoiceGuidanceEnabled(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetVoiceGuidanceEnabled") private func mdrNativeSetVoiceGuidanceEnabled(_ app: NativeHandle?, _ enabled: Int32) -> Int32
@_silgen_name("mdrNativeGetVoiceGuidanceVolume") private func mdrNativeGetVoiceGuidanceVolume(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetVoiceGuidanceVolume") private func mdrNativeSetVoiceGuidanceVolume(_ app: NativeHandle?, _ volume: Int32) -> Int32
@_silgen_name("mdrNativeGetPowerAutoOff") private func mdrNativeGetPowerAutoOff(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetPowerAutoOff") private func mdrNativeSetPowerAutoOff(_ app: NativeHandle?, _ value: Int32) -> Int32
@_silgen_name("mdrNativeGetPowerAutoOffWearingDetection") private func mdrNativeGetPowerAutoOffWearingDetection(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetPowerAutoOffWearingDetection") private func mdrNativeSetPowerAutoOffWearingDetection(_ app: NativeHandle?, _ value: Int32) -> Int32
@_silgen_name("mdrNativeGetNcAsmButtonFunction") private func mdrNativeGetNcAsmButtonFunction(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetNcAsmButtonFunction") private func mdrNativeSetNcAsmButtonFunction(_ app: NativeHandle?, _ value: Int32) -> Int32
@_silgen_name("mdrNativeGetTouchFunctionLeft") private func mdrNativeGetTouchFunctionLeft(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetTouchFunctionLeft") private func mdrNativeSetTouchFunctionLeft(_ app: NativeHandle?, _ value: Int32) -> Int32
@_silgen_name("mdrNativeGetTouchFunctionRight") private func mdrNativeGetTouchFunctionRight(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetTouchFunctionRight") private func mdrNativeSetTouchFunctionRight(_ app: NativeHandle?, _ value: Int32) -> Int32
@_silgen_name("mdrNativeGetBgmModeEnabled") private func mdrNativeGetBgmModeEnabled(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetBgmModeEnabled") private func mdrNativeSetBgmModeEnabled(_ app: NativeHandle?, _ enabled: Int32) -> Int32
@_silgen_name("mdrNativeGetBgmRoomSize") private func mdrNativeGetBgmRoomSize(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetBgmRoomSize") private func mdrNativeSetBgmRoomSize(_ app: NativeHandle?, _ value: Int32) -> Int32
@_silgen_name("mdrNativeGetUpmixCinemaEnabled") private func mdrNativeGetUpmixCinemaEnabled(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetUpmixCinemaEnabled") private func mdrNativeSetUpmixCinemaEnabled(_ app: NativeHandle?, _ enabled: Int32) -> Int32
@_silgen_name("mdrNativeGetListeningMode") private func mdrNativeGetListeningMode(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetListeningMode") private func mdrNativeSetListeningMode(_ app: NativeHandle?, _ mode: Int32) -> Int32
@_silgen_name("mdrNativeGetNoiseAdaptiveSensitivity") private func mdrNativeGetNoiseAdaptiveSensitivity(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetNoiseAdaptiveSensitivity") private func mdrNativeSetNoiseAdaptiveSensitivity(_ app: NativeHandle?, _ value: Int32) -> Int32
@_silgen_name("mdrNativeGetBatteryLeft") private func mdrNativeGetBatteryLeft(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetBatteryRight") private func mdrNativeGetBatteryRight(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetBatteryCase") private func mdrNativeGetBatteryCase(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetBatteryLeftCharging") private func mdrNativeGetBatteryLeftCharging(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetBatteryRightCharging") private func mdrNativeGetBatteryRightCharging(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetBatteryCaseCharging") private func mdrNativeGetBatteryCaseCharging(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetBatteryLeftThreshold") private func mdrNativeGetBatteryLeftThreshold(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetBatteryRightThreshold") private func mdrNativeGetBatteryRightThreshold(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetBatteryCaseThreshold") private func mdrNativeGetBatteryCaseThreshold(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeCopyModelName") private func mdrNativeCopyModelName(
    _ app: NativeHandle?,
    _ out: UnsafeMutablePointer<CChar>?,
    _ outSize: Int32
)
@_silgen_name("mdrNativeCopyFirmwareVersion") private func mdrNativeCopyFirmwareVersion(
    _ app: NativeHandle?,
    _ out: UnsafeMutablePointer<CChar>?,
    _ outSize: Int32
)
@_silgen_name("mdrNativeCopyUniqueId") private func mdrNativeCopyUniqueId(_ app: NativeHandle?, _ out: UnsafeMutablePointer<CChar>?, _ outSize: Int32)
@_silgen_name("mdrNativeCopyModelSeries") private func mdrNativeCopyModelSeries(_ app: NativeHandle?, _ out: UnsafeMutablePointer<CChar>?, _ outSize: Int32)
@_silgen_name("mdrNativeCopyModelColor") private func mdrNativeCopyModelColor(_ app: NativeHandle?, _ out: UnsafeMutablePointer<CChar>?, _ outSize: Int32)
@_silgen_name("mdrNativeCopyAudioCodec") private func mdrNativeCopyAudioCodec(_ app: NativeHandle?, _ out: UnsafeMutablePointer<CChar>?, _ outSize: Int32)
@_silgen_name("mdrNativeCopyUpscalingType") private func mdrNativeCopyUpscalingType(_ app: NativeHandle?, _ out: UnsafeMutablePointer<CChar>?, _ outSize: Int32)
@_silgen_name("mdrNativeCopyLastAlert") private func mdrNativeCopyLastAlert(_ app: NativeHandle?, _ out: UnsafeMutablePointer<CChar>?, _ outSize: Int32)
@_silgen_name("mdrNativeCopyLastInteraction") private func mdrNativeCopyLastInteraction(_ app: NativeHandle?, _ out: UnsafeMutablePointer<CChar>?, _ outSize: Int32)
@_silgen_name("mdrNativeCopyLastDeviceJSON") private func mdrNativeCopyLastDeviceJSON(_ app: NativeHandle?, _ out: UnsafeMutablePointer<CChar>?, _ outSize: Int32)
@_silgen_name("mdrNativeSetShutdown") private func mdrNativeSetShutdown(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetPairedDeviceCount") private func mdrNativeGetPairedDeviceCount(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeCopyPairedDevice") private func mdrNativeCopyPairedDevice(
    _ app: NativeHandle?,
    _ index: Int32,
    _ nameOut: UnsafeMutablePointer<CChar>?,
    _ nameOutSize: Int32,
    _ addressOut: UnsafeMutablePointer<CChar>?,
    _ addressOutSize: Int32,
    _ connectedOut: UnsafeMutablePointer<Int32>?,
    _ activePlaybackOut: UnsafeMutablePointer<Int32>?
) -> Int32
@_silgen_name("mdrNativeCopyMultipointDeviceMac") private func mdrNativeCopyMultipointDeviceMac(_ app: NativeHandle?, _ out: UnsafeMutablePointer<CChar>?, _ outSize: Int32)
@_silgen_name("mdrNativeSetMultipointDeviceMac") private func mdrNativeSetMultipointDeviceMac(_ app: NativeHandle?, _ address: UnsafePointer<CChar>?) -> Int32
@_silgen_name("mdrNativeGetPairingMode") private func mdrNativeGetPairingMode(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetPairingMode") private func mdrNativeSetPairingMode(_ app: NativeHandle?, _ enabled: Int32) -> Int32
@_silgen_name("mdrNativeConnectPairedDevice") private func mdrNativeConnectPairedDevice(_ app: NativeHandle?, _ address: UnsafePointer<CChar>?) -> Int32
@_silgen_name("mdrNativeDisconnectPairedDevice") private func mdrNativeDisconnectPairedDevice(_ app: NativeHandle?, _ address: UnsafePointer<CChar>?) -> Int32
@_silgen_name("mdrNativeUnpairDevice") private func mdrNativeUnpairDevice(_ app: NativeHandle?, _ address: UnsafePointer<CChar>?) -> Int32
@_silgen_name("mdrNativeGetGeneralSettingCount") private func mdrNativeGetGeneralSettingCount(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeCopyGeneralSetting") private func mdrNativeCopyGeneralSetting(
    _ app: NativeHandle?,
    _ index: Int32,
    _ titleOut: UnsafeMutablePointer<CChar>?,
    _ titleOutSize: Int32,
    _ summaryOut: UnsafeMutablePointer<CChar>?,
    _ summaryOutSize: Int32,
    _ enabledOut: UnsafeMutablePointer<Int32>?
) -> Int32
@_silgen_name("mdrNativeSetGeneralSetting") private func mdrNativeSetGeneralSetting(_ app: NativeHandle?, _ index: Int32, _ enabled: Int32) -> Int32
@_silgen_name("mdrNativeGetSafeListeningSoundPressure") private func mdrNativeGetSafeListeningSoundPressure(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeGetSafeListeningPreviewMode") private func mdrNativeGetSafeListeningPreviewMode(_ app: NativeHandle?) -> Int32
@_silgen_name("mdrNativeSetSafeListeningPreviewMode") private func mdrNativeSetSafeListeningPreviewMode(_ app: NativeHandle?, _ enabled: Int32) -> Int32
@_silgen_name("mdrNativeGetLastError") private func mdrNativeGetLastError(_ app: NativeHandle?) -> UnsafePointer<CChar>?

private enum NativePhase: Int32 {
    case idle = 0
    case connecting = 1
    case initializing = 2
    case syncing = 3
    case ready = 4
    case committing = 5
    case error = 6

    var isBusy: Bool {
        switch self {
        case .connecting, .initializing, .syncing, .committing:
            return true
        case .idle, .ready, .error:
            return false
        }
    }
}

private enum NoiseMode: Int32 {
    case off = 0
    case noiseCancelling = 1
    case ambient = 2
    case adaptive = 3
}

private struct BluetoothDevice: Equatable {
    let name: String
    let address: String
    let isConnectedToMac: Bool

    var displayName: String {
        name.isEmpty ? "Bluetooth Device" : name
    }
}

private struct PairedMDRDevice: Equatable {
    let name: String
    let address: String
    let isConnectedToHeadphones: Bool
    let isActivePlaybackDevice: Bool

    var displayName: String {
        name.isEmpty ? "Bluetooth Device" : name
    }
}

private struct GeneralSettingItem: Equatable {
    let index: Int
    let titleKey: String
    let summaryKey: String
    let isEnabled: Bool
}

private struct PopupOption {
    let title: String
    let value: Int
}

private struct QuickControlDefinition {
    let id: String
    let title: String
    let symbol: String
    let accessorySymbol: String?
    let help: String
}


private struct ShortcutDefinition {
    let id: String
    let title: String
    let symbol: String
    let accessorySymbol: String?
    let help: String
}

private struct KeyboardShortcut: Equatable {
    let keyCode: UInt16
    let modifiers: NSEvent.ModifierFlags
    let characters: String

    static let allowedModifiers: NSEvent.ModifierFlags = [.command, .option, .control, .shift]

    var normalizedModifiers: NSEvent.ModifierFlags {
        modifiers.intersection(Self.allowedModifiers)
    }

    var displayString: String {
        var parts: [String] = []
        let normalized = normalizedModifiers
        if normalized.contains(.control) { parts.append("⌃") }
        if normalized.contains(.option) { parts.append("⌥") }
        if normalized.contains(.shift) { parts.append("⇧") }
        if normalized.contains(.command) { parts.append("⌘") }
        parts.append(displayKey)
        return parts.joined()
    }

    private var displayKey: String {
        switch keyCode {
        case 36: return "↩"
        case 48: return "⇥"
        case 49: return "Espacio"
        case 51: return "⌫"
        case 53: return "Esc"
        case 123: return "←"
        case 124: return "→"
        case 125: return "↓"
        case 126: return "↑"
        default:
            let trimmed = characters.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? "Tecla \(keyCode)" : trimmed.uppercased()
        }
    }

    var storageString: String {
        "\(keyCode)|\(normalizedModifiers.rawValue)|\(characters)"
    }

    static func fromStorage(_ value: String?) -> KeyboardShortcut? {
        guard let value else { return nil }
        let parts = value.split(separator: "|", omittingEmptySubsequences: false)
        guard parts.count >= 3,
              let keyCode = UInt16(parts[0]),
              let raw = UInt(parts[1]) else {
            return nil
        }
        return KeyboardShortcut(
            keyCode: keyCode,
            modifiers: NSEvent.ModifierFlags(rawValue: raw),
            characters: String(parts[2])
        )
    }

    static func fromEvent(_ event: NSEvent) -> KeyboardShortcut? {
        let normalized = event.modifierFlags.intersection(allowedModifiers)
        guard !normalized.isEmpty else { return nil }
        guard event.keyCode != 53 else { return nil }
        let chars = event.charactersIgnoringModifiers ?? event.characters ?? ""
        return KeyboardShortcut(keyCode: event.keyCode, modifiers: normalized, characters: chars)
    }

    func matches(_ event: NSEvent) -> Bool {
        let normalized = event.modifierFlags.intersection(Self.allowedModifiers)
        return keyCode == event.keyCode && normalized == normalizedModifiers
    }
}

private final class FlippedView: NSView {
    override var isFlipped: Bool {
        true
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    private let native = mdrNativeCreate()
    private let selectedAddressKey = "XMBar.selectedAddress"
    private let selectedNameKey = "XMBar.selectedName"
    private let quickControlPrefix = "XMBar.quickControl."
    private let shortcutPrefix = "XMBar.shortcut."
    private let hideWhenDisconnectedKey = "XMBar.hideWhenDisconnected"
    private let notificationPillEnabledKey = "XMBar.notificationPillEnabled"
    private let launchAtLoginPreferenceKey = "XMBar.launchAtLoginPreference"
    private let languageKey = "XMBar.language"

    private var statusItem: NSStatusItem?
    private let popover = NSPopover()
    private var pollTimer: Timer?
    private var cachedDevices: [BluetoothDevice] = []
    private var selectedAddress: String?
    private var selectedName: String?
    private var lastRenderSignature = ""
    private var lastAdvancedRenderSignature = ""
    private var deviceListExpanded = false
    private var advancedDeviceListExpanded = false
    private var commitStartedAt: Date?
    private var showDelayedCommit = false
    private var advancedSettingSyncStartedAt: Date?
    private var advancedSettingReconnectQuietUntil = Date.distantPast
    private let advancedSettingSyncTimeout: TimeInterval = 8
    private let advancedSettingReconnectQuietInterval: TimeInterval = 28
    private var advancedWindow: NSWindow?
    private weak var advancedScrollView: NSScrollView?
    private var activeAdvancedHelpPopover: NSPopover?
    private var autoReconnectEnabled = true
    private var silentAutoConnectInProgress = false
    private var nextAutoReconnectAt = Date.distantPast
    private var nextAutoRefreshDevicesAt = Date.distantPast
    private var autoReconnectBackoff: TimeInterval = 2
    private var lastAutoReconnectAttemptAt = Date.distantPast
    private let autoReconnectRefreshInterval: TimeInterval = 10
    private let autoReconnectMaximumBackoff: TimeInterval = 24
    private var nextConnectionHealthCheckAt = Date.distantPast
    private let connectionHealthCheckInterval: TimeInterval = 12
    private var connectionAttemptStartedAt: Date?
    private var connectionRetryCount = 0
    private var connectionRetryScheduled = false
    private var lastConnectionAttemptAddress: String?
    private let connectionAttemptTimeout: TimeInterval = 16
    private let connectionRetryPause: TimeInterval = 2.5
    private let connectionRetryRefreshInterval: TimeInterval = 5
    private let maximumConsecutiveConnectionRetries = 8
    private var nextConnectionRetryRefreshAt = Date.distantPast
    private var lastObservedPhase: NativePhase?
    private var lastObservedNoiseMode: NoiseMode?
    private var notifiedBatteryThresholds: Set<Int> = []
    private let batteryWarningThresholds: Set<Int> = [20, 15, 10, 5, 1]
    private var suppressProgrammaticNoisePillUntil = Date.distantPast
    private var notificationPillWindow: NSWindow?
    private var notificationPillDismissWorkItem: DispatchWorkItem?
    private var pendingPlayVolumeValue: Int32?
    private var pendingVoiceGuidanceVolumeValue: Int32?
    private var playVolumeApplyTimer: Timer?
    private var voiceGuidanceVolumeApplyTimer: Timer?
    private var lastAdvancedSettingCommandAt = Date.distantPast
    private let volumeSliderDebounceInterval: TimeInterval = 0.65
    private let advancedSettingMinimumCommandSpacing: TimeInterval = 1.15
    private var localShortcutMonitor: Any?
    private var globalShortcutMonitor: Any?
    private var recordingShortcutID: String?

    private enum AppLanguage: String {
        case spanish = "es"
        case english = "en"
    }

    private enum LanguageSetting: String {
        case system = "system"
        case spanish = "es"
        case english = "en"
    }

    private static let languageOptions: [PopupOption] = [
        PopupOption(title: "Sistema", value: 0),
        PopupOption(title: "Español", value: 1),
        PopupOption(title: "English", value: 2)
    ]

    private static let englishStrings: [String: String] = [
        "Configuracion XMBar": "XMBar Settings",
        "Selecciona un dispositivo": "Select a device",
        "Conecta los WH-1000XM5 desde el menu para activar estos ajustes.": "Connect the WH-1000XM5 from the menu to enable these settings.",
        "La app esta preparando la conexion MDR. Los ajustes se activaran al terminar.": "XMBar is preparing the MDR connection. Settings will be enabled when it finishes.",
        "Los audifonos estan aplicando el ultimo cambio.": "The headphones are applying the latest change.",
        "Aplicando cambios...": "Applying changes...",
        "Conectando...": "Connecting...",
        "Inicializando MDR...": "Initializing MDR...",
        "Sincronizando...": "Syncing...",
        "Conectado": "Connected",
        "Desactivado": "Disabled",
        "Activado": "Enabled",
        "Ambiente": "Ambient",
        "Cancelar ruido": "Noise cancelling",
        "Cancelación de ruido": "Noise cancelling",
        "Control de ruido": "Noise control",
        "Nivel ambiente": "Ambient level",
        "Reconocimiento de conversacion": "Speak-to-chat",
        "Reconocimiento de conversación": "Speak-to-chat",
        "Modo pasivo": "Passive mode",
        "Sonido": "Sound",
        "Volumen": "Volume",
        "Volumen guia": "Voice guide volume",
        "Guia de voz": "Voice guidance",
        "Reproduccion": "Playback",
        "Reproducción": "Playback",
        "Titulo": "Title",
        "Album": "Album",
        "Artista": "Artist",
        "Anterior": "Previous",
        "Reproducir": "Play",
        "Pausar": "Pause",
        "Siguiente": "Next",
        "Controles de reproduccion": "Playback controls",
        "Sin informacion de reproduccion.": "No playback information.",
        "DSEE / upscaling": "DSEE / upscaling",
        "DSEE disponible": "DSEE available",
        "Tipo DSEE": "DSEE type",
        "Prioridad": "Priority",
        "Calidad de sonido": "Sound quality",
        "Conexion estable": "Stable connection",
        "Baja latencia": "Low latency",
        "Modo escucha": "Listening mode",
        "Espacio BGM": "BGM space",
        "Mi habitacion": "My room",
        "Sala": "Room",
        "Cafe": "Cafe",
        "Conversacion y comodidad": "Conversation and comfort",
        "Sensibilidad": "Sensitivity",
        "Duracion": "Duration",
        "Rapido": "Fast",
        "Medio": "Medium",
        "Lento": "Slow",
        "No terminar": "Do not end",
        "Auto": "Auto",
        "Alta": "High",
        "Baja": "Low",
        "Estandar": "Standard",
        "Sensibilidad auto ambiente": "Auto ambient sensitivity",
        "Pausar al retirar": "Pause when removed",
        "Gestos de cabeza": "Head gestures",
        "Sistema": "System",
        "Idioma": "Language",
        "Lanzar XMBar con el sistema": "Launch XMBar at login",
        "Ocultar XMBar al desconectar": "Hide XMBar when disconnected",
        "Mostrar pildora emergente": "Show notification pill",
        "Apagado automatico": "Automatic power off",
        "Apagado por sensor": "Sensor power off",
        "No apagar": "Do not turn off",
        "5 min sin Bluetooth": "5 min without Bluetooth",
        "15 min sin Bluetooth": "15 min without Bluetooth",
        "30 min sin Bluetooth": "30 min without Bluetooth",
        "1 hora sin Bluetooth": "1 hour without Bluetooth",
        "3 horas sin Bluetooth": "3 hours without Bluetooth",
        "Al retirar audifonos": "When headphones are removed",
        "Controles": "Controls",
        "Boton NC/AMB": "NC/AMB button",
        "Touch izquierdo": "Left touch",
        "Touch derecho": "Right touch",
        "Sin funcion": "No function",
        "Dispositivos MDR": "MDR devices",
        "Emparejado con audifonos": "Paired with headphones",
        "Conectado a audifonos": "Connected to headphones",
        "Audio activo": "Active audio",
        "Activar como audio": "Set as audio source",
        "Conectar": "Connect",
        "Desconectar": "Disconnect",
        "Desemparejar": "Unpair",
        "Modo emparejamiento": "Pairing mode",
        "Iniciar emparejamiento": "Start pairing",
        "Detener emparejamiento": "Stop pairing",
        "No hay dispositivos MDR reportados.": "No MDR devices reported.",
        "Sin datos MDR de dispositivos. Activa multipoint en ajustes generales si el modelo lo requiere.": "No MDR device data. Enable multipoint in general settings if the model requires it.",
        "Ajustes generales MDR": "MDR general settings",
        "Escucha segura": "Safe listening",
        "Presion sonora": "Sound pressure",
        "Modo seguro": "Safe mode",
        "Bateria MDR": "MDR battery",
        "Bateria": "Battery",
        "Izquierdo": "Left",
        "Derecho": "Right",
        "Estuche": "Case",
        "Cargando": "Charging",
        "Cargado": "Charged",
        "No cargando": "Not charging",
        "Estado de carga desconocido": "Charge status unknown",
        "Umbral": "Threshold",
        "Informacion MDR": "MDR information",
        "Modelo": "Model",
        "MAC": "MAC",
        "Firmware": "Firmware",
        "Serie": "Series",
        "Color": "Color",
        "Codec": "Codec",
        "Alerta": "Alert",
        "Mensaje MDR": "MDR message",
        "JSON dispositivo": "Device JSON",
        "No disponible": "Not available",
        "Apagar audifonos": "Power off headphones",
        "Apagar": "Power off",
        "Ajuste MDR": "MDR setting",
        "Conectar a 2 dispositivos simultaneamente": "Connect to 2 devices simultaneously",
        "Capturar voz durante llamada": "Capture voice during a phone call",
        "Panel tactil": "Touch sensor control panel",
        "Permite usar los audifonos con dos dispositivos al mismo tiempo. Con conexiones simultaneas, LDAC puede no estar disponible.": "Allows the headphones to be used with two devices at the same time. With simultaneous connections, LDAC may be unavailable.",
        "Permite usar los audifonos con dos dispositivos al mismo tiempo.": "Allows the headphones to be used with two devices at the same time.",
        "Hace que tu propia voz sea mas facil de escuchar durante llamadas.": "Makes your own voice easier to hear during calls.",
        "Controles rapidos": "Quick controls",
        "Atajos": "Shortcuts",
        "Sin asignar": "Unassigned",
        "Pulsa atajo...": "Press shortcut...",
        "Quitar atajo": "Remove shortcut",
        "Abrir panel": "Open panel",
        "Abrir configuracion": "Open settings",
        "Activar cancelacion": "Turn on noise cancelling",
        "Activar ambiente": "Turn on ambient mode",
        "Bajar volumen": "Volume down",
        "Subir volumen": "Volume up",
        "Bajar volumen guia": "Voice guide volume down",
        "Subir volumen guia": "Voice guide volume up",
        "Ecualizador": "Equalizer",
        "Preset": "Preset",
        "Clear Bass": "Clear Bass",
        "El ecualizador no reporto bandas configurables.": "The equalizer did not report configurable bands.",
        "Dispositivos": "Devices",
        "Mostrar dispositivos Bluetooth": "Show Bluetooth devices",
        "Ocultar dispositivos Bluetooth": "Hide Bluetooth devices",
        "No hay dispositivos Bluetooth visibles.": "No visible Bluetooth devices.",
        "No hay dispositivos emparejados visibles.": "No visible paired devices.",
        "Muestra la lista de dispositivos Bluetooth en el panel principal cuando se despliega la flecha.": "Shows the Bluetooth device list in the main panel when the arrow is expanded.",
        "Sin dispositivos emparejados": "No paired devices",
        "Conectado al Mac": "Connected to Mac",
        "No conectado al Mac": "Not connected to Mac",
        "Configuracion de los auriculares...": "Headphone settings...",
        "Configuracion de Sonido...": "Sound Settings...",
        "Salir": "Quit",
        "By Globular · V0.82": "By Globular · V0.82",
        "Que hace esta opcion": "What does this option do?",
        "XMBar necesita permiso para atajos globales": "XMBar needs permission for global shortcuts",
        "Abrir Configuracion": "Open Settings",
        "Continuar": "Continue",
        "OK": "OK",
        "Valor": "Value",
        "Esta opcion requiere macOS 13 o superior.": "This option requires macOS 13 or later.",
        "Inicio con el sistema": "Launch at login",
        "No se pudo cambiar el inicio con el sistema: ": "Could not change launch at login: ",
        "Asigna combinaciones de teclado. Por defecto no hay ninguna asignada. Para usar atajos globales, macOS puede pedir permiso de accesibilidad.": "Assign keyboard shortcuts. None are assigned by default. macOS may require Accessibility permission for global shortcuts.",
        "Controla esta funcion de los auriculares cuando el modelo conectado la soporta.": "Controls this headphone feature when the connected model supports it.",
        "Controla el volumen interno que reportan los auriculares.": "Controls the internal volume reported by the headphones.",
        "Alterna DSEE / upscaling cuando el modelo lo soporta.": "Toggles DSEE / upscaling when the model supports it.",
        "Alterna los avisos hablados de los auriculares.": "Toggles spoken headphone status prompts.",
        "Permite ajustar rapidamente el volumen de los avisos hablados.": "Allows quick adjustment of spoken prompt volume.",
        "Elige que hace el boton fisico de cancelacion de ruido y ambiente.": "Chooses what the physical NC/AMB button does.",
        "Asigna la funcion principal del panel tactil izquierdo, si tu modelo lo permite.": "Assigns the main function of the left touch panel, if your model allows it.",
        "Asigna la funcion principal del panel tactil derecho, si tu modelo lo permite.": "Assigns the main function of the right touch panel, if your model allows it.",
        "Oculta el icono de la barra cuando no hay auriculares conectados. Al abrir XMBar desde Finder o Spotlight se mostrara Configuracion para no quedar inaccesible.": "Hides the menu bar icon when headphones are disconnected. Opening XMBar from Finder or Spotlight will show Settings so it remains accessible.",
        "Muestra la pildora discreta cuando los auriculares se conectan, cambia el modo de ruido desde el boton fisico o llegan a bateria baja.": "Shows the subtle notification pill when headphones connect, noise mode changes from the physical button, or battery reaches a low threshold.",
        "Cambia el idioma de XMBar. El cambio se aplica inmediatamente a la interfaz. Si usas Sistema, XMBar usara el idioma de macOS; si no esta soportado, usara English.": "Changes XMBar's language immediately. If you choose System, XMBar uses macOS language; unsupported languages fall back to English.",
        "Intenta mejorar audio comprimido reconstruyendo parte de las frecuencias perdidas.": "Attempts to improve compressed audio by reconstructing some lost frequencies.",
        "Ajusta esta banda del ecualizador. Valores positivos realzan esa frecuencia; negativos la reducen.": "Adjusts this equalizer band. Positive values boost that frequency; negative values reduce it.",
        "Muestra los accesos rapidos de ambiente, cancelacion de ruido y modo pasivo en el panel principal.": "Shows quick access to ambient mode, noise cancelling, and passive mode in the main panel.",
        "Muestra el deslizador de intensidad del modo ambiente cuando el modelo lo soporta.": "Shows the ambient mode intensity slider when the model supports it.",
        "Muestra el interruptor rapido para activar o desactivar el reconocimiento de conversacion.": "Shows a quick switch to enable or disable speak-to-chat.",
        "Muestra un deslizador de volumen en el panel principal. El cambio se aplica con espera corta para no saturar la conexion.": "Shows a volume slider in the main panel. Changes are applied after a short delay to avoid saturating the connection.",
        "Muestra un acceso rapido para activar o desactivar la mejora de audio comprimido.": "Shows a quick control to enable or disable compressed-audio enhancement.",
        "Muestra un acceso rapido para activar o desactivar los avisos hablados de los auriculares.": "Shows a quick control to enable or disable spoken headphone prompts.",
        "Permite tener visible el ajuste de la funcion del boton fisico NC/AMB.": "Keeps the physical NC/AMB button function setting visible.",
        "Permite tener visible la funcion asignada al panel tactil izquierdo, si el modelo lo permite.": "Keeps the assigned left touch panel function visible, if the model allows it.",
        "Permite tener visible la funcion asignada al panel tactil derecho, si el modelo lo permite.": "Keeps the assigned right touch panel function visible, if the model allows it.",
        "Abre o trae al frente el panel rapido de XMBar.": "Opens or brings XMBar's quick panel to the front.",
        "Abre la ventana de configuracion de XMBar.": "Opens the XMBar settings window.",
        "Activa directamente la cancelacion de ruido.": "Turns noise cancelling on directly.",
        "Activa directamente el modo ambiente.": "Turns ambient mode on directly.",
        "Desactiva cancelacion y ambiente.": "Turns noise cancelling and ambient mode off.",
        "Alterna el reconocimiento de conversacion.": "Toggles speak-to-chat.",
        "Baja un punto el volumen interno de los auriculares.": "Decreases the headphones' internal volume by one step.",
        "Sube un punto el volumen interno de los auriculares.": "Increases the headphones' internal volume by one step.",
        "Baja un punto el volumen de la guia de voz.": "Decreases voice guide volume by one step.",
        "Sube un punto el volumen de la guia de voz.": "Increases voice guide volume by one step.",
        "Muestra y controla la metadata y reproduccion remota que reportan los auriculares.": "Shows and controls the remote playback metadata reported by the headphones.",
        "Indica si el motor DSEE esta disponible en el estado actual de los auriculares.": "Indicates whether the DSEE engine is available in the headphones' current state.",
        "Muestra el tipo de escalado de audio que reporta el firmware.": "Shows the audio upscaling type reported by the firmware.",
        "Cambia la sensibilidad del modo auto ambiente compatible con los modelos nuevos.": "Changes the sensitivity for auto ambient mode on compatible models.",
        "Gestiona los dispositivos emparejados guardados por los auriculares, incluyendo multipoint.": "Manages paired devices stored by the headphones, including multipoint.",
        "Permite que los auriculares entren o salgan del modo de emparejamiento Bluetooth.": "Lets the headphones enter or leave Bluetooth pairing mode.",
        "Muestra los ajustes generales dinamicos que expone el firmware.": "Shows dynamic general settings exposed by the firmware.",
        "Muestra la presion sonora estimada y el modo seguro si el modelo lo reporta.": "Shows estimated sound pressure and safe mode when reported by the model.",
        "Activa o desactiva el modo seguro de escucha si el modelo lo soporta.": "Turns safe listening mode on or off if the model supports it.",
        "Apaga los auriculares usando el comando MDR POWER_OFF.": "Powers off the headphones using the MDR POWER_OFF command.",
        "Auriculares": "Headphones",
        "Modo ambiente": "Ambient mode",
        "Cambia rapidamente la curva del ecualizador guardada en los auriculares.": "Quickly changes the equalizer curve stored on the headphones.",
        "Ajusta la intensidad de graves sin tocar el resto del ecualizador.": "Adjusts bass intensity without changing the rest of the equalizer.",
        "Elige si prefieres mejor calidad de audio o una conexion Bluetooth mas estable.": "Choose whether you prefer higher sound quality or a more stable Bluetooth connection.",
        "Cambia el procesamiento de sonido espacial o ambiental disponible en el modelo.": "Changes the spatial or ambient sound processing available on this model.",
        "Ajusta el tamano virtual del espacio cuando usas el modo BGM.": "Adjusts the virtual room size when using BGM mode.",
        "Detecta cuando hablas y reduce el audio para facilitar una conversacion.": "Detects when you speak and lowers the audio to make conversation easier.",
        "Define que tan facil se activa el reconocimiento de conversacion.": "Defines how easily speak-to-chat is triggered.",
        "Tiempo que tarda en volver al audio normal despues de dejar de hablar.": "How long it takes to return to normal audio after you stop speaking.",
        "Pausa la reproduccion cuando los auriculares detectan que te los quitaste.": "Pauses playback when the headphones detect that you took them off.",
        "Activa gestos compatibles, como responder o rechazar con movimientos de cabeza.": "Enables supported gestures, such as answering or rejecting with head movements.",
        "Abre XMBar automaticamente al iniciar sesion en macOS.": "Opens XMBar automatically when you sign in to macOS.",
        "Activa los avisos hablados de los auriculares para cambios de estado.": "Enables spoken headphone prompts for status changes.",
        "Ajusta el volumen de los avisos hablados de los auriculares.": "Adjusts the volume of the spoken headphone prompts.",
        "Configura cuando los auriculares se apagan solos para ahorrar bateria.": "Configures when the headphones turn off automatically to save battery.",
        "Usa el sensor de uso para decidir si deben apagarse automaticamente.": "Uses the wearing sensor to decide whether they should turn off automatically.",
    ]

    private func selectedLanguageSetting() -> LanguageSetting {
        guard let stored = UserDefaults.standard.string(forKey: languageKey),
              let setting = LanguageSetting(rawValue: stored) else {
            return .system
        }
        return setting
    }

    private func selectedLanguage() -> AppLanguage {
        switch selectedLanguageSetting() {
        case .spanish:
            return .spanish
        case .english:
            return .english
        case .system:
            return systemLanguage()
        }
    }

    private func systemLanguage() -> AppLanguage {
        let identifiers = Locale.preferredLanguages.map { $0.lowercased() }
        for identifier in identifiers {
            if identifier.hasPrefix("es") {
                return .spanish
            }
            if identifier.hasPrefix("en") {
                return .english
            }
        }
        return .english
    }

    private func languagePopupValue() -> Int {
        switch selectedLanguageSetting() {
        case .system:
            return 0
        case .spanish:
            return 1
        case .english:
            return 2
        }
    }

    private func setSelectedLanguageSetting(_ setting: LanguageSetting) {
        UserDefaults.standard.set(setting.rawValue, forKey: languageKey)
        rebuildAdvancedWindowContent()
        refreshPopoverContent()
    }

    private func tr(_ text: String) -> String {
        guard selectedLanguage() == .english else {
            return text
        }
        return Self.englishStrings[text] ?? text
    }

    private func localizedOptions(_ options: [PopupOption]) -> [PopupOption] {
        options.map { PopupOption(title: tr($0.title), value: $0.value) }
    }

    private static let eqPresetOptions: [PopupOption] = [
        PopupOption(title: "Off", value: 0x00),
        PopupOption(title: "Rock", value: 0x01),
        PopupOption(title: "Pop", value: 0x02),
        PopupOption(title: "Jazz", value: 0x03),
        PopupOption(title: "Dance", value: 0x04),
        PopupOption(title: "EDM", value: 0x05),
        PopupOption(title: "R&B/Hip-Hop", value: 0x06),
        PopupOption(title: "Acoustic", value: 0x07),
        PopupOption(title: "Bright", value: 0x10),
        PopupOption(title: "Excited", value: 0x11),
        PopupOption(title: "Mellow", value: 0x12),
        PopupOption(title: "Relaxed", value: 0x13),
        PopupOption(title: "Vocal", value: 0x14),
        PopupOption(title: "Treble", value: 0x15),
        PopupOption(title: "Bass", value: 0x16),
        PopupOption(title: "Speech", value: 0x17),
        PopupOption(title: "Heavy", value: 0x30),
        PopupOption(title: "Clear", value: 0x31),
        PopupOption(title: "Hard", value: 0x32),
        PopupOption(title: "Soft", value: 0x33),
        PopupOption(title: "Gaming", value: 0x20),
        PopupOption(title: "FPS 1", value: 0x21),
        PopupOption(title: "FPS 2", value: 0x22),
        PopupOption(title: "FPS 3", value: 0x23),
        PopupOption(title: "Custom", value: 0xA0),
        PopupOption(title: "User Setting 1", value: 0xA1),
        PopupOption(title: "User Setting 2", value: 0xA2),
        PopupOption(title: "User Setting 3", value: 0xA3),
        PopupOption(title: "User Setting 4", value: 0xA4),
        PopupOption(title: "User Setting 5", value: 0xA5)
    ]

    private static let audioPriorityOptions: [PopupOption] = [
        PopupOption(title: "Calidad de sonido", value: 0),
        PopupOption(title: "Conexion estable", value: 1),
        PopupOption(title: "Baja latencia", value: 2)
    ]

    private static let speakSensitivityOptions: [PopupOption] = [
        PopupOption(title: "Auto", value: 0),
        PopupOption(title: "Alta", value: 1),
        PopupOption(title: "Baja", value: 2)
    ]

    private static let speakDurationOptions: [PopupOption] = [
        PopupOption(title: "Rapido", value: 0),
        PopupOption(title: "Medio", value: 1),
        PopupOption(title: "Lento", value: 2),
        PopupOption(title: "No terminar", value: 3)
    ]

    private static let noiseAdaptiveSensitivityOptions: [PopupOption] = [
        PopupOption(title: "Estandar", value: 0),
        PopupOption(title: "Alta", value: 1),
        PopupOption(title: "Baja", value: 2)
    ]

    private static let roomSizeOptions: [PopupOption] = [
        PopupOption(title: "Mi habitacion", value: 0),
        PopupOption(title: "Sala", value: 1),
        PopupOption(title: "Cafe", value: 2)
    ]

    private static let powerAutoOffOptions: [PopupOption] = [
        PopupOption(title: "No apagar", value: 0x11),
        PopupOption(title: "5 min sin Bluetooth", value: 0x00),
        PopupOption(title: "15 min sin Bluetooth", value: 0x04),
        PopupOption(title: "30 min sin Bluetooth", value: 0x01),
        PopupOption(title: "1 hora sin Bluetooth", value: 0x02),
        PopupOption(title: "3 horas sin Bluetooth", value: 0x03)
    ]

    private static let powerAutoOffWearingOptions: [PopupOption] = [
        PopupOption(title: "No apagar", value: 0x11),
        PopupOption(title: "Al retirar audifonos", value: 0x10),
        PopupOption(title: "5 min sin Bluetooth", value: 0x00),
        PopupOption(title: "15 min sin Bluetooth", value: 0x04),
        PopupOption(title: "30 min sin Bluetooth", value: 0x01),
        PopupOption(title: "1 hora sin Bluetooth", value: 0x02),
        PopupOption(title: "3 horas sin Bluetooth", value: 0x03)
    ]

    private static let ncAsmButtonOptions: [PopupOption] = [
        PopupOption(title: "Sin funcion", value: 0x00),
        PopupOption(title: "NC / Ambiente / Off", value: 0x01),
        PopupOption(title: "NC / Ambiente", value: 0x02),
        PopupOption(title: "NC / Off", value: 0x03),
        PopupOption(title: "Ambiente / Off", value: 0x04)
    ]

    private static let touchFunctionOptions: [PopupOption] = [
        PopupOption(title: "Reproduccion", value: 0x20),
        PopupOption(title: "Ambiente + Quick Access", value: 0x35),
        PopupOption(title: "Ambiente", value: 0x00),
        PopupOption(title: "Volumen", value: 0x10),
        PopupOption(title: "Pistas", value: 0x21),
        PopupOption(title: "Reconocimiento de voz", value: 0x30),
        PopupOption(title: "Google Assistant", value: 0x31),
        PopupOption(title: "Amazon Alexa", value: 0x32),
        PopupOption(title: "Quick Access", value: 0x36),
        PopupOption(title: "Sin funcion", value: 0xFF)
    ]


    private static let quickControlDefinitions: [QuickControlDefinition] = [
        QuickControlDefinition(id: "devices", title: "Dispositivos", symbol: "headphones", accessorySymbol: nil, help: "Muestra la lista de dispositivos Bluetooth en el panel principal cuando se despliega la flecha."),
        QuickControlDefinition(id: "noiseControl", title: "Control de ruido", symbol: "ear", accessorySymbol: "waveform.slash", help: "Muestra los accesos rapidos de ambiente, cancelacion de ruido y modo pasivo en el panel principal."),
        QuickControlDefinition(id: "ambientLevel", title: "Nivel ambiente", symbol: "slider.horizontal.3", accessorySymbol: nil, help: "Muestra el deslizador de intensidad del modo ambiente cuando el modelo lo soporta."),
        QuickControlDefinition(id: "speakToChat", title: "Reconocimiento de conversacion", symbol: "person.fill", accessorySymbol: "waveform", help: "Muestra el interruptor rapido para activar o desactivar el reconocimiento de conversacion."),
        QuickControlDefinition(id: "volume", title: "Volumen", symbol: "speaker.wave.2", accessorySymbol: nil, help: "Muestra un deslizador de volumen en el panel principal. El cambio se aplica con espera corta para no saturar la conexion."),
        QuickControlDefinition(id: "dsee", title: "DSEE / upscaling", symbol: "wand.and.sparkles", accessorySymbol: nil, help: "Muestra un acceso rapido para activar o desactivar la mejora de audio comprimido."),
        QuickControlDefinition(id: "voiceGuidance", title: "Guia de voz", symbol: "speaker.wave.2", accessorySymbol: "quote.bubble", help: "Muestra un acceso rapido para activar o desactivar los avisos hablados de los auriculares."),
        QuickControlDefinition(id: "voiceGuidanceVolume", title: "Volumen guia", symbol: "speaker.wave.1", accessorySymbol: "slider.horizontal.3", help: "Permite ajustar rapidamente el volumen de los avisos hablados."),
        QuickControlDefinition(id: "ncButton", title: "Boton NC/AMB", symbol: "button.programmable", accessorySymbol: nil, help: "Permite tener visible el ajuste de la funcion del boton fisico NC/AMB."),
        QuickControlDefinition(id: "touchLeft", title: "Touch izquierdo", symbol: "hand.tap", accessorySymbol: "l.circle", help: "Permite tener visible la funcion asignada al panel tactil izquierdo, si el modelo lo permite."),
        QuickControlDefinition(id: "touchRight", title: "Touch derecho", symbol: "hand.tap", accessorySymbol: "r.circle", help: "Permite tener visible la funcion asignada al panel tactil derecho, si el modelo lo permite.")
    ]


    private static let shortcutDefinitions: [ShortcutDefinition] = [
        ShortcutDefinition(id: "openPanel", title: "Abrir panel", symbol: "menubar.rectangle", accessorySymbol: nil, help: "Abre o trae al frente el panel rapido de XMBar."),
        ShortcutDefinition(id: "openSettings", title: "Abrir configuracion", symbol: "gearshape", accessorySymbol: nil, help: "Abre la ventana de configuracion de XMBar."),
        ShortcutDefinition(id: "noiseCancelling", title: "Activar cancelacion", symbol: "ear", accessorySymbol: "waveform.slash", help: "Activa directamente la cancelacion de ruido."),
        ShortcutDefinition(id: "ambient", title: "Activar ambiente", symbol: "ear", accessorySymbol: "waveform", help: "Activa directamente el modo ambiente."),
        ShortcutDefinition(id: "passive", title: "Modo pasivo", symbol: "power", accessorySymbol: nil, help: "Desactiva cancelacion y ambiente."),
        ShortcutDefinition(id: "speakToChat", title: "Reconocimiento de conversacion", symbol: "person.fill", accessorySymbol: "waveform", help: "Alterna el reconocimiento de conversacion."),
        ShortcutDefinition(id: "volumeDown", title: "Bajar volumen", symbol: "speaker.minus", accessorySymbol: nil, help: "Baja un punto el volumen interno de los auriculares."),
        ShortcutDefinition(id: "volumeUp", title: "Subir volumen", symbol: "speaker.plus", accessorySymbol: nil, help: "Sube un punto el volumen interno de los auriculares."),
        ShortcutDefinition(id: "dsee", title: "DSEE / upscaling", symbol: "wand.and.sparkles", accessorySymbol: nil, help: "Alterna DSEE / upscaling cuando el modelo lo soporta."),
        ShortcutDefinition(id: "voiceGuidance", title: "Guia de voz", symbol: "speaker.wave.2", accessorySymbol: "quote.bubble", help: "Alterna los avisos hablados de los auriculares."),
        ShortcutDefinition(id: "voiceGuidanceVolumeDown", title: "Bajar volumen guia", symbol: "speaker.wave.1", accessorySymbol: "minus", help: "Baja un punto el volumen de la guia de voz."),
        ShortcutDefinition(id: "voiceGuidanceVolumeUp", title: "Subir volumen guia", symbol: "speaker.wave.1", accessorySymbol: "plus", help: "Sube un punto el volumen de la guia de voz.")
    ]

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        selectedAddress = UserDefaults.standard.string(forKey: selectedAddressKey)
        selectedName = UserDefaults.standard.string(forKey: selectedNameKey)

        ensureDefaultLaunchAtLogin()
        configureStatusItem()
        configurePopover()
        installShortcutMonitors()
        refreshDevices()
        startPolling()
        autoConnectLastDevice()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self else { return }
            if self.shouldHideStatusItemForCurrentState() {
                self.openAdvancedSettings(nil)
            } else {
                self.showPopover()
            }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        pollTimer?.invalidate()
        playVolumeApplyTimer?.invalidate()
        voiceGuidanceVolumeApplyTimer?.invalidate()
        removeShortcutMonitors()
        mdrNativeDestroy(self.native)
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if shouldHideStatusItemForCurrentState() || statusItem == nil {
            openAdvancedSettings(nil)
        } else {
            showPopover()
        }
        return true
    }

    private func configureStatusItem() {
        if statusItem == nil {
            statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        }
        guard let button = statusItem?.button else {
            return
        }

        button.image = xmbarHeadphonesIcon(pointSize: 17, tint: .labelColor)
        button.image?.isTemplate = false
        button.imagePosition = .imageOnly
        button.title = ""
        button.target = self
        button.action = #selector(togglePopover(_:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }

    private func configurePopover() {
        popover.behavior = .transient
        popover.animates = true
        popover.delegate = self
    }

    private func startPolling() {
        pollTimer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { [weak self] _ in
            self?.tick()
        }
        if let pollTimer {
            RunLoop.main.add(pollTimer, forMode: .common)
        }
    }

    private func tick() {
        _ = mdrNativePoll(self.native)
        updateCommitVisibility()
        updateStatusButton()
        handleConnectionHealthCheck()
        handleConnectionProgressWatchdog()
        handleAutoReconnect()
        handleNotificationPillTriggers()

        let signature = renderSignature()
        if signature != lastRenderSignature {
            lastRenderSignature = signature
            if popover.isShown {
                refreshPopoverContent(updateSignature: false)
            }
        }

        if advancedWindow?.isVisible == true && signature != lastAdvancedRenderSignature {
            lastAdvancedRenderSignature = signature
            rebuildAdvancedWindowContent()
        }
    }

    private func updateCommitVisibility() {
        let rawPhase = phase()

        if rawPhase == .ready || rawPhase == .idle || rawPhase == .error {
            advancedSettingSyncStartedAt = nil
        }

        if rawPhase == .committing {
            if commitStartedAt == nil {
                commitStartedAt = Date()
                showDelayedCommit = false
            } else if let commitStartedAt,
                      Date().timeIntervalSince(commitStartedAt) > 5 {
                showDelayedCommit = true
            }
        } else {
            commitStartedAt = nil
            showDelayedCommit = false
        }
    }

    @objc private func togglePopover(_ sender: Any?) {
        if NSApp.currentEvent?.type == .rightMouseUp {
            showEmergencyMenu()
            return
        }

        if popover.isShown {
            popover.performClose(sender)
        } else {
            showPopover()
        }
    }

    private func showEmergencyMenu() {
        let menu = NSMenu()
        let open = NSMenuItem(title: "Abrir panel", action: #selector(openPanelFromEmergencyMenu(_:)), keyEquivalent: "")
        open.target = self
        menu.addItem(open)

        let quit = NSMenuItem(title: "Salir", action: #selector(quit(_:)), keyEquivalent: "q")
        quit.target = self
        menu.addItem(quit)

        guard let button = statusItem?.button else {
            return
        }
        menu.popUp(positioning: nil, at: NSPoint(x: 0, y: button.bounds.height + 4), in: button)
    }

    private func showPopover() {
        refreshDevices()
        refreshPopoverContent()

        if statusItem == nil {
            configureStatusItem()
        }
        guard let button = statusItem?.button else {
            openAdvancedSettings(nil)
            return
        }

        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func refreshPopoverContent(updateSignature: Bool = true) {
        let controller = NSViewController()
        let view = makePopoverView()
        controller.view = view

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0
            context.allowsImplicitAnimation = false
            popover.contentViewController = controller
            popover.contentSize = view.frame.size
        }

        if updateSignature {
            lastRenderSignature = renderSignature()
        }
    }

    private func refreshDevices() {
        let result = mdrNativeRefreshDevices(self.native)
        guard result == 0 else {
            cachedDevices = []
            return
        }

        var devices: [BluetoothDevice] = []
        let count = max(0, Int(mdrNativeGetDeviceCount(self.native)))

        for index in 0..<count {
            var nameBuffer = [CChar](repeating: 0, count: 128)
            var addressBuffer = [CChar](repeating: 0, count: 18)
            let nameBufferSize = Int32(nameBuffer.count)
            let addressBufferSize = Int32(addressBuffer.count)
            let copyResult = nameBuffer.withUnsafeMutableBufferPointer { namePointer in
                addressBuffer.withUnsafeMutableBufferPointer { addressPointer in
                    mdrNativeCopyDevice(
                        native,
                        Int32(index),
                        namePointer.baseAddress,
                        nameBufferSize,
                        addressPointer.baseAddress,
                        addressBufferSize
                    )
                }
            }

            if copyResult == 0 {
                let address = String(cString: addressBuffer)
                devices.append(BluetoothDevice(
                    name: String(cString: nameBuffer),
                    address: address,
                    isConnectedToMac: bluetoothDeviceIsConnectedToMac(address: address)
                ))
            }
        }

        cachedDevices = devices
        if let selectedAddress,
           let selected = devices.first(where: { $0.address == selectedAddress }) {
            rememberSelectedName(selected.name)
        }
    }

    private func bluetoothDeviceIsConnectedToMac(address: String) -> Bool {
        let trimmed = address.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }

        let candidates = [
            trimmed,
            trimmed.uppercased(),
            trimmed.replacingOccurrences(of: ":", with: "-").uppercased(),
            trimmed.replacingOccurrences(of: "-", with: ":").uppercased()
        ]

        for candidate in candidates {
            if let device = IOBluetoothDevice(addressString: candidate), device.isConnected() {
                return true
            }
        }
        return false
    }

    private func selectedDeviceIsConnectedToMac() -> Bool {
        guard let selectedAddress, !selectedAddress.isEmpty else { return false }
        if let cached = cachedDevices.first(where: { $0.address == selectedAddress }) {
            return cached.isConnectedToMac
        }
        return bluetoothDeviceIsConnectedToMac(address: selectedAddress)
    }

    private func autoConnectLastDevice() {
        guard phase() == .idle,
              let selectedAddress,
              !selectedAddress.isEmpty
        else {
            return
        }

        autoReconnectEnabled = true
        attemptAutoReconnect(forceDirectAttempt: true)
    }

    private func handleConnectionHealthCheck() {
        guard autoReconnectEnabled,
              phase() == .ready,
              Date() >= nextConnectionHealthCheckAt
        else {
            return
        }

        // Do not actively request a full MDR sync as a health check. Some headphones
        // stay in the native "syncing" phase for too long after a sync request; the
        // retry watchdog could then interpret that transient state as a broken
        // connection and start a disconnect/reconnect loop. Keeping this as a
        // lightweight cadence marker lets reconnection logic run without waking the
        // headset unnecessarily.
        nextConnectionHealthCheckAt = Date().addingTimeInterval(connectionHealthCheckInterval)
    }

    private func handleConnectionProgressWatchdog() {
        let currentPhase = phase()
        let now = Date()

        // Advanced settings such as DSEE and voice guidance can make the MDR bridge
        // briefly report syncing/initializing even though the Bluetooth link is fine.
        // During that quiet window we must not disconnect/reconnect, otherwise a
        // normal settings commit turns into the visible connect/disconnect loop.
        if now < advancedSettingReconnectQuietUntil {
            if currentPhase == .connecting || currentPhase == .initializing || currentPhase == .syncing || currentPhase == .committing {
                connectionAttemptStartedAt = nil
                connectionRetryScheduled = false
                return
            }
        }

        if currentPhase == .ready {
            connectionAttemptStartedAt = nil
            connectionRetryCount = 0
            connectionRetryScheduled = false
            lastConnectionAttemptAddress = nil
            return
        }

        if currentPhase == .syncing && shouldTreatAdvancedSettingSyncAsReady() {
            connectionAttemptStartedAt = nil
            connectionRetryScheduled = false
            return
        }

        let isConnectionProgressPhase = currentPhase == .connecting
            || currentPhase == .initializing
            || currentPhase == .syncing

        guard autoReconnectEnabled,
              isConnectionProgressPhase,
              let selectedAddress,
              !selectedAddress.isEmpty
        else {
            if currentPhase == .idle || currentPhase == .error {
                connectionAttemptStartedAt = nil
                connectionRetryScheduled = false
            }
            return
        }

        if lastConnectionAttemptAddress != selectedAddress {
            lastConnectionAttemptAddress = selectedAddress
            connectionAttemptStartedAt = now
            connectionRetryCount = 0
            connectionRetryScheduled = false
            nextConnectionRetryRefreshAt = Date.distantPast
            return
        }

        if connectionAttemptStartedAt == nil {
            connectionAttemptStartedAt = now
            return
        }

        guard let startedAt = connectionAttemptStartedAt,
              now.timeIntervalSince(startedAt) >= connectionAttemptTimeout,
              !connectionRetryScheduled
        else {
            return
        }

        if now >= nextConnectionRetryRefreshAt {
            refreshDevices()
            nextConnectionRetryRefreshAt = now.addingTimeInterval(connectionRetryRefreshInterval)
        }

        let selectedDeviceIsAvailable = selectedDeviceIsConnectedToMac()
        guard selectedDeviceIsAvailable else {
            connectionAttemptStartedAt = now
            scheduleNextAutoReconnect(after: max(autoReconnectBackoff, 6))
            return
        }

        if connectionRetryCount >= maximumConsecutiveConnectionRetries {
            mdrNativeDisconnect(self.native)
            connectionAttemptStartedAt = nil
            connectionRetryScheduled = false
            scheduleNextAutoReconnect(after: 10)
            connectionRetryCount = 0
            return
        }

        connectionRetryCount += 1
        connectionRetryScheduled = true
        mdrNativeDisconnect(self.native)
        scheduleNextAutoReconnect(after: connectionRetryPause)

        DispatchQueue.main.asyncAfter(deadline: .now() + connectionRetryPause) { [weak self] in
            guard let self,
                  self.autoReconnectEnabled,
                  self.phase() != .ready,
                  let selectedAddress = self.selectedAddress,
                  !selectedAddress.isEmpty
            else {
                self?.connectionRetryScheduled = false
                return
            }

            self.connectionRetryScheduled = false
            self.connectionAttemptStartedAt = Date()
            self.connect(address: selectedAddress, name: self.selectedName, userInitiated: false, resetConnectionRetries: false)
        }
    }

    private func handleAutoReconnect() {
        let currentPhase = phase()
        if currentPhase == .ready {
            resetAutoReconnectBackoff()
            return
        }

        guard autoReconnectEnabled,
              currentPhase == .idle || currentPhase == .error,
              let selectedAddress,
              !selectedAddress.isEmpty,
              Date() >= nextAutoReconnectAt
        else {
            return
        }

        attemptAutoReconnect(forceDirectAttempt: currentPhase == .error)
    }

    private func attemptAutoReconnect(forceDirectAttempt: Bool) {
        guard let selectedAddress, !selectedAddress.isEmpty else {
            return
        }

        let now = Date()
        if now >= nextAutoRefreshDevicesAt {
            refreshDevices()
            nextAutoRefreshDevicesAt = now.addingTimeInterval(autoReconnectRefreshInterval)
        }

        let selectedDevice = cachedDevices.first(where: { $0.address == selectedAddress })
        let isConnectedToMac = selectedDevice?.isConnectedToMac ?? bluetoothDeviceIsConnectedToMac(address: selectedAddress)

        // Only ask the MDR layer to connect after macOS already reports the
        // headphones as connected at the Bluetooth level. A device merely being
        // listed/paired is not enough; trying MDR then causes visible connect loops.
        guard isConnectedToMac else {
            silentAutoConnectInProgress = false
            scheduleNextAutoReconnect(after: autoReconnectBackoff)
            return
        }

        lastAutoReconnectAttemptAt = now
        if let selectedDevice {
            connect(device: selectedDevice, userInitiated: false)
        } else {
            connect(address: selectedAddress, name: selectedName, userInitiated: false)
        }

        scheduleNextAutoReconnect(after: autoReconnectBackoff)
        autoReconnectBackoff = min(autoReconnectBackoff * 1.7, autoReconnectMaximumBackoff)
    }

    private func scheduleNextAutoReconnect(after interval: TimeInterval) {
        nextAutoReconnectAt = Date().addingTimeInterval(interval)
    }

    private func resetAutoReconnectBackoff() {
        silentAutoConnectInProgress = false
        autoReconnectBackoff = 2
        nextAutoReconnectAt = Date.distantPast
        nextAutoRefreshDevicesAt = Date.distantPast
    }

    private func makePopoverView() -> NSView {
        let width: CGFloat = 360
        let height = popoverHeight()
        let root = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: width, height: height))
        root.material = .popover
        root.blendingMode = .behindWindow
        root.state = .active

        var cursorY = height
        func append(_ view: NSView) {
            let viewHeight = view.frame.height
            cursorY -= viewHeight
            view.frame = NSRect(x: 0, y: cursorY, width: width, height: viewHeight)
            root.addSubview(view)
        }

        append(makeHeaderView(width: width))
        append(divider(width: width))

        if shouldShowDeviceListSection() {
            append(sectionTitle("Dispositivos", width: width))
            append(makeDeviceList(width: width))
            append(verticalSpacer(10))
            append(divider(width: width))
        }

        if quickControlVisible("noiseControl") {
            append(sectionTitle("Control de ruido", width: width))
            append(actionRow(
                title: "Ambiente",
                symbol: "ear",
                accessorySymbol: "waveform",
                checked: noiseMode() == .ambient,
                enabled: canUseControls() && mdrNativeSupportsAmbientSound(self.native) != 0,
                tag: Int(NoiseMode.ambient.rawValue),
                action: #selector(noiseModeClicked(_:)),
                width: width
            ))

            if mdrNativeSupportsAutoAmbientSound(self.native) != 0 {
                append(actionRow(
                    title: "Adaptable",
                    symbol: "sparkles",
                    accessorySymbol: "arrow.triangle.2.circlepath",
                    checked: noiseMode() == .adaptive,
                    enabled: canUseControls(),
                    tag: Int(NoiseMode.adaptive.rawValue),
                    action: #selector(noiseModeClicked(_:)),
                    width: width
                ))
            }

            append(actionRow(
                title: "Cancelar ruido",
                symbol: "ear",
                accessorySymbol: "waveform.slash",
                checked: noiseMode() == .noiseCancelling,
                enabled: canUseControls() && mdrNativeSupportsNoiseCancelling(self.native) != 0,
                tag: Int(NoiseMode.noiseCancelling.rawValue),
                action: #selector(noiseModeClicked(_:)),
                width: width
            ))
            append(actionRow(
                title: "Desactivado",
                symbol: "power",
                accessorySymbol: nil,
                checked: noiseMode() == .off,
                enabled: canUseControls(),
                tag: Int(NoiseMode.off.rawValue),
                action: #selector(noiseModeClicked(_:)),
                width: width
            ))
            append(verticalSpacer(10))
        }

        if quickControlVisible("ambientLevel") {
            append(makeAmbientSlider(width: width))
        }

        if anyQuickSoundControlVisible() {
            append(divider(width: width))
            append(sectionTitle("Sonido", width: width))
            if quickControlVisible("volume") {
                append(makeQuickVolumeSlider(width: width))
            }
            if quickControlVisible("dsee") {
                append(actionRow(
                    title: "DSEE / upscaling",
                    symbol: "wand.and.sparkles",
                    accessorySymbol: nil,
                    checked: mdrNativeGetUpscalingEnabled(self.native) != 0,
                    enabled: canUseControls() && mdrNativeSupportsUpscaling(self.native) != 0,
                    tag: mdrNativeGetUpscalingEnabled(self.native) != 0 ? 0 : 1,
                    action: #selector(quickUpscalingClicked(_:)),
                    width: width
                ))
            }
            if quickControlVisible("voiceGuidance") {
                append(actionRow(
                    title: "Guia de voz",
                    symbol: "speaker.wave.2",
                    accessorySymbol: "quote.bubble",
                    checked: mdrNativeGetVoiceGuidanceEnabled(self.native) != 0,
                    enabled: canUseControls() && mdrNativeSupportsVoiceGuidance(self.native) != 0,
                    tag: mdrNativeGetVoiceGuidanceEnabled(self.native) != 0 ? 0 : 1,
                    action: #selector(quickVoiceGuidanceClicked(_:)),
                    width: width
                ))
            }
            if quickControlVisible("voiceGuidanceVolume") {
                append(makeQuickVoiceGuidanceVolumeSlider(width: width))
            }
        }

        if quickControlVisible("speakToChat") {
            append(divider(width: width))
            append(sectionTitle("Reconocimiento de conversacion", width: width))
            append(actionRow(
                title: "Desactivado",
                symbol: "person.fill",
                accessorySymbol: "slash",
                checked: mdrNativeGetSpeakToChatEnabled(self.native) == 0,
                enabled: canUseControls() && mdrNativeSupportsSpeakToChat(self.native) != 0,
                tag: 0,
                action: #selector(speakToChatClicked(_:)),
                width: width
            ))
            append(actionRow(
                title: "Activado",
                symbol: "person.fill",
                accessorySymbol: "waveform",
                checked: mdrNativeGetSpeakToChatEnabled(self.native) != 0,
                enabled: canUseControls() && mdrNativeSupportsSpeakToChat(self.native) != 0,
                tag: 1,
                action: #selector(speakToChatClicked(_:)),
                width: width
            ))
        }

        if anyQuickButtonControlVisible() {
            append(divider(width: width))
            append(sectionTitle("Controles", width: width))
            if quickControlVisible("ncButton") {
                append(makeQuickPopupRow(
                    title: "Boton NC/AMB",
                    symbol: "button.programmable",
                    options: Self.ncAsmButtonOptions,
                    current: Int(mdrNativeGetNcAsmButtonFunction(self.native)),
                    action: #selector(ncAsmButtonChanged(_:)),
                    width: width,
                    enabled: canUseControls() && mdrNativeSupportsNcAsmButtonSettings(self.native) != 0
                ))
            }
            if quickControlVisible("touchLeft") {
                append(makeQuickPopupRow(
                    title: "Touch izquierdo",
                    symbol: "hand.tap",
                    options: Self.touchFunctionOptions,
                    current: Int(mdrNativeGetTouchFunctionLeft(self.native)),
                    action: #selector(touchLeftChanged(_:)),
                    width: width,
                    enabled: canUseControls() && mdrNativeSupportsAssignableSettings(self.native) != 0
                ))
            }
            if quickControlVisible("touchRight") {
                append(makeQuickPopupRow(
                    title: "Touch derecho",
                    symbol: "hand.tap",
                    options: Self.touchFunctionOptions,
                    current: Int(mdrNativeGetTouchFunctionRight(self.native)),
                    action: #selector(touchRightChanged(_:)),
                    width: width,
                    enabled: canUseControls() && mdrNativeSupportsAssignableSettings(self.native) != 0
                ))
            }
        }

        append(divider(width: width))
        append(plainRow(
            title: "Configuracion de los auriculares...",
            tag: 0,
            action: #selector(openAdvancedSettings(_:)),
            width: width
        ))
        append(plainRow(
            title: "Configuracion de Sonido...",
            tag: 0,
            action: #selector(openSoundSettings(_:)),
            width: width
        ))
        append(plainRow(
            title: "Salir",
            tag: 0,
            action: #selector(quit(_:)),
            width: width
        ))

        return root
    }

    private func makeHeaderView(width: CGFloat) -> NSView {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: width, height: 54))

        let bubble = NSView(frame: NSRect(x: 16, y: 11, width: 32, height: 32))
        bubble.wantsLayer = true
        bubble.layer?.cornerRadius = 16
        bubble.layer?.backgroundColor = NSColor.systemBlue.cgColor
        view.addSubview(bubble)

        let icon = NSImageView(frame: NSRect(x: 6, y: 6, width: 20, height: 20))
        icon.image = xmbarHeadphonesIcon(pointSize: 20, tint: .white)
        icon.contentTintColor = nil
        bubble.addSubview(icon)

        let title = NSTextField(labelWithString: headerTitle())
        title.frame = NSRect(x: 60, y: 29, width: width - 112, height: 18)
        title.font = .systemFont(ofSize: 14, weight: .semibold)
        title.textColor = .labelColor
        view.addSubview(title)

        let subtitle = NSTextField(labelWithString: "")
        subtitle.frame = NSRect(x: 60, y: 11, width: width - 112, height: 16)
        subtitle.font = .systemFont(ofSize: 12)
        subtitle.textColor = .secondaryLabelColor
        subtitle.attributedStringValue = headerSubtitleAttributedString()
        view.addSubview(subtitle)

        if canShowDeviceListInPopover() {
            let disclosure = NSButton(frame: NSRect(x: width - 42, y: 15, width: 26, height: 26))
            disclosure.image = symbolImage(deviceListExpanded ? "chevron.up" : "chevron.down", pointSize: 13, weight: .medium)
            disclosure.imagePosition = .imageOnly
            disclosure.isBordered = false
            disclosure.target = self
            disclosure.action = #selector(toggleDeviceList(_:))
            view.addSubview(disclosure)
        }

        return view
    }

    private func makeDeviceList(width: CGFloat) -> NSView {
        let visibleCount = min(max(cachedDevices.count, 1), 5)
        let rowHeight: CGFloat = 32
        let height = CGFloat(visibleCount) * rowHeight
        let root = NSView(frame: NSRect(x: 0, y: 0, width: width, height: height))

        if cachedDevices.isEmpty {
            let label = NSTextField(labelWithString: tr("No hay dispositivos emparejados visibles."))
            label.frame = NSRect(x: 74, y: 8, width: width - 96, height: 18)
            label.font = .systemFont(ofSize: 13)
            label.textColor = .secondaryLabelColor
            root.addSubview(label)
            return root
        }

        for (index, device) in cachedDevices.prefix(5).enumerated() {
            let y = height - CGFloat(index + 1) * rowHeight
            let row = deviceRow(device: device, index: index, y: y, width: width, height: rowHeight)
            root.addSubview(row)
        }

        return root
    }

    private func deviceRow(device: BluetoothDevice, index: Int, y: CGFloat, width: CGFloat, height: CGFloat) -> NSView {
        let row = NSView(frame: NSRect(x: 0, y: y, width: width, height: height))

        let check = NSImageView(frame: NSRect(x: 18, y: 8, width: 15, height: 15))
        check.image = device.address == selectedAddress ? symbolImage("checkmark", pointSize: 14, weight: .semibold) : nil
        check.contentTintColor = .labelColor
        row.addSubview(check)

        let icon = NSImageView(frame: NSRect(x: 58, y: 7, width: 18, height: 18))
        icon.image = xmbarHeadphonesIcon(pointSize: 18, tint: device.isConnectedToMac ? .secondaryLabelColor : .disabledControlTextColor)
        icon.contentTintColor = nil
        row.addSubview(icon)

        let name = NSTextField(labelWithString: device.displayName)
        name.frame = NSRect(x: 84, y: 13, width: 210, height: 16)
        name.font = .systemFont(ofSize: 13)
        name.textColor = device.isConnectedToMac ? .labelColor : .disabledControlTextColor
        row.addSubview(name)

        let address = NSTextField(labelWithString: device.address)
        address.frame = NSRect(x: 84, y: 0, width: 210, height: 13)
        address.font = .systemFont(ofSize: 10)
        address.textColor = device.isConnectedToMac ? .secondaryLabelColor : .disabledControlTextColor
        row.addSubview(address)

        let button = NSButton(frame: row.bounds)
        button.isBordered = false
        button.title = ""
        button.target = self
        button.action = #selector(deviceClicked(_:))
        button.tag = index
        button.isEnabled = !displayPhase().isBusy && device.isConnectedToMac
        button.autoresizingMask = [.width, .height]
        row.addSubview(button)

        return row
    }

    private func makeAmbientSlider(width: CGFloat) -> NSView {
        let isEnabled = canUseControls() && mdrNativeSupportsAmbientSound(self.native) != 0
        let view = NSView(frame: NSRect(x: 0, y: 0, width: width, height: 40))

        let icon = NSImageView(frame: NSRect(x: 58, y: 12, width: 18, height: 18))
        icon.image = symbolImage("slider.horizontal.3", pointSize: 15, weight: .regular)
        icon.contentTintColor = isEnabled ? .secondaryLabelColor : .disabledControlTextColor
        view.addSubview(icon)

        let slider = NSSlider(
            value: Double(mdrNativeGetAmbientLevel(self.native)),
            minValue: 1,
            maxValue: 20,
            target: self,
            action: #selector(ambientSliderChanged(_:))
        )
        slider.frame = NSRect(x: 84, y: 7, width: 215, height: 24)
        slider.numberOfTickMarks = 20
        slider.allowsTickMarkValuesOnly = true
        slider.isContinuous = false
        slider.isEnabled = isEnabled
        view.addSubview(slider)

        let value = NSTextField(labelWithString: "\(mdrNativeGetAmbientLevel(self.native))")
        value.frame = NSRect(x: width - 50, y: 12, width: 28, height: 16)
        value.alignment = .right
        value.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        value.textColor = isEnabled ? .secondaryLabelColor : .disabledControlTextColor
        view.addSubview(value)

        return view
    }

    private func makeQuickVolumeSlider(width: CGFloat) -> NSView {
        makeCompactSliderRow(
            title: "Volumen",
            symbol: "speaker.wave.2",
            value: mdrNativeGetPlayVolume(self.native),
            range: 0...30,
            action: #selector(playVolumeChanged(_:)),
            width: width,
            enabled: canUseControls()
        )
    }

    private func makeQuickVoiceGuidanceVolumeSlider(width: CGFloat) -> NSView {
        makeCompactSliderRow(
            title: "Volumen guia",
            symbol: "speaker.wave.1",
            value: mdrNativeGetVoiceGuidanceVolume(self.native),
            range: -2...2,
            action: #selector(voiceGuidanceVolumeChanged(_:)),
            width: width,
            enabled: canUseControls() && mdrNativeSupportsVoiceGuidanceVolume(self.native) != 0
        )
    }

    private func makeQuickPopupRow(
        title: String,
        symbol: String,
        options: [PopupOption],
        current: Int,
        action: Selector,
        width: CGFloat,
        enabled: Bool
    ) -> NSView {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: width, height: 30))

        let icon = NSImageView(frame: NSRect(x: 58, y: 7, width: 18, height: 18))
        icon.image = symbolImage(named: symbol, pointSize: 15, weight: .regular)
        icon.contentTintColor = enabled ? .secondaryLabelColor : .disabledControlTextColor
        view.addSubview(icon)

        let label = NSTextField(labelWithString: tr(title))
        label.frame = NSRect(x: 84, y: 6, width: 112, height: 18)
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = enabled ? .labelColor : .disabledControlTextColor
        view.addSubview(label)

        let popup = NSPopUpButton(frame: NSRect(x: 198, y: 2, width: width - 220, height: 26), pullsDown: false)
        for option in options {
            popup.addItem(withTitle: tr(option.title))
            popup.item(at: popup.numberOfItems - 1)?.tag = option.value
        }
        if let selected = popup.itemArray.first(where: { $0.tag == current }) {
            popup.select(selected)
        } else {
            popup.addItem(withTitle: "\(tr("Valor")) \(current)")
            let fallback = popup.item(at: popup.numberOfItems - 1)
            fallback?.tag = current
            popup.select(fallback)
        }
        popup.target = self
        popup.action = action
        popup.isEnabled = enabled
        view.addSubview(popup)

        return view
    }

    private func makeCompactSliderRow(
        title: String,
        symbol: String,
        value: Int32,
        range: ClosedRange<Int>,
        action: Selector,
        width: CGFloat,
        enabled: Bool
    ) -> NSView {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: width, height: 40))

        let icon = NSImageView(frame: NSRect(x: 58, y: 12, width: 18, height: 18))
        icon.image = symbolImage(named: symbol, pointSize: 15, weight: .regular)
        icon.contentTintColor = enabled ? .secondaryLabelColor : .disabledControlTextColor
        view.addSubview(icon)

        let label = NSTextField(labelWithString: tr(title))
        label.frame = NSRect(x: 84, y: 3, width: 104, height: 16)
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = enabled ? .secondaryLabelColor : .disabledControlTextColor
        view.addSubview(label)

        let slider = NSSlider(
            value: Double(value),
            minValue: Double(range.lowerBound),
            maxValue: Double(range.upperBound),
            target: self,
            action: action
        )
        slider.frame = NSRect(x: 84, y: 14, width: 215, height: 24)
        slider.numberOfTickMarks = range.upperBound - range.lowerBound + 1
        slider.allowsTickMarkValuesOnly = true
        slider.isContinuous = false
        if title == "Volumen" {
            slider.identifier = NSUserInterfaceItemIdentifier("quickPlayVolumeSlider")
        } else if title == "Volumen guia" {
            slider.identifier = NSUserInterfaceItemIdentifier("quickVoiceGuidanceVolumeSlider")
        }
        slider.isEnabled = enabled
        view.addSubview(slider)

        let valueLabel = NSTextField(labelWithString: "\(value)")
        valueLabel.identifier = NSUserInterfaceItemIdentifier("advancedSliderValueLabel")
        valueLabel.frame = NSRect(x: width - 50, y: 12, width: 28, height: 16)
        valueLabel.alignment = .right
        valueLabel.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        valueLabel.textColor = enabled ? .secondaryLabelColor : .disabledControlTextColor
        view.addSubview(valueLabel)

        return view
    }

    private func sectionTitle(_ title: String, width: CGFloat) -> NSView {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: width, height: 28))
        let label = NSTextField(labelWithString: tr(title))
        label.frame = NSRect(x: 15, y: 7, width: width - 30, height: 16)
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = NSColor(calibratedRed: 0.23, green: 0.38, blue: 0.48, alpha: 1.0)
        view.addSubview(label)
        return view
    }

    private func actionRow(
        title: String,
        symbol: String,
        accessorySymbol: String?,
        checked: Bool,
        enabled: Bool,
        tag: Int,
        action: Selector,
        width: CGFloat
    ) -> NSView {
        let height: CGFloat = 27
        let row = NSView(frame: NSRect(x: 0, y: 0, width: width, height: height))

        let check = NSImageView(frame: NSRect(x: 18, y: 6, width: 15, height: 15))
        check.image = checked ? symbolImage("checkmark", pointSize: 15, weight: .semibold) : nil
        check.contentTintColor = enabled ? .labelColor : .disabledControlTextColor
        row.addSubview(check)

        let icon = iconView(symbol: symbol, accessory: accessorySymbol, enabled: enabled)
        icon.frame = NSRect(x: 58, y: 4, width: 20, height: 20)
        row.addSubview(icon)

        let label = NSTextField(labelWithString: tr(title))
        label.frame = NSRect(x: 84, y: 4, width: width - 100, height: 18)
        label.font = .systemFont(ofSize: 14)
        label.textColor = enabled ? .labelColor : .disabledControlTextColor
        row.addSubview(label)

        let button = NSButton(frame: row.bounds)
        button.isBordered = false
        button.title = ""
        button.target = self
        button.action = action
        button.tag = tag
        button.isEnabled = enabled
        button.autoresizingMask = [.width, .height]
        row.addSubview(button)

        return row
    }

    private func plainRow(title: String, tag: Int, action: Selector, width: CGFloat) -> NSView {
        let height: CGFloat = 27
        let row = NSView(frame: NSRect(x: 0, y: 0, width: width, height: height))
        let label = NSTextField(labelWithString: tr(title))
        label.frame = NSRect(x: 15, y: 4, width: width - 30, height: 18)
        label.font = .systemFont(ofSize: 14)
        label.textColor = .labelColor
        row.addSubview(label)

        let button = NSButton(frame: row.bounds)
        button.isBordered = false
        button.title = ""
        button.target = self
        button.action = action
        button.tag = tag
        button.autoresizingMask = [.width, .height]
        row.addSubview(button)

        return row
    }

    private func divider(width: CGFloat) -> NSView {
        let container = NSView(frame: NSRect(x: 0, y: 0, width: width, height: 1))
        let line = NSBox(frame: NSRect(x: 15, y: 0, width: width - 30, height: 1))
        line.boxType = .separator
        container.addSubview(line)
        return container
    }

    private func verticalSpacer(_ height: CGFloat) -> NSView {
        NSView(frame: NSRect(x: 0, y: 0, width: 1, height: height))
    }

    private func canShowDeviceListInPopover() -> Bool {
        displayPhase() != .ready || quickControlVisible("devices")
    }

    private func shouldShowDeviceListSection() -> Bool {
        displayPhase() != .ready || (quickControlVisible("devices") && deviceListExpanded)
    }

    private func popoverHeight() -> CGFloat {
        var height: CGFloat = 54 + 1
        if shouldShowDeviceListSection() {
            height += 28 + CGFloat(min(max(cachedDevices.count, 1), 5)) * 32 + 10 + 1
        }
        if quickControlVisible("noiseControl") {
            height += 28 + 27 + 27 + 27 + 10
            if mdrNativeSupportsAutoAmbientSound(self.native) != 0 {
                height += 27
            }
        }
        if quickControlVisible("ambientLevel") {
            height += 40
        }
        if anyQuickSoundControlVisible() {
            height += 1 + 28
            if quickControlVisible("volume") { height += 40 }
            if quickControlVisible("dsee") { height += 27 }
            if quickControlVisible("voiceGuidance") { height += 27 }
            if quickControlVisible("voiceGuidanceVolume") { height += 40 }
        }
        if quickControlVisible("speakToChat") {
            height += 1 + 28 + 27 + 27
        }
        if anyQuickButtonControlVisible() {
            height += 1 + 28
            if quickControlVisible("ncButton") { height += 30 }
            if quickControlVisible("touchLeft") { height += 30 }
            if quickControlVisible("touchRight") { height += 30 }
        }
        height += 1 + 27 + 27 + 27 + 8
        return min(height, 640)
    }

    private func updateStatusButton() {
        if shouldHideStatusItemForCurrentState() {
            hideStatusItemIfNeeded()
            return
        }

        if statusItem == nil {
            configureStatusItem()
        }

        guard let button = statusItem?.button else {
            return
        }

        let currentPhase = displayPhase()
        let isDisconnected: Bool
        switch currentPhase {
        case .idle, .error:
            isDisconnected = true
        default:
            isDisconnected = false
        }

        // Same headphones icon in every state; disconnected is just dimmed.
        button.image = xmbarHeadphonesIcon(pointSize: 17, tint: .labelColor)
        button.image?.isTemplate = false
        button.imagePosition = .imageOnly
        button.alphaValue = isDisconnected ? 0.50 : 1.0
        statusItem?.length = NSStatusItem.squareLength
        button.attributedTitle = NSAttributedString(string: "")
        button.title = ""
    }

    private func hideWhenDisconnectedEnabled() -> Bool {
        UserDefaults.standard.bool(forKey: hideWhenDisconnectedKey)
    }

    private func setHideWhenDisconnected(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: hideWhenDisconnectedKey)
        updateStatusButton()
        rebuildAdvancedWindowContent()
    }

    private func notificationPillEnabled() -> Bool {
        if UserDefaults.standard.object(forKey: notificationPillEnabledKey) == nil {
            return true
        }
        return UserDefaults.standard.bool(forKey: notificationPillEnabledKey)
    }

    private func setNotificationPillEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: notificationPillEnabledKey)
        if !enabled {
            notificationPillDismissWorkItem?.cancel()
            notificationPillDismissWorkItem = nil
            notificationPillWindow?.orderOut(nil)
            notificationPillWindow = nil
        }
        rebuildAdvancedWindowContent()
    }

    private func shouldHideStatusItemForCurrentState() -> Bool {
        guard hideWhenDisconnectedEnabled() else {
            return false
        }
        let raw = phase()
        if silentAutoConnectInProgress && (raw == .connecting || raw == .initializing || raw == .syncing || raw == .error || raw == .idle) {
            return true
        }
        switch displayPhase() {
        case .idle, .error:
            return true
        default:
            return false
        }
    }

    private func hideStatusItemIfNeeded() {
        popover.performClose(nil)
        if let item = statusItem {
            NSStatusBar.system.removeStatusItem(item)
            statusItem = nil
        }
    }


    private func batterySymbolImage(percent: Int) -> NSImage? {
        let candidates: [String]
        switch percent {
        case 90...100:
            candidates = ["battery.100percent", "battery.100"]
        case 65..<90:
            candidates = ["battery.75percent", "battery.75"]
        case 40..<65:
            candidates = ["battery.50percent", "battery.50"]
        case 15..<40:
            candidates = ["battery.25percent", "battery.25"]
        default:
            candidates = ["battery.0percent", "battery.0"]
        }

        for candidate in candidates {
            if let image = symbolImage(candidate, pointSize: 13, weight: .regular) {
                image.isTemplate = true
                return image
            }
        }
        return nil
    }

    private func headerTitle() -> String {
        if let preferredName = preferredDeviceName() {
            return preferredName
        }
        let model = modelName()
        if displayPhase() == .ready && !model.isEmpty {
            return model
        }
        return "Auriculares"
    }

    private func headerSubtitle() -> String {
        switch displayPhase() {
        case .ready:
            let battery = batteryText()
            return battery.isEmpty ? "Conectado" : battery
        case .idle:
            return cachedDevices.isEmpty ? "Sin dispositivos emparejados" : "Selecciona un dispositivo"
        case .connecting:
            return "Conectando..."
        case .initializing:
            return "Inicializando MDR..."
        case .syncing:
            return "Sincronizando..."
        case .committing:
            return "Aplicando cambios..."
        case .error:
            return lastError()
        }
    }

    private func headerSubtitleAttributedString() -> NSAttributedString {
        guard displayPhase() == .ready else {
            return NSAttributedString(
                string: headerSubtitle(),
                attributes: [
                    .font: NSFont.systemFont(ofSize: 12),
                    .foregroundColor: NSColor.secondaryLabelColor
                ]
            )
        }

        let text = batteryAttributedText()
        if text.length == 0 {
            return NSAttributedString(
                string: "Conectado",
                attributes: [
                    .font: NSFont.systemFont(ofSize: 12),
                    .foregroundColor: NSColor.secondaryLabelColor
                ]
            )
        }
        return text
    }

    private func batteryAttributedText() -> NSAttributedString {
        let left = Int(mdrNativeGetBatteryLeft(self.native))
        let right = Int(mdrNativeGetBatteryRight(self.native))
        let batteryCase = Int(mdrNativeGetBatteryCase(self.native))
        let text = NSMutableAttributedString()

        func appendSeparatorIfNeeded() {
            if text.length > 0 {
                text.append(NSAttributedString(
                    string: "  ",
                    attributes: [
                        .font: NSFont.systemFont(ofSize: 12),
                        .foregroundColor: NSColor.secondaryLabelColor
                    ]
                ))
            }
        }

        func appendBattery(label: String?, percent: Int) {
            guard percent > 0 else { return }
            appendSeparatorIfNeeded()

            if let label, !label.isEmpty {
                text.append(NSAttributedString(
                    string: "\(label) ",
                    attributes: [
                        .font: NSFont.systemFont(ofSize: 12, weight: .medium),
                        .foregroundColor: NSColor.secondaryLabelColor
                    ]
                ))
            }

            if let image = batterySymbolImage(percent: percent) {
                let attachment = NSTextAttachment()
                attachment.image = image
                attachment.bounds = NSRect(x: 0, y: -1, width: 16, height: 10)
                text.append(NSAttributedString(attachment: attachment))
                text.append(NSAttributedString(string: " "))
            }

            text.append(NSAttributedString(
                string: "\(percent)%",
                attributes: [
                    .font: NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium),
                    .foregroundColor: NSColor.secondaryLabelColor
                ]
            ))
        }

        if shouldShowSingleHeadphoneBattery(left: left, right: right, batteryCase: batteryCase) {
            appendBattery(label: nil, percent: left)
        } else {
            appendBattery(label: "L", percent: left)
            appendBattery(label: "R", percent: right)
            appendBattery(label: "Case", percent: batteryCase)
        }
        return text
    }

    private func canUseControls() -> Bool {
        displayPhase() == .ready
    }

    private func batteryText() -> String {
        let left = mdrNativeGetBatteryLeft(self.native)
        let right = mdrNativeGetBatteryRight(self.native)
        let batteryCase = mdrNativeGetBatteryCase(self.native)
        var parts: [String] = []

        if shouldShowSingleHeadphoneBattery(left: Int(left), right: Int(right), batteryCase: Int(batteryCase)) {
            parts.append("\(left)%")
        } else {
            if left > 0 {
                parts.append("L \(left)%")
            }
            if right > 0 {
                parts.append("R \(right)%")
            }
            if batteryCase > 0 {
                parts.append("Case \(batteryCase)%")
            }
        }

        return parts.joined(separator: "  ")
    }

    private func batteryDiagnostics() -> [(title: String, value: String)] {
        let left = Int(mdrNativeGetBatteryLeft(self.native))
        let right = Int(mdrNativeGetBatteryRight(self.native))
        let batteryCase = Int(mdrNativeGetBatteryCase(self.native))
        var rows: [(title: String, value: String)] = []

        func appendBattery(title: String, level: Int, charging: Int32, threshold: Int32) {
            guard level > 0 || threshold > 0 || charging == 1 || charging == 3 else {
                return
            }

            var parts: [String] = []
            if level > 0 {
                parts.append("\(level)%")
            }
            parts.append(chargingLabel(charging))
            if threshold > 0 {
                parts.append("\(tr("Umbral")) \(threshold)%")
            }
            rows.append((title: title, value: parts.filter { !$0.isEmpty }.joined(separator: " · ")))
        }

        if shouldShowSingleHeadphoneBattery(left: left, right: right, batteryCase: batteryCase) {
            appendBattery(
                title: "Bateria",
                level: left,
                charging: mdrNativeGetBatteryLeftCharging(self.native),
                threshold: mdrNativeGetBatteryLeftThreshold(self.native)
            )
        } else {
            appendBattery(
                title: "Izquierdo",
                level: left,
                charging: mdrNativeGetBatteryLeftCharging(self.native),
                threshold: mdrNativeGetBatteryLeftThreshold(self.native)
            )
            appendBattery(
                title: "Derecho",
                level: right,
                charging: mdrNativeGetBatteryRightCharging(self.native),
                threshold: mdrNativeGetBatteryRightThreshold(self.native)
            )
            appendBattery(
                title: "Estuche",
                level: batteryCase,
                charging: mdrNativeGetBatteryCaseCharging(self.native),
                threshold: mdrNativeGetBatteryCaseThreshold(self.native)
            )
        }

        return rows
    }

    private func chargingLabel(_ value: Int32) -> String {
        switch value {
        case 0:
            return tr("No cargando")
        case 1:
            return tr("Cargando")
        case 3:
            return tr("Cargado")
        default:
            return tr("Estado de carga desconocido")
        }
    }


    private func shouldShowSingleHeadphoneBattery(left: Int, right: Int, batteryCase: Int) -> Bool {
        guard left > 0, right <= 0, batteryCase <= 0 else {
            return false
        }
        return isHeadbandHeadphones()
    }

    private func isHeadbandHeadphones() -> Bool {
        let names = [modelName(), selectedName ?? "", headerTitle()]
            .map { $0.uppercased() }

        if names.contains(where: { $0.hasPrefix("WH-") || $0.contains(" WH-") }) {
            return true
        }

        // The native bridge often exposes over-ear headphones as a single battery.
        // If only one headphone battery exists and there is no case/right battery, treat it
        // as a single headset battery instead of labelling it as the left earbud.
        let left = Int(mdrNativeGetBatteryLeft(self.native))
        let right = Int(mdrNativeGetBatteryRight(self.native))
        let batteryCase = Int(mdrNativeGetBatteryCase(self.native))
        return left > 0 && right <= 0 && batteryCase <= 0
    }

    private func renderSignature() -> String {
        [
            String(displayPhase().rawValue),
            selectedAddress ?? "",
            selectedName ?? "",
            String(deviceListExpanded),
            String(advancedDeviceListExpanded),
            String(cachedDevices.count),
            cachedDevices.map { "\($0.address):connected=\($0.isConnectedToMac)" }.joined(separator: ","),
            String(silentAutoConnectInProgress),
            String(mdrNativeGetNoiseControlMode(self.native)),
            String(mdrNativeGetAmbientLevel(self.native)),
            String(mdrNativeGetFocusOnVoice(self.native)),
            String(mdrNativeGetSpeakToChatEnabled(self.native)),
            String(mdrNativeGetPlayVolume(self.native)),
            String(mdrNativeGetPlaybackStatus(self.native)),
            trackTitle(),
            trackAlbum(),
            trackArtist(),
            String(mdrNativeGetUpscalingEnabled(self.native)),
            String(mdrNativeGetUpscalingAvailable(self.native)),
            String(mdrNativeGetVoiceGuidanceEnabled(self.native)),
            String(mdrNativeGetVoiceGuidanceVolume(self.native)),
            String(mdrNativeGetNoiseAdaptiveSensitivity(self.native)),
            Self.quickControlDefinitions.map { "\($0.id):\(quickControlEnabled($0.id)):supported=\(quickControlSupported($0.id)):visible=\(quickControlVisible($0.id))" }.joined(separator: ","),
            modelName(),
            firmwareVersion(),
            uniqueId(),
            modelSeries(),
            modelColor(),
            audioCodec(),
            upscalingType(),
            String(mdrNativeGetBatteryLeft(self.native)),
            String(mdrNativeGetBatteryRight(self.native)),
            String(mdrNativeGetBatteryCase(self.native)),
            String(mdrNativeGetBatteryLeftCharging(self.native)),
            String(mdrNativeGetBatteryRightCharging(self.native)),
            String(mdrNativeGetBatteryCaseCharging(self.native)),
            String(mdrNativeGetBatteryLeftThreshold(self.native)),
            String(mdrNativeGetBatteryRightThreshold(self.native)),
            String(mdrNativeGetBatteryCaseThreshold(self.native)),
            String(mdrNativeGetPairedDeviceCount(self.native)),
            pairedMDRDevices().map { "\($0.address):\($0.isConnectedToHeadphones):\($0.isActivePlaybackDevice)" }.joined(separator: ","),
            String(mdrNativeGetPairingMode(self.native)),
            String(mdrNativeGetGeneralSettingCount(self.native)),
            generalSettings().map { "\($0.index):\($0.titleKey):\($0.isEnabled)" }.joined(separator: ","),
            String(mdrNativeGetSafeListeningSoundPressure(self.native)),
            String(mdrNativeGetSafeListeningPreviewMode(self.native)),
            lastError()
        ].joined(separator: "|")
    }

    private func phase() -> NativePhase {
        NativePhase(rawValue: mdrNativeGetPhase(self.native)) ?? .error
    }

    private func displayPhase() -> NativePhase {
        let raw = phase()
        if raw == .ready {
            silentAutoConnectInProgress = false
            return .ready
        }
        if silentAutoConnectInProgress && (raw == .connecting || raw == .initializing || raw == .syncing || raw == .error || raw == .idle) {
            return .idle
        }
        if (raw == .syncing || raw == .committing) && shouldTreatAdvancedSettingSyncAsReady() {
            return .ready
        }
        if raw == .committing && !showDelayedCommit {
            return .ready
        }
        return raw
    }

    private func shouldTreatAdvancedSettingSyncAsReady() -> Bool {
        guard let startedAt = advancedSettingSyncStartedAt else {
            return false
        }
        return Date().timeIntervalSince(startedAt) >= advancedSettingSyncTimeout
    }

    private func noiseMode() -> NoiseMode {
        NoiseMode(rawValue: mdrNativeGetNoiseControlMode(self.native)) ?? .off
    }

    private func modelName() -> String {
        copyNativeString(size: 128, copier: mdrNativeCopyModelName)
    }

    private func firmwareVersion() -> String {
        copyNativeString(size: 64, copier: mdrNativeCopyFirmwareVersion)
    }

    private func trackTitle() -> String {
        copyNativeString(size: 256, copier: mdrNativeCopyTrackTitle)
    }

    private func trackAlbum() -> String {
        copyNativeString(size: 256, copier: mdrNativeCopyTrackAlbum)
    }

    private func trackArtist() -> String {
        copyNativeString(size: 256, copier: mdrNativeCopyTrackArtist)
    }

    private func uniqueId() -> String {
        copyNativeString(size: 64, copier: mdrNativeCopyUniqueId)
    }

    private func modelSeries() -> String {
        enumDisplayName(copyNativeString(size: 64, copier: mdrNativeCopyModelSeries))
    }

    private func modelColor() -> String {
        enumDisplayName(copyNativeString(size: 64, copier: mdrNativeCopyModelColor))
    }

    private func audioCodec() -> String {
        enumDisplayName(copyNativeString(size: 64, copier: mdrNativeCopyAudioCodec))
    }

    private func upscalingType() -> String {
        enumDisplayName(copyNativeString(size: 64, copier: mdrNativeCopyUpscalingType))
    }

    private func lastAlert() -> String {
        enumDisplayName(copyNativeString(size: 160, copier: mdrNativeCopyLastAlert))
    }

    private func lastInteraction() -> String {
        copyNativeString(size: 512, copier: mdrNativeCopyLastInteraction)
    }

    private func lastDeviceJSON() -> String {
        copyNativeString(size: 1024, copier: mdrNativeCopyLastDeviceJSON)
    }

    private func copyNativeString(size: Int, copier: (NativeHandle?, UnsafeMutablePointer<CChar>?, Int32) -> Void) -> String {
        var buffer = [CChar](repeating: 0, count: size)
        buffer.withUnsafeMutableBufferPointer { pointer in
            copier(self.native, pointer.baseAddress, Int32(size))
        }
        return String(cString: buffer)
    }

    private func enumDisplayName(_ raw: String) -> String {
        guard !raw.isEmpty, raw != "Unknown", raw != "UNSETTLED", raw != "DEFAULT" else {
            return tr("No disponible")
        }
        return raw
            .replacingOccurrences(of: "_", with: " ")
            .lowercased()
            .split(separator: " ")
            .map { token in
                token.count <= 4 ? token.uppercased() : token.prefix(1).uppercased() + String(token.dropFirst())
            }
            .joined(separator: " ")
    }

    private func pairedMDRDevices() -> [PairedMDRDevice] {
        let count = max(0, Int(mdrNativeGetPairedDeviceCount(self.native)))
        guard count > 0 else { return [] }

        var result: [PairedMDRDevice] = []
        for index in 0..<count {
            var nameBuffer = [CChar](repeating: 0, count: 160)
            var addressBuffer = [CChar](repeating: 0, count: 32)
            let nameBufferCount = Int32(nameBuffer.count)
            let addressBufferCount = Int32(addressBuffer.count)
            var connected: Int32 = 0
            var active: Int32 = 0
            let status = nameBuffer.withUnsafeMutableBufferPointer { namePointer in
                addressBuffer.withUnsafeMutableBufferPointer { addressPointer in
                    mdrNativeCopyPairedDevice(
                        self.native,
                        Int32(index),
                        namePointer.baseAddress,
                        nameBufferCount,
                        addressPointer.baseAddress,
                        addressBufferCount,
                        &connected,
                        &active
                    )
                }
            }
            guard status == 0 else { continue }
            result.append(PairedMDRDevice(
                name: String(cString: nameBuffer),
                address: String(cString: addressBuffer),
                isConnectedToHeadphones: connected != 0,
                isActivePlaybackDevice: active != 0
            ))
        }
        return result
    }

    private func generalSettings() -> [GeneralSettingItem] {
        let count = max(0, Int(mdrNativeGetGeneralSettingCount(self.native)))
        guard count > 0 else { return [] }

        var result: [GeneralSettingItem] = []
        for index in 0..<count {
            var titleBuffer = [CChar](repeating: 0, count: 160)
            var summaryBuffer = [CChar](repeating: 0, count: 320)
            let titleBufferCount = Int32(titleBuffer.count)
            let summaryBufferCount = Int32(summaryBuffer.count)
            var enabled: Int32 = 0
            let status = titleBuffer.withUnsafeMutableBufferPointer { titlePointer in
                summaryBuffer.withUnsafeMutableBufferPointer { summaryPointer in
                    mdrNativeCopyGeneralSetting(
                        self.native,
                        Int32(index),
                        titlePointer.baseAddress,
                        titleBufferCount,
                        summaryPointer.baseAddress,
                        summaryBufferCount,
                        &enabled
                    )
                }
            }
            guard status == 0 else { continue }
            result.append(GeneralSettingItem(
                index: index,
                titleKey: String(cString: titleBuffer),
                summaryKey: String(cString: summaryBuffer),
                isEnabled: enabled != 0
            ))
        }
        return result
    }

    private func generalSettingTitle(for key: String) -> String {
        switch key {
        case "MULTIPOINT_SETTING":
            return tr("Conectar a 2 dispositivos simultaneamente")
        case "SIDETONE_SETTING":
            return tr("Capturar voz durante llamada")
        case "TOUCH_PANEL_SETTING":
            return tr("Panel tactil")
        default:
            return key.isEmpty ? tr("Ajuste MDR") : enumDisplayName(key)
        }
    }

    private func generalSettingSummary(for key: String) -> String {
        switch key {
        case "MULTIPOINT_SETTING_SUMMARY":
            return tr("Permite usar los audifonos con dos dispositivos al mismo tiempo. Con conexiones simultaneas, LDAC puede no estar disponible.")
        case "MULTIPOINT_SETTING_SUMMARY_LDAC_AVAILABLE":
            return tr("Permite usar los audifonos con dos dispositivos al mismo tiempo.")
        case "SIDETONE_SETTING_SUMMARY":
            return tr("Hace que tu propia voz sea mas facil de escuchar durante llamadas.")
        default:
            return key.isEmpty ? "" : enumDisplayName(key)
        }
    }

    private func lastError() -> String {
        guard let pointer = mdrNativeGetLastError(self.native) else {
            return "Unknown error"
        }
        let value = String(cString: pointer)
        return value.isEmpty ? "Unknown error" : value
    }

    private func connect(device: BluetoothDevice, userInitiated: Bool = true) {
        connect(address: device.address, name: device.name, userInitiated: userInitiated, knownConnectedToMac: device.isConnectedToMac)
    }

    private func connect(address: String, name: String?, userInitiated: Bool = true, resetConnectionRetries: Bool = true, knownConnectedToMac: Bool? = nil) {
        let addressChanged = selectedAddress != address
        selectedAddress = address
        UserDefaults.standard.set(address, forKey: selectedAddressKey)
        rememberSelectedName(name, allowDefaultName: addressChanged)

        let connectedToMac = knownConnectedToMac ?? bluetoothDeviceIsConnectedToMac(address: address)
        guard connectedToMac else {
            silentAutoConnectInProgress = false
            connectionAttemptStartedAt = nil
            connectionRetryScheduled = false
            scheduleNextAutoReconnect(after: userInitiated ? 2 : autoReconnectBackoff)
            if popover.isShown {
                refreshPopoverContent()
            }
            return
        }

        if userInitiated {
            silentAutoConnectInProgress = false
            autoReconnectEnabled = true
            resetAutoReconnectBackoff()
        } else {
            silentAutoConnectInProgress = true
        }
        if resetConnectionRetries || lastConnectionAttemptAddress != address {
            connectionRetryCount = 0
            connectionRetryScheduled = false
        }
        connectionAttemptStartedAt = Date()
        lastConnectionAttemptAddress = address

        _ = address.withCString { pointer in
            mdrNativeConnect(self.native, pointer)
        }
        if userInitiated {
            deviceListExpanded = false
            if popover.isShown {
                refreshPopoverContent()
            }
        }
    }

    private func preferredDeviceName() -> String? {
        guard let name = normalizedName(selectedName) else {
            return nil
        }
        return name
    }

    private func rememberSelectedName(_ name: String?, allowDefaultName: Bool = false) {
        guard let cleanName = normalizedName(name) else {
            return
        }

        if !allowDefaultName,
           let currentName = normalizedName(selectedName),
           !looksLikeDefaultDeviceName(currentName),
           looksLikeDefaultDeviceName(cleanName) {
            return
        }

        selectedName = cleanName
        UserDefaults.standard.set(cleanName, forKey: selectedNameKey)
    }

    private func normalizedName(_ name: String?) -> String? {
        guard let trimmed = name?.trimmingCharacters(in: .whitespacesAndNewlines),
              !trimmed.isEmpty,
              trimmed != "Bluetooth Device"
        else {
            return nil
        }
        return trimmed
    }

    private func looksLikeDefaultDeviceName(_ name: String) -> Bool {
        let uppercased = name.uppercased()
        let lowercased = name.lowercased()
        return uppercased == "WH-1000XM5" ||
            uppercased == "WF-1000XM5" ||
            uppercased.hasPrefix("WH-") ||
            uppercased.hasPrefix("WF-") ||
            lowercased == "bluetooth device"
    }

    private func setNoiseControl(mode: NoiseMode, ambientLevel: Int32? = nil, focusOnVoice: Bool? = nil) {
        let level = ambientLevel ?? max(1, min(20, mdrNativeGetAmbientLevel(self.native)))
        let focus = focusOnVoice ?? (mdrNativeGetFocusOnVoice(self.native) != 0)
        suppressProgrammaticNoisePillUntil = Date().addingTimeInterval(2.0)
        _ = mdrNativeSetNoiseControl(self.native, mode.rawValue, level, focus ? 1 : 0)
        refreshPopoverContent()
    }

    private func handleNotificationPillTriggers() {
        let currentPhase = displayPhase()
        let currentNoiseMode = noiseMode()
        defer {
            lastObservedPhase = currentPhase
            lastObservedNoiseMode = currentNoiseMode
        }

        guard currentPhase == .ready else {
            notifiedBatteryThresholds.removeAll()
            return
        }

        if lastObservedPhase != .ready {
            notifiedBatteryThresholds.removeAll()
            showNotificationPill(
                title: headerTitle(),
                subtitle: batteryAttributedText(),
                symbol: "xmbar.headphones"
            )
            return
        }

        if let threshold = currentBatteryWarningThreshold(), !notifiedBatteryThresholds.contains(threshold) {
            notifiedBatteryThresholds.insert(threshold)
            showNotificationPill(
                title: "Batería baja",
                subtitle: batteryAttributedText(),
                symbol: batteryPillSymbol(percent: threshold),
                accent: .systemYellow
            )
            return
        }

        guard let lastObservedNoiseMode, lastObservedNoiseMode != currentNoiseMode else {
            return
        }

        // If XMBar itself requested the change, keep quiet. If the headphones button
        // toggled ANC externally, the native state changes without this suppression window.
        guard Date() >= suppressProgrammaticNoisePillUntil else {
            return
        }

        showNotificationPill(
            title: noisePillTitle(currentNoiseMode),
            subtitle: batteryAttributedText(),
            symbol: noisePillSymbol(currentNoiseMode)
        )
    }

    private func currentBatteryWarningThreshold() -> Int? {
        let levels = [
            Int(mdrNativeGetBatteryLeft(self.native)),
            Int(mdrNativeGetBatteryRight(self.native)),
            Int(mdrNativeGetBatteryCase(self.native))
        ].filter { $0 > 0 }

        for level in levels.sorted() {
            if batteryWarningThresholds.contains(level) {
                return level
            }
        }
        return nil
    }

    private func noisePillTitle(_ mode: NoiseMode) -> String {
        switch mode {
        case .noiseCancelling:
            return "Cancelación de ruido"
        case .ambient:
            return "Modo ambiente"
        case .adaptive:
            return "Control adaptativo"
        case .off:
            return "Modo pasivo"
        }
    }

    private func noisePillSymbol(_ mode: NoiseMode) -> String {
        switch mode {
        case .noiseCancelling:
            return "waveform.slash"
        case .ambient:
            return "ear"
        case .adaptive:
            return "sparkles"
        case .off:
            return "power"
        }
    }

    private func batteryPillSymbol(percent: Int) -> String {
        switch percent {
        case 16...20:
            return "battery.25percent"
        default:
            return "battery.0percent"
        }
    }

    private func showNotificationPill(
        title: String,
        subtitle: NSAttributedString,
        symbol: String = "xmbar.headphones",
        accent: NSColor = .controlAccentColor
    ) {
        guard notificationPillEnabled() else { return }
        notificationPillDismissWorkItem?.cancel()

        let width: CGFloat = 260
        let height: CGFloat = 58
        let screenFrame = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 1440, height: 900)
        let finalOrigin = NSPoint(
            x: screenFrame.midX - width / 2,
            y: screenFrame.maxY - height - 62
        )
        let startOrigin = NSPoint(x: finalOrigin.x, y: finalOrigin.y + 6)

        let content = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: width, height: height))
        content.material = .popover
        content.blendingMode = .behindWindow
        content.state = .active
        content.wantsLayer = true
        content.layer?.cornerRadius = 16
        content.layer?.cornerCurve = .continuous
        content.layer?.masksToBounds = true

        let icon = NSImageView(frame: NSRect(x: 16, y: 17, width: 24, height: 24))
        if symbol == "xmbar.headphones" {
            icon.image = xmbarHeadphonesIcon(pointSize: 24, tint: accent)
            icon.contentTintColor = nil
        } else {
            icon.image = symbolImage(named: symbol, pointSize: 21, weight: .regular)
            icon.contentTintColor = accent
            icon.symbolConfiguration = NSImage.SymbolConfiguration(pointSize: 21, weight: .regular)
        }
        content.addSubview(icon)

        let titleLabel = NSTextField(labelWithString: tr(title))
        titleLabel.frame = NSRect(x: 52, y: 31, width: width - 68, height: 18)
        titleLabel.font = NSFont.systemFont(ofSize: 12.5, weight: .semibold)
        titleLabel.textColor = .labelColor
        titleLabel.lineBreakMode = .byTruncatingTail
        content.addSubview(titleLabel)

        let subtitleLabel = NSTextField(labelWithAttributedString: subtitle)
        subtitleLabel.frame = NSRect(x: 52, y: 11, width: width - 68, height: 17)
        subtitleLabel.lineBreakMode = .byTruncatingTail
        content.addSubview(subtitleLabel)

        let window = NSWindow(
            contentRect: NSRect(origin: startOrigin, size: NSSize(width: width, height: height)),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = true
        window.level = .statusBar
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient, .ignoresCycle]
        window.ignoresMouseEvents = true
        window.contentView = content
        window.alphaValue = 0

        notificationPillWindow?.orderOut(nil)
        notificationPillWindow = window
        window.orderFrontRegardless()

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.22
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            window.animator().alphaValue = 1
            window.animator().setFrameOrigin(finalOrigin)
        }

        let dismiss = DispatchWorkItem { [weak self, weak window] in
            guard let window else { return }
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.20
                context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                window.animator().alphaValue = 0
                window.animator().setFrameOrigin(NSPoint(x: finalOrigin.x, y: finalOrigin.y + 4))
            } completionHandler: {
                window.orderOut(nil)
                if let current = self?.notificationPillWindow, current === window {
                    self?.notificationPillWindow = nil
                }
            }
        }
        notificationPillDismissWorkItem = dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: dismiss)
    }

    private func xmbarHeadphonesIcon(pointSize: CGFloat, tint: NSColor = .labelColor) -> NSImage {
        let size = NSSize(width: pointSize, height: pointSize)
        let target = NSImage(size: size)

        guard let symbol = NSImage(systemSymbolName: "airpodsmax", accessibilityDescription: nil) ??
            NSImage(systemSymbolName: "headphones", accessibilityDescription: nil) else {
            return target
        }

        let config = NSImage.SymbolConfiguration(pointSize: pointSize, weight: .regular)
        let configured = symbol.withSymbolConfiguration(config) ?? symbol
        let rect = NSRect(x: 0, y: 0, width: pointSize, height: pointSize)

        target.lockFocus()
        tint.setFill()
        rect.fill()
        configured.draw(in: rect, from: .zero, operation: .destinationIn, fraction: 1.0)
        target.unlockFocus()
        target.isTemplate = false
        return target
    }

    private func symbolImage(_ name: String, pointSize: CGFloat, weight: NSFont.Weight) -> NSImage? {
        guard let image = NSImage(systemSymbolName: name, accessibilityDescription: nil) else {
            return nil
        }
        let config = NSImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        return image.withSymbolConfiguration(config)
    }

    private func symbolImage(named name: String, pointSize: CGFloat, weight: NSFont.Weight) -> NSImage? {
        let fallbacks: [String: [String]] = [
            "ear": ["ear", "headphones"],
            "waveform": ["waveform", "dot.radiowaves.left.and.right"],
            "waveform.slash": ["waveform.slash", "speaker.slash", "xmark"],
            "sparkles": ["sparkles", "wand.and.sparkles"],
            "arrow.triangle.2.circlepath": ["arrow.triangle.2.circlepath", "arrow.2.circlepath"],
            "person.fill": ["person.fill", "person"],
            "slash": ["slash", "xmark"],
            "airpodsmax": ["airpodsmax", "headphones"],
            "headphones.circle": ["headphones.circle", "headphones"],
            "battery.25percent": ["battery.25percent", "battery.25", "battery.0percent", "battery.0"],
            "battery.0percent": ["battery.0percent", "battery.0"],
            "power": ["power", "power.circle", "circle"],
            "speaker.wave.2": ["speaker.wave.2", "speaker.wave.1", "speaker"],
            "speaker.wave.1": ["speaker.wave.1", "speaker"],
            "wand.and.sparkles": ["wand.and.sparkles", "sparkles"],
            "quote.bubble": ["quote.bubble", "bubble.left"],
            "button.programmable": ["button.programmable", "circle.grid.cross", "circle"],
            "hand.tap": ["hand.tap", "hand.point.up.left", "hand.raised"],
            "l.circle": ["l.circle", "circle"],
            "r.circle": ["r.circle", "circle"]
        ]

        for candidate in fallbacks[name] ?? [name, "circle"] {
            if let image = symbolImage(candidate, pointSize: pointSize, weight: weight) {
                return image
            }
        }

        return symbolImage("circle", pointSize: pointSize, weight: weight)
    }

    private func iconView(symbol: String, accessory: String?, enabled: Bool) -> NSView {
        let tint: NSColor = enabled ? .secondaryLabelColor : .disabledControlTextColor
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 20, height: 20))
        let base = NSImageView(frame: NSRect(x: 1, y: 0, width: 18, height: 18))
        base.image = symbolImage(named: symbol, pointSize: 17, weight: .regular)
        base.contentTintColor = tint
        container.addSubview(base)

        if let accessory {
            let overlay = NSImageView(frame: NSRect(x: 11, y: 10, width: 10, height: 10))
            overlay.image = symbolImage(named: accessory, pointSize: 9, weight: .semibold)
            overlay.contentTintColor = tint
            container.addSubview(overlay)
        }

        return container
    }

    private func ensureAdvancedWindow() -> NSWindow {
        if let advancedWindow {
            return advancedWindow
        }

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 560, height: 640),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = tr("Configuracion XMBar")
        window.isReleasedWhenClosed = false
        window.minSize = NSSize(width: 500, height: 420)
        window.contentView = makeAdvancedRootView(size: window.contentLayoutRect.size)
        window.center()
        advancedWindow = window
        return window
    }

    private func rebuildAdvancedWindowContent(preserveScroll: Bool = true) {
        guard let window = advancedWindow else {
            return
        }
        let previousOrigin = preserveScroll ? advancedScrollView?.contentView.bounds.origin : nil
        window.contentView = makeAdvancedRootView(size: window.contentLayoutRect.size)
        lastAdvancedRenderSignature = renderSignature()
        if let previousOrigin {
            DispatchQueue.main.async { [weak self] in
                self?.advancedScrollView?.contentView.scroll(to: previousOrigin)
                self?.advancedScrollView?.reflectScrolledClipView(self?.advancedScrollView?.contentView ?? NSClipView())
            }
        }
    }

    private func makeAdvancedRootView(size: NSSize) -> NSView {
        let root = NSVisualEffectView(frame: NSRect(origin: .zero, size: size))
        root.material = .hudWindow
        root.blendingMode = .behindWindow
        root.state = .active
        root.autoresizingMask = [.width, .height]

        let scroll = NSScrollView(frame: root.bounds)
        scroll.autoresizingMask = [.width, .height]
        scroll.borderType = .noBorder
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = true
        scroll.autohidesScrollers = true
        scroll.documentView = makeAdvancedDocument(width: max(460, size.width - 40))
        root.addSubview(scroll)
        advancedScrollView = scroll

        return root
    }

    private func quickControlDefaultsKey(_ id: String) -> String {
        "\(quickControlPrefix)\(id)"
    }

    private func quickControlEnabled(_ id: String) -> Bool {
        let key = quickControlDefaultsKey(id)
        if UserDefaults.standard.object(forKey: key) == nil {
            switch id {
            case "devices", "noiseControl", "ambientLevel", "speakToChat", "volume":
                return true
            default:
                return false
            }
        }
        return UserDefaults.standard.bool(forKey: key)
    }

    private func quickControlSupported(_ id: String) -> Bool {
        // Cuando aun no hay datos MDR listos, conserva la configuracion visible en la UI.
        // En cuanto el modelo queda listo, ocultamos lo que ese modelo no soporta.
        guard displayPhase() == .ready else { return true }

        switch id {
        case "noiseControl":
            return mdrNativeSupportsAmbientSound(self.native) != 0
                || mdrNativeSupportsNoiseCancelling(self.native) != 0
                || mdrNativeSupportsAutoAmbientSound(self.native) != 0
        case "ambientLevel":
            return mdrNativeSupportsAmbientSound(self.native) != 0
        case "speakToChat":
            return mdrNativeSupportsSpeakToChat(self.native) != 0
        case "volume":
            return mdrNativeGetPlayVolume(self.native) >= 0
        case "dsee":
            return mdrNativeSupportsUpscaling(self.native) != 0
        case "voiceGuidance":
            return mdrNativeSupportsVoiceGuidance(self.native) != 0
        case "voiceGuidanceVolume":
            return mdrNativeSupportsVoiceGuidanceVolume(self.native) != 0
        case "ncButton":
            return mdrNativeSupportsNcAsmButtonSettings(self.native) != 0
        case "touchLeft", "touchRight":
            return mdrNativeSupportsAssignableSettings(self.native) != 0
        default:
            return true
        }
    }

    private func quickControlVisible(_ id: String) -> Bool {
        quickControlEnabled(id) && quickControlSupported(id)
    }

    private func anyQuickSoundControlVisible() -> Bool {
        ["volume", "dsee", "voiceGuidance", "voiceGuidanceVolume"].contains { quickControlVisible($0) }
    }

    private func anyQuickButtonControlVisible() -> Bool {
        ["ncButton", "touchLeft", "touchRight"].contains { quickControlVisible($0) }
    }

    private func setQuickControl(_ id: String, enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: quickControlDefaultsKey(id))
        refreshPopoverContent()
        rebuildAdvancedWindowContent()
    }

    private func makeAdvancedDocument(width: CGFloat) -> NSView {
        let document = FlippedView(frame: NSRect(x: 0, y: 0, width: width, height: 1))
        let controlsEnabled = displayPhase() == .ready
        let eqEnabled = controlsEnabled && mdrNativeGetEqAvailable(self.native) != 0
        let supportsConnectionQuality = controlsEnabled && mdrNativeSupportsConnectionQuality(self.native) != 0
        let supportsUpscaling = controlsEnabled && mdrNativeSupportsUpscaling(self.native) != 0
        let upscalingAvailable = supportsUpscaling && mdrNativeGetUpscalingAvailable(self.native) != 0
        let supportsListeningMode = controlsEnabled && mdrNativeSupportsListeningMode(self.native) != 0
        let supportsAutoPause = controlsEnabled && mdrNativeSupportsAutoPause(self.native) != 0
        let supportsHeadGesture = controlsEnabled && mdrNativeSupportsHeadGesture(self.native) != 0
        let supportsAutoPowerOff = controlsEnabled && mdrNativeSupportsAutoPowerOff(self.native) != 0
        let supportsAutoPowerOffWearing = controlsEnabled && mdrNativeSupportsAutoPowerOffWearingDetection(self.native) != 0
        let supportsNcAsmButton = controlsEnabled && mdrNativeSupportsNcAsmButtonSettings(self.native) != 0
        let supportsAssignableSettings = controlsEnabled && mdrNativeSupportsAssignableSettings(self.native) != 0
        let supportsVoiceGuidance = controlsEnabled && mdrNativeSupportsVoiceGuidance(self.native) != 0
        let supportsVoiceGuidanceVolume = controlsEnabled && mdrNativeSupportsVoiceGuidanceVolume(self.native) != 0
        let supportsAutoAmbient = controlsEnabled && mdrNativeSupportsAutoAmbientSound(self.native) != 0
        let supportsPlayback = controlsEnabled && mdrNativeSupportsPlaybackControl(self.native) != 0
        let supportsPairingManagement = controlsEnabled && mdrNativeSupportsPairingDeviceManagement(self.native) != 0
        let supportsSafeListening = controlsEnabled && mdrNativeSupportsSafeListening(self.native) != 0
        var cursorY: CGFloat = 0

        func append(_ view: NSView, inset: CGFloat = 20) {
            view.frame.origin = NSPoint(x: inset, y: cursorY)
            cursorY += view.frame.height
            document.addSubview(view)
        }

        append(spacer(height: 14), inset: 0)
        append(advancedHeader(width: width - 40))
        if advancedDeviceListExpanded {
            append(advancedSettingsDeviceList(width: width - 40))
            append(spacer(height: 6), inset: 0)
        }

        if !controlsEnabled {
            append(advancedNote(statusText(), width: width - 40))
            append(spacer(height: 6), inset: 0)
        }

        append(advancedSectionTitle("Reproduccion", width: width - 40))
        if trackTitle().isEmpty && trackAlbum().isEmpty && trackArtist().isEmpty {
            append(advancedNote("Sin informacion de reproduccion.", width: width - 40))
        } else {
            append(advancedInfoRow(title: "Titulo", value: trackTitle(), width: width - 40, enabled: controlsEnabled))
            append(advancedInfoRow(title: "Album", value: trackAlbum(), width: width - 40, enabled: controlsEnabled))
            append(advancedInfoRow(title: "Artista", value: trackArtist(), width: width - 40, enabled: controlsEnabled))
        }
        append(advancedPlaybackControlsRow(width: width - 40, enabled: supportsPlayback))

        append(advancedSectionTitle("Ecualizador", width: width - 40))
        append(advancedPopupRow(
            title: "Preset",
            options: Self.eqPresetOptions,
            current: Int(mdrNativeGetEqPreset(self.native)),
            action: #selector(eqPresetChanged(_:)),
            width: width - 40,
            enabled: eqEnabled
        ))

        let bandCount = max(0, Int(mdrNativeGetEqBandCount(self.native)))
        if bandCount == 5 {
            append(advancedSliderRow(
                title: "Clear Bass",
                value: mdrNativeGetEqClearBass(self.native),
                range: -10...10,
                tag: 0,
                action: #selector(eqClearBassChanged(_:)),
                width: width - 40,
                enabled: eqEnabled
            ))
        }

        if bandCount > 0 {
            for index in 0..<min(bandCount, 10) {
                append(advancedSliderRow(
                    title: eqBandTitle(index: index, count: bandCount),
                    value: mdrNativeGetEqBand(self.native, Int32(index)),
                    range: -10...10,
                    tag: index,
                    action: #selector(eqBandChanged(_:)),
                    width: width - 40,
                    enabled: eqEnabled
                ))
            }
        } else {
            append(advancedNote("El ecualizador no reporto bandas configurables.", width: width - 40))
        }

        append(advancedSectionTitle("Sonido", width: width - 40))
        append(advancedSliderRow(
            title: "Volumen",
            value: mdrNativeGetPlayVolume(self.native),
            range: 0...30,
            tag: 0,
            action: #selector(playVolumeChanged(_:)),
            width: width - 40,
            enabled: controlsEnabled
        ))
        append(advancedPopupRow(
            title: "Prioridad",
            options: Self.audioPriorityOptions,
            current: Int(mdrNativeGetAudioPriorityMode(self.native)),
            action: #selector(audioPriorityChanged(_:)),
            width: width - 40,
            enabled: supportsConnectionQuality
        ))
        append(advancedCheckboxRow(
            title: "DSEE / upscaling",
            checked: mdrNativeGetUpscalingEnabled(self.native) != 0,
            action: #selector(upscalingChanged(_:)),
            width: width - 40,
            enabled: upscalingAvailable
        ))
        append(advancedInfoRow(
            title: "DSEE disponible",
            value: mdrNativeGetUpscalingAvailable(self.native) != 0 ? tr("Activado") : tr("Desactivado"),
            width: width - 40,
            enabled: supportsUpscaling
        ))
        append(advancedInfoRow(
            title: "Tipo DSEE",
            value: upscalingType(),
            width: width - 40,
            enabled: supportsUpscaling
        ))
        append(advancedPopupRow(
            title: "Modo escucha",
            options: [
                PopupOption(title: "Estandar", value: 0),
                PopupOption(title: "BGM", value: 1),
                PopupOption(title: "Cinema", value: 2)
            ],
            current: Int(mdrNativeGetListeningMode(self.native)),
            action: #selector(listeningModeChanged(_:)),
            width: width - 40,
            enabled: supportsListeningMode
        ))
        append(advancedPopupRow(
            title: "Espacio BGM",
            options: Self.roomSizeOptions,
            current: Int(mdrNativeGetBgmRoomSize(self.native)),
            action: #selector(bgmRoomSizeChanged(_:)),
            width: width - 40,
            enabled: supportsListeningMode && mdrNativeGetListeningMode(self.native) == 1
        ))
        append(advancedPopupRow(
            title: "Sensibilidad auto ambiente",
            options: Self.noiseAdaptiveSensitivityOptions,
            current: Int(mdrNativeGetNoiseAdaptiveSensitivity(self.native)),
            action: #selector(noiseAdaptiveSensitivityChanged(_:)),
            width: width - 40,
            enabled: supportsAutoAmbient && noiseMode() == .adaptive
        ))

        append(advancedSectionTitle("Conversacion y comodidad", width: width - 40))
        append(advancedCheckboxRow(
            title: "Reconocimiento de conversacion",
            checked: mdrNativeGetSpeakToChatEnabled(self.native) != 0,
            action: #selector(advancedSpeakToChatChanged(_:)),
            width: width - 40,
            enabled: controlsEnabled && mdrNativeSupportsSpeakToChat(self.native) != 0
        ))
        append(advancedPopupRow(
            title: "Sensibilidad",
            options: Self.speakSensitivityOptions,
            current: Int(mdrNativeGetSpeakToChatSensitivity(self.native)),
            action: #selector(speakSensitivityChanged(_:)),
            width: width - 40,
            enabled: controlsEnabled && mdrNativeSupportsSpeakToChat(self.native) != 0 && mdrNativeGetSpeakToChatEnabled(self.native) != 0
        ))
        append(advancedPopupRow(
            title: "Duracion",
            options: Self.speakDurationOptions,
            current: Int(mdrNativeGetSpeakToChatModeOutTime(self.native)),
            action: #selector(speakDurationChanged(_:)),
            width: width - 40,
            enabled: controlsEnabled && mdrNativeSupportsSpeakToChat(self.native) != 0 && mdrNativeGetSpeakToChatEnabled(self.native) != 0
        ))
        append(advancedCheckboxRow(
            title: "Pausar al retirar",
            checked: mdrNativeGetAutoPauseEnabled(self.native) != 0,
            action: #selector(autoPauseChanged(_:)),
            width: width - 40,
            enabled: supportsAutoPause
        ))
        append(advancedCheckboxRow(
            title: "Gestos de cabeza",
            checked: mdrNativeGetHeadGestureEnabled(self.native) != 0,
            action: #selector(headGestureChanged(_:)),
            width: width - 40,
            enabled: supportsHeadGesture
        ))

        append(advancedSectionTitle("Sistema", width: width - 40))
        append(advancedPopupRow(
            title: "Idioma",
            options: Self.languageOptions,
            current: languagePopupValue(),
            action: #selector(languageChanged(_:)),
            width: width - 40,
            enabled: true
        ))
        append(advancedCheckboxRow(
            title: "Lanzar XMBar con el sistema",
            checked: launchAtLoginEnabled(),
            action: #selector(launchAtLoginChanged(_:)),
            width: width - 40,
            enabled: launchAtLoginAvailable()
        ))
        append(advancedCheckboxRow(
            title: "Ocultar XMBar al desconectar",
            checked: hideWhenDisconnectedEnabled(),
            action: #selector(hideWhenDisconnectedChanged(_:)),
            width: width - 40,
            enabled: true
        ))
        append(advancedCheckboxRow(
            title: "Mostrar pildora emergente",
            checked: notificationPillEnabled(),
            action: #selector(notificationPillEnabledChanged(_:)),
            width: width - 40,
            enabled: true
        ))
        append(advancedCheckboxRow(
            title: "Guia de voz",
            checked: mdrNativeGetVoiceGuidanceEnabled(self.native) != 0,
            action: #selector(voiceGuidanceChanged(_:)),
            width: width - 40,
            enabled: supportsVoiceGuidance
        ))
        append(advancedSliderRow(
            title: "Volumen guia",
            value: mdrNativeGetVoiceGuidanceVolume(self.native),
            range: -2...2,
            tag: 0,
            action: #selector(voiceGuidanceVolumeChanged(_:)),
            width: width - 40,
            enabled: supportsVoiceGuidanceVolume && mdrNativeGetVoiceGuidanceEnabled(self.native) != 0
        ))
        append(advancedPopupRow(
            title: "Apagado automatico",
            options: Self.powerAutoOffOptions,
            current: Int(mdrNativeGetPowerAutoOff(self.native)),
            action: #selector(powerAutoOffChanged(_:)),
            width: width - 40,
            enabled: supportsAutoPowerOff
        ))
        append(advancedPopupRow(
            title: "Apagado por sensor",
            options: Self.powerAutoOffWearingOptions,
            current: Int(mdrNativeGetPowerAutoOffWearingDetection(self.native)),
            action: #selector(powerAutoOffWearingChanged(_:)),
            width: width - 40,
            enabled: supportsAutoPowerOffWearing
        ))
        append(advancedButtonRow(
            title: "Apagar audifonos",
            buttonTitle: "Apagar",
            action: #selector(shutdownHeadphonesClicked(_:)),
            width: width - 40,
            enabled: controlsEnabled && mdrNativeSupportsPowerOff(self.native) != 0
        ))

        let generalItems = generalSettings()
        if !generalItems.isEmpty {
            append(advancedSectionTitle("Ajustes generales MDR", width: width - 40))
            for item in generalItems {
                append(advancedCheckboxRow(
                    title: generalSettingTitle(for: item.titleKey),
                    checked: item.isEnabled,
                    action: #selector(generalSettingChanged(_:)),
                    width: width - 40,
                    enabled: controlsEnabled,
                    tag: item.index
                ))
                let summary = generalSettingSummary(for: item.summaryKey)
                if !summary.isEmpty {
                    append(advancedNote(summary, width: width - 40))
                }
            }
        }

        append(advancedSectionTitle("Controles", width: width - 40))
        append(advancedPopupRow(
            title: "Boton NC/AMB",
            options: Self.ncAsmButtonOptions,
            current: Int(mdrNativeGetNcAsmButtonFunction(self.native)),
            action: #selector(ncAsmButtonChanged(_:)),
            width: width - 40,
            enabled: supportsNcAsmButton
        ))
        append(advancedPopupRow(
            title: "Touch izquierdo",
            options: Self.touchFunctionOptions,
            current: Int(mdrNativeGetTouchFunctionLeft(self.native)),
            action: #selector(touchLeftChanged(_:)),
            width: width - 40,
            enabled: supportsAssignableSettings
        ))
        append(advancedPopupRow(
            title: "Touch derecho",
            options: Self.touchFunctionOptions,
            current: Int(mdrNativeGetTouchFunctionRight(self.native)),
            action: #selector(touchRightChanged(_:)),
            width: width - 40,
            enabled: supportsAssignableSettings
        ))

        if supportsSafeListening || mdrNativeGetSafeListeningSoundPressure(self.native) > 0 {
            append(advancedSectionTitle("Escucha segura", width: width - 40))
            append(advancedInfoRow(
                title: "Presion sonora",
                value: mdrNativeGetSafeListeningSoundPressure(self.native) >= 0 ? "\(mdrNativeGetSafeListeningSoundPressure(self.native))" : tr("No disponible"),
                width: width - 40,
                enabled: controlsEnabled
            ))
            append(advancedCheckboxRow(
                title: "Modo seguro",
                checked: mdrNativeGetSafeListeningPreviewMode(self.native) != 0,
                action: #selector(safeListeningPreviewChanged(_:)),
                width: width - 40,
                enabled: supportsSafeListening
            ))
        }

        let supportedQuickControls = Self.quickControlDefinitions.filter { quickControlSupported($0.id) }
        if !supportedQuickControls.isEmpty {
            append(advancedSectionTitle("Controles rapidos", width: width - 40))
            for definition in supportedQuickControls {
                append(advancedQuickControlRow(definition: definition, width: width - 40, enabled: controlsEnabled))
            }
            append(spacer(height: 8), inset: 0)
        }

        let supportedShortcuts = Self.shortcutDefinitions.filter { shortcutSupported($0.id) }
        if !supportedShortcuts.isEmpty {
            append(advancedSectionTitle("Atajos", width: width - 40))
            append(advancedNote("Asigna combinaciones de teclado. Por defecto no hay ninguna asignada. Para usar atajos globales, macOS puede pedir permiso de accesibilidad.", width: width - 40))
            for definition in supportedShortcuts {
                append(advancedShortcutRow(definition: definition, width: width - 40, enabled: controlsEnabled || definition.id == "openPanel" || definition.id == "openSettings"))
            }
            append(spacer(height: 8), inset: 0)
        }

        append(advancedSectionTitle("Dispositivos MDR", width: width - 40))
        append(advancedCheckboxRow(
            title: "Modo emparejamiento",
            checked: mdrNativeGetPairingMode(self.native) != 0,
            action: #selector(pairingModeChanged(_:)),
            width: width - 40,
            enabled: supportsPairingManagement
        ))
        append(advancedPairedDevicesView(width: width - 40, enabled: supportsPairingManagement))


        let batteryRows = batteryDiagnostics()
        if !batteryRows.isEmpty {
            append(advancedSectionTitle("Bateria MDR", width: width - 40))
            for row in batteryRows {
                append(advancedInfoRow(title: row.title, value: row.value, width: width - 40, enabled: controlsEnabled))
            }
        }


        append(advancedSectionTitle("Informacion MDR", width: width - 40))
        append(advancedInfoRow(title: "Modelo", value: modelName(), width: width - 40, enabled: controlsEnabled))
        append(advancedInfoRow(title: "MAC", value: uniqueId(), width: width - 40, enabled: controlsEnabled))
        append(advancedInfoRow(title: "Firmware", value: firmwareVersion(), width: width - 40, enabled: controlsEnabled))
        append(advancedInfoRow(title: "Serie", value: modelSeries(), width: width - 40, enabled: controlsEnabled))
        append(advancedInfoRow(title: "Color", value: modelColor(), width: width - 40, enabled: controlsEnabled))
        append(advancedInfoRow(title: "Codec", value: audioCodec(), width: width - 40, enabled: controlsEnabled))
        if !lastAlert().isEmpty && lastAlert() != tr("No disponible") {
            append(advancedInfoRow(title: "Alerta", value: lastAlert(), width: width - 40, enabled: controlsEnabled))
        }
        if !lastInteraction().isEmpty {
            append(advancedInfoRow(title: "Mensaje MDR", value: lastInteraction(), width: width - 40, enabled: controlsEnabled))
        }
        if !lastDeviceJSON().isEmpty {
            append(advancedInfoRow(title: "JSON dispositivo", value: lastDeviceJSON(), width: width - 40, enabled: controlsEnabled))
        }


        append(spacer(height: 16), inset: 0)
        append(advancedFooter(width: width - 40))
        append(spacer(height: 18), inset: 0)
        document.frame.size = NSSize(width: width, height: cursorY)
        return document
    }

    private func advancedFooter(width: CGFloat) -> NSView {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: width, height: 46))

        let version = appVersionString()
        let firstLine = NSTextField(labelWithString: "By Globular · V\(version)")
        firstLine.frame = NSRect(x: 0, y: 24, width: width, height: 16)
        firstLine.font = .systemFont(ofSize: 11, weight: .regular)
        firstLine.textColor = .tertiaryLabelColor
        firstLine.alignment = .center
        view.addSubview(firstLine)

        let secondLine = NSTextField(labelWithString: "Powered By MDR")
        secondLine.frame = NSRect(x: 0, y: 8, width: width, height: 16)
        secondLine.font = .systemFont(ofSize: 11, weight: .regular)
        secondLine.textColor = .tertiaryLabelColor
        secondLine.alignment = .center
        view.addSubview(secondLine)

        let hit = NSButton(frame: NSRect(x: 0, y: 4, width: width, height: 40))
        hit.title = ""
        hit.isBordered = false
        hit.target = self
        hit.action = #selector(showAboutXMBar(_:))
        hit.toolTip = "About XMBar"
        hit.setButtonType(.momentaryChange)
        hit.wantsLayer = true
        hit.layer?.backgroundColor = NSColor.clear.cgColor
        view.addSubview(hit)
        return view
    }

    private func appVersionString() -> String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.82"
    }

    @objc private func showAboutXMBar(_ sender: Any?) {
        let alert = NSAlert()
        alert.messageText = "XMBar"
        alert.informativeText = "Version \(appVersionString())\nBy Globular\nPowered By MDR\n\nAdvanced headphone control for macOS."
        alert.alertStyle = .informational
        if let icon = NSApplication.shared.applicationIconImage {
            alert.icon = icon
        } else if let icon = NSImage(named: "AppIcon") {
            alert.icon = icon
        }
        alert.addButton(withTitle: "OK")
        if let window = advancedWindow, window.isVisible {
            alert.beginSheetModal(for: window, completionHandler: nil)
        } else {
            alert.runModal()
        }
    }

    private func advancedHeader(width: CGFloat) -> NSView {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: width, height: 56))

        let bubble = NSView(frame: NSRect(x: 0, y: 8, width: 40, height: 40))
        bubble.wantsLayer = true
        bubble.layer?.cornerRadius = 20
        bubble.layer?.backgroundColor = NSColor.systemBlue.cgColor
        view.addSubview(bubble)

        let icon = NSImageView(frame: NSRect(x: 8, y: 8, width: 24, height: 24))
        icon.image = xmbarHeadphonesIcon(pointSize: 24, tint: .white)
        icon.contentTintColor = nil
        bubble.addSubview(icon)

        let title = NSTextField(labelWithString: headerTitle())
        title.frame = NSRect(x: 54, y: 29, width: max(120, width - 94), height: 20)
        title.font = .systemFont(ofSize: 17, weight: .semibold)
        title.textColor = .labelColor
        view.addSubview(title)

        let subtitle = NSTextField(labelWithString: firmwareVersion().isEmpty ? headerSubtitle() : "Firmware \(firmwareVersion())")
        subtitle.frame = NSRect(x: 54, y: 9, width: max(120, width - 94), height: 18)
        subtitle.font = .systemFont(ofSize: 12)
        subtitle.textColor = .secondaryLabelColor
        view.addSubview(subtitle)

        let disclosure = NSButton(frame: NSRect(x: width - 30, y: 18, width: 26, height: 24))
        disclosure.image = symbolImage(advancedDeviceListExpanded ? "chevron.up" : "chevron.down", pointSize: 15, weight: .semibold)
        disclosure.contentTintColor = .secondaryLabelColor
        disclosure.imagePosition = .imageOnly
        disclosure.isBordered = false
        disclosure.toolTip = advancedDeviceListExpanded ? "Ocultar dispositivos Bluetooth" : "Mostrar dispositivos Bluetooth"
        disclosure.target = self
        disclosure.action = #selector(toggleAdvancedDeviceList(_:))
        view.addSubview(disclosure)

        return view
    }

    private func advancedSettingsDeviceList(width: CGFloat) -> NSView {
        let visibleDevices = cachedDevices.prefix(8)
        let rowHeight: CGFloat = 38
        let headerHeight: CGFloat = 30
        let emptyHeight: CGFloat = 38
        let height = headerHeight + (cachedDevices.isEmpty ? emptyHeight : CGFloat(visibleDevices.count) * rowHeight)
        let root = NSView(frame: NSRect(x: 0, y: 0, width: width, height: height))

        let title = NSTextField(labelWithString: tr("Dispositivos"))
        title.frame = NSRect(x: 0, y: height - 24, width: width - 40, height: 18)
        title.font = .systemFont(ofSize: 13, weight: .semibold)
        title.textColor = NSColor(calibratedRed: 0.23, green: 0.38, blue: 0.48, alpha: 1.0)
        root.addSubview(title)

        if cachedDevices.isEmpty {
            let note = NSTextField(labelWithString: tr("No hay dispositivos Bluetooth visibles."))
            note.frame = NSRect(x: 0, y: 6, width: width, height: 18)
            note.font = .systemFont(ofSize: 12)
            note.textColor = .secondaryLabelColor
            root.addSubview(note)
            return root
        }

        for (offset, device) in visibleDevices.enumerated() {
            let index = offset
            let rowY = height - headerHeight - CGFloat(offset + 1) * rowHeight
            let row = NSView(frame: NSRect(x: 0, y: rowY, width: width, height: rowHeight))

            let checked = device.address == selectedAddress
            let check = NSImageView(frame: NSRect(x: 0, y: 11, width: 16, height: 16))
            check.image = checked ? symbolImage("checkmark", pointSize: 14, weight: .semibold) : nil
            check.contentTintColor = .labelColor
            row.addSubview(check)

            let icon = NSImageView(frame: NSRect(x: 30, y: 10, width: 18, height: 18))
            icon.image = xmbarHeadphonesIcon(pointSize: 18, tint: device.isConnectedToMac ? .secondaryLabelColor : .disabledControlTextColor)
            icon.contentTintColor = nil
            row.addSubview(icon)

            let name = NSTextField(labelWithString: device.displayName)
            name.frame = NSRect(x: 58, y: 18, width: max(120, width - 210), height: 16)
            name.font = .systemFont(ofSize: 13, weight: checked ? .semibold : .regular)
            name.textColor = device.isConnectedToMac ? .labelColor : .disabledControlTextColor
            row.addSubview(name)

            let detail = device.isConnectedToMac ? "Conectado al Mac" : "No conectado al Mac"
            let subtitle = NSTextField(labelWithString: tr(detail))
            subtitle.frame = NSRect(x: 58, y: 3, width: max(120, width - 210), height: 13)
            subtitle.font = .systemFont(ofSize: 10)
            subtitle.textColor = device.isConnectedToMac ? .secondaryLabelColor : .disabledControlTextColor
            row.addSubview(subtitle)

            let address = NSTextField(labelWithString: device.address)
            address.frame = NSRect(x: width - 128, y: 11, width: 128, height: 14)
            address.alignment = .right
            address.font = .monospacedSystemFont(ofSize: 9, weight: .regular)
            address.textColor = .tertiaryLabelColor
            row.addSubview(address)

            let button = NSButton(frame: row.bounds)
            button.isBordered = false
            button.title = ""
            button.target = self
            button.action = #selector(advancedDeviceClicked(_:))
            button.tag = index
            button.isEnabled = device.isConnectedToMac && !phase().isBusy
            button.autoresizingMask = [.width, .height]
            row.addSubview(button)

            root.addSubview(row)
        }

        return root
    }

    private func advancedSectionTitle(_ title: String, width: CGFloat) -> NSView {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: width, height: 36))

        let line = NSBox(frame: NSRect(x: 0, y: 4, width: width, height: 1))
        line.boxType = .separator
        view.addSubview(line)

        let label = NSTextField(labelWithString: tr(title))
        label.frame = NSRect(x: 0, y: 14, width: width, height: 18)
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = NSColor(calibratedRed: 0.23, green: 0.38, blue: 0.48, alpha: 1.0)
        view.addSubview(label)

        return view
    }

    private func advancedNote(_ text: String, width: CGFloat) -> NSView {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: width, height: 42))
        let label = NSTextField(wrappingLabelWithString: tr(text))
        label.frame = NSRect(x: 0, y: 8, width: width, height: 30)
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabelColor
        view.addSubview(label)
        return view
    }

    private func advancedInfoRow(title: String, value: String, width: CGFloat, enabled: Bool = true) -> NSView {
        let labelWidth = advancedLabelWidth(for: width)
        let controlX = labelWidth + 14
        let valueWidth = max(120, width - controlX)
        let localizedTitle = tr(title)
        let displayValue = value.isEmpty ? tr("No disponible") : value
        let titleHeight = advancedLabelHeight(for: localizedTitle, width: labelWidth)
        let valueHeight = advancedLabelHeight(for: displayValue, width: valueWidth)
        let height = max(CGFloat(34), max(titleHeight, valueHeight) + 12)
        let view = NSView(frame: NSRect(x: 0, y: 0, width: width, height: height))

        let label = advancedLabel(
            localizedTitle,
            frame: NSRect(x: 0, y: (height - titleHeight) / 2, width: labelWidth, height: titleHeight),
            enabled: enabled
        )
        view.addSubview(label)

        let valueLabel = NSTextField(wrappingLabelWithString: displayValue)
        valueLabel.frame = NSRect(x: controlX, y: (height - valueHeight) / 2, width: valueWidth, height: valueHeight)
        valueLabel.font = .systemFont(ofSize: 12)
        valueLabel.maximumNumberOfLines = 2
        valueLabel.lineBreakMode = .byTruncatingMiddle
        valueLabel.textColor = enabled ? .secondaryLabelColor : .disabledControlTextColor
        view.addSubview(valueLabel)

        return view
    }

    private func advancedPlaybackControlsRow(width: CGFloat, enabled: Bool) -> NSView {
        let controls = NSView(frame: NSRect(x: 0, y: 0, width: 260, height: 28))
        let status = mdrNativeGetPlaybackStatus(self.native)
        let playTitle = status == 1 ? "Pausar" : "Reproducir"
        let playControl = status == 1 ? 1 : 7
        let specs: [(String, Int32, CGFloat)] = [
            ("Anterior", 3, 78),
            (playTitle, Int32(playControl), 86),
            ("Siguiente", 2, 86)
        ]

        var cursorX: CGFloat = 0
        for spec in specs {
            let button = NSButton(title: tr(spec.0), target: self, action: #selector(playbackControlClicked(_:)))
            button.frame = NSRect(x: cursorX, y: 1, width: spec.2, height: 26)
            button.bezelStyle = .rounded
            button.font = .systemFont(ofSize: 12)
            button.tag = Int(spec.1)
            button.isEnabled = enabled
            controls.addSubview(button)
            cursorX += spec.2 + 6
        }

        return advancedControlRow(title: "Controles de reproduccion", control: controls, width: width)
    }

    private func advancedButtonRow(
        title: String,
        buttonTitle: String,
        action: Selector,
        width: CGFloat,
        enabled: Bool
    ) -> NSView {
        let button = NSButton(title: tr(buttonTitle), target: self, action: action)
        button.frame = NSRect(x: 0, y: 0, width: 160, height: 26)
        button.bezelStyle = .rounded
        button.font = .systemFont(ofSize: 12)
        button.isEnabled = enabled
        return advancedControlRow(title: title, control: button, width: width)
    }

    private func advancedPairedDevicesView(width: CGFloat, enabled: Bool) -> NSView {
        let devices = pairedMDRDevices()
        if devices.isEmpty {
            return advancedNote("Sin datos MDR de dispositivos. Activa multipoint en ajustes generales si el modelo lo requiere.", width: width)
        }

        let rowHeight: CGFloat = 68
        let view = NSView(frame: NSRect(x: 0, y: 0, width: width, height: CGFloat(devices.count) * rowHeight))
        for (offset, device) in devices.enumerated() {
            let rowY = CGFloat(devices.count - offset - 1) * rowHeight
            let row = NSView(frame: NSRect(x: 0, y: rowY, width: width, height: rowHeight))

            let title = NSTextField(labelWithString: device.displayName)
            title.frame = NSRect(x: 0, y: 45, width: width, height: 16)
            title.font = .systemFont(ofSize: 13, weight: device.isActivePlaybackDevice ? .semibold : .regular)
            title.textColor = enabled ? .labelColor : .disabledControlTextColor
            row.addSubview(title)

            let statusParts = [
                device.isConnectedToHeadphones ? tr("Conectado a audifonos") : tr("Emparejado con audifonos"),
                device.isActivePlaybackDevice ? tr("Audio activo") : "",
                device.address
            ].filter { !$0.isEmpty }
            let detail = NSTextField(labelWithString: statusParts.joined(separator: " · "))
            detail.frame = NSRect(x: 0, y: 29, width: width, height: 14)
            detail.font = .systemFont(ofSize: 10)
            detail.textColor = enabled ? .secondaryLabelColor : .disabledControlTextColor
            row.addSubview(detail)

            var buttonX: CGFloat = 0
            func addButton(_ title: String, width buttonWidth: CGFloat, action: Selector, isEnabled: Bool = true) {
                let button = NSButton(title: tr(title), target: self, action: action)
                button.frame = NSRect(x: buttonX, y: 0, width: buttonWidth, height: 24)
                button.bezelStyle = .rounded
                button.font = .systemFont(ofSize: 11)
                button.identifier = NSUserInterfaceItemIdentifier(device.address)
                button.isEnabled = enabled && isEnabled
                row.addSubview(button)
                buttonX += buttonWidth + 6
            }

            if device.isConnectedToHeadphones {
                addButton("Activar como audio", width: 126, action: #selector(setMultipointDeviceClicked(_:)), isEnabled: !device.isActivePlaybackDevice)
                addButton("Desconectar", width: 104, action: #selector(disconnectPairedDeviceClicked(_:)))
            } else {
                addButton("Conectar", width: 88, action: #selector(connectPairedDeviceClicked(_:)))
            }
            addButton("Desemparejar", width: 104, action: #selector(unpairDeviceClicked(_:)))

            view.addSubview(row)
        }
        return view
    }

    private func advancedShortcutRow(definition: ShortcutDefinition, width: CGFloat, enabled: Bool) -> NSView {
        let rowWidth: CGFloat = 196
        let row = NSView(frame: NSRect(x: 0, y: 0, width: rowWidth, height: 28))

        let buttonTitle = shortcut(for: definition.id)?.displayString ?? (recordingShortcutID == definition.id ? tr("Pulsa atajo...") : tr("Sin asignar"))
        let recordButton = NSButton(title: buttonTitle, target: self, action: #selector(recordShortcutClicked(_:)))
        recordButton.frame = NSRect(x: 0, y: 1, width: 146, height: 26)
        recordButton.bezelStyle = .rounded
        recordButton.font = .systemFont(ofSize: 12)
        recordButton.isEnabled = enabled
        recordButton.identifier = NSUserInterfaceItemIdentifier(definition.id)
        row.addSubview(recordButton)

        let clearButton = NSButton(frame: NSRect(x: 154, y: 4, width: 22, height: 20))
        clearButton.isBordered = false
        clearButton.image = symbolImage("xmark.circle", pointSize: 12, weight: .regular) ?? symbolImage("xmark", pointSize: 12, weight: .regular)
        clearButton.imagePosition = .imageOnly
        clearButton.contentTintColor = .tertiaryLabelColor
        clearButton.toolTip = tr("Quitar atajo")
        clearButton.isEnabled = shortcut(for: definition.id) != nil && enabled
        clearButton.identifier = NSUserInterfaceItemIdentifier(definition.id)
        clearButton.target = self
        clearButton.action = #selector(clearShortcutClicked(_:))
        row.addSubview(clearButton)

        let wrapped = advancedControlRow(title: definition.title, control: row, width: width)
        let tint: NSColor = enabled ? .secondaryLabelColor : .disabledControlTextColor
        let icon = iconView(symbol: definition.symbol, accessory: definition.accessorySymbol, enabled: enabled)
        icon.frame = NSRect(x: max(0, advancedLabelWidth(for: width) - 28), y: (wrapped.frame.height - 20) / 2, width: 20, height: 20)
        for subview in icon.subviews {
            (subview as? NSImageView)?.contentTintColor = tint
        }
        wrapped.addSubview(icon)
        return wrapped
    }

    private func advancedQuickControlRow(definition: QuickControlDefinition, width: CGFloat, enabled: Bool) -> NSView {
        let checkbox = NSButton(checkboxWithTitle: "", target: self, action: #selector(quickControlPreferenceChanged(_:)))
        checkbox.frame = NSRect(x: 0, y: 0, width: 24, height: 22)
        checkbox.state = quickControlEnabled(definition.id) ? .on : .off
        checkbox.isEnabled = enabled
        checkbox.identifier = NSUserInterfaceItemIdentifier(definition.id)

        let row = advancedControlRow(title: definition.title, control: checkbox, width: width)
        let tint: NSColor = enabled ? .secondaryLabelColor : .disabledControlTextColor
        let icon = iconView(symbol: definition.symbol, accessory: definition.accessorySymbol, enabled: enabled)
        icon.frame = NSRect(x: max(0, advancedLabelWidth(for: width) - 28), y: (row.frame.height - 20) / 2, width: 20, height: 20)
        for subview in icon.subviews {
            (subview as? NSImageView)?.contentTintColor = tint
        }
        row.addSubview(icon)
        return row
    }

    private func advancedPopupRow(
        title: String,
        options: [PopupOption],
        current: Int,
        action: Selector,
        width: CGFloat,
        enabled: Bool
    ) -> NSView {
        let popup = NSPopUpButton(frame: NSRect(x: 0, y: 0, width: 260, height: 26), pullsDown: false)
        for option in options {
            popup.addItem(withTitle: tr(option.title))
            popup.item(at: popup.numberOfItems - 1)?.tag = option.value
        }
        if let selected = popup.itemArray.first(where: { $0.tag == current }) {
            popup.select(selected)
        } else {
            popup.addItem(withTitle: "\(tr("Valor")) \(current)")
            let fallback = popup.item(at: popup.numberOfItems - 1)
            fallback?.tag = current
            popup.select(fallback)
        }
        popup.target = self
        popup.action = action
        popup.isEnabled = enabled
        return advancedControlRow(title: title, control: popup, width: width)
    }

    private func ensureDefaultLaunchAtLogin() {
        guard UserDefaults.standard.object(forKey: launchAtLoginPreferenceKey) == nil else {
            return
        }
        UserDefaults.standard.set(true, forKey: launchAtLoginPreferenceKey)
        guard launchAtLoginAvailable() else {
            return
        }
        if #available(macOS 13.0, *) {
            do {
                if SMAppService.mainApp.status != .enabled {
                    try SMAppService.mainApp.register()
                }
            } catch {
                // Keep the UI preference enabled; macOS may reject login item registration
                // until the app is moved to Applications or launched normally.
            }
        }
    }

    private func launchAtLoginAvailable() -> Bool {
        if #available(macOS 13.0, *) {
            return true
        }
        return false
    }

    private func launchAtLoginEnabled() -> Bool {
        if #available(macOS 13.0, *) {
            return SMAppService.mainApp.status == .enabled
        }
        return false
    }

    private func setLaunchAtLogin(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: launchAtLoginPreferenceKey)
        guard launchAtLoginAvailable() else {
            showLaunchAtLoginError("Esta opcion requiere macOS 13 o superior.")
            return
        }

        if #available(macOS 13.0, *) {
            do {
                let service = SMAppService.mainApp
                if enabled {
                    if service.status != .enabled {
                        try service.register()
                    }
                } else if service.status == .enabled {
                    try service.unregister()
                }
            } catch {
                showLaunchAtLoginError("No se pudo cambiar el inicio con el sistema: \(error.localizedDescription)")
            }
        }

        rebuildAdvancedWindowContent()
    }

    private func showLaunchAtLoginError(_ message: String) {
        let alert = NSAlert()
        alert.messageText = tr("Inicio con el sistema")
        alert.informativeText = tr(message)
        alert.alertStyle = .warning
        alert.addButton(withTitle: tr("OK"))
        if let window = advancedWindow {
            alert.beginSheetModal(for: window)
        } else {
            alert.runModal()
        }
    }

    private func advancedCheckboxRow(
        title: String,
        checked: Bool,
        action: Selector,
        width: CGFloat,
        enabled: Bool,
        tag: Int = 0
    ) -> NSView {
        let checkbox = NSButton(checkboxWithTitle: "", target: self, action: action)
        checkbox.frame = NSRect(x: 0, y: 0, width: 24, height: 22)
        checkbox.state = checked ? .on : .off
        checkbox.isEnabled = enabled
        checkbox.tag = tag
        return advancedControlRow(title: title, control: checkbox, width: width)
    }

    private func advancedSliderRow(
        title: String,
        value: Int32,
        range: ClosedRange<Int>,
        tag: Int,
        action: Selector,
        width: CGFloat,
        enabled: Bool
    ) -> NSView {
        let labelWidth = advancedLabelWidth(for: width)
        let controlX = labelWidth + 14
        let localizedTitle = tr(title)
        let labelHeight = advancedLabelHeight(for: localizedTitle, width: labelWidth)
        let height = max(CGFloat(34), labelHeight + 12)
        let view = NSView(frame: NSRect(x: 0, y: 0, width: width, height: height))

        let label = advancedLabel(
            localizedTitle,
            frame: NSRect(x: 0, y: (height - labelHeight) / 2, width: labelWidth, height: labelHeight),
            enabled: enabled
        )
        view.addSubview(label)

        let helpButtonWidth: CGFloat = 20
        let trailingHelpX = width - helpButtonWidth

        let slider = NSSlider(value: Double(value), minValue: Double(range.lowerBound), maxValue: Double(range.upperBound), target: self, action: action)
        slider.frame = NSRect(x: controlX, y: (height - 24) / 2, width: max(120, width - controlX - 92), height: 24)
        slider.numberOfTickMarks = range.upperBound - range.lowerBound + 1
        slider.allowsTickMarkValuesOnly = true
        slider.isContinuous = false
        slider.tag = tag
        slider.isEnabled = enabled
        view.addSubview(slider)

        let valueLabel = NSTextField(labelWithString: "\(value)")
        valueLabel.identifier = NSUserInterfaceItemIdentifier("advancedSliderValueLabel")
        valueLabel.frame = NSRect(x: width - 72, y: (height - 18) / 2, width: 44, height: 18)
        valueLabel.alignment = .right
        valueLabel.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        valueLabel.textColor = enabled ? .secondaryLabelColor : .disabledControlTextColor
        view.addSubview(valueLabel)

        view.addSubview(advancedHelpButton(title: title, frame: NSRect(x: trailingHelpX, y: (height - 18) / 2, width: helpButtonWidth, height: 18)))

        return view
    }

    private func advancedControlRow(title: String, control: NSView, width: CGFloat) -> NSView {
        let labelWidth = advancedLabelWidth(for: width)
        let controlX = labelWidth + 14
        let localizedTitle = tr(title)
        let labelHeight = advancedLabelHeight(for: localizedTitle, width: labelWidth)
        let height = max(CGFloat(34), labelHeight + 12)
        let view = NSView(frame: NSRect(x: 0, y: 0, width: width, height: height))

        let enabled = (control as? NSControl)?.isEnabled ?? true
        let label = advancedLabel(
            localizedTitle,
            frame: NSRect(x: 0, y: (height - labelHeight) / 2, width: labelWidth, height: labelHeight),
            enabled: enabled
        )
        view.addSubview(label)

        let helpButtonWidth: CGFloat = 20
        control.frame.origin = NSPoint(x: controlX, y: (height - control.frame.height) / 2)
        if control.frame.maxX > width - helpButtonWidth - 10 {
            control.frame.size.width = max(80, width - controlX - helpButtonWidth - 12)
        }
        view.addSubview(control)
        view.addSubview(advancedHelpButton(title: title, frame: NSRect(x: width - helpButtonWidth, y: (height - 18) / 2, width: helpButtonWidth, height: 18)))

        return view
    }

    private func advancedHelpButton(title: String, frame: NSRect) -> NSButton {
        let button = NSButton(frame: frame)
        button.isBordered = false
        button.bezelStyle = .inline
        button.image = symbolImage("questionmark.circle", pointSize: 12, weight: .regular) ?? symbolImage("questionmark", pointSize: 12, weight: .regular)
        button.imagePosition = .imageOnly
        button.contentTintColor = .tertiaryLabelColor
        button.toolTip = tr("Que hace esta opcion")
        button.identifier = NSUserInterfaceItemIdentifier(title)
        button.target = self
        button.action = #selector(showAdvancedHelp(_:))
        return button
    }


    @objc private func toggleAdvancedDeviceList(_ sender: Any?) {
        advancedDeviceListExpanded.toggle()
        if advancedDeviceListExpanded {
            refreshDevices()
        }
        rebuildAdvancedWindowContent()
    }

    @objc private func advancedDeviceClicked(_ sender: NSButton) {
        guard sender.tag >= 0 && sender.tag < cachedDevices.count else {
            return
        }
        let device = cachedDevices[sender.tag]
        guard device.isConnectedToMac else {
            return
        }
        connect(device: device)
        rebuildAdvancedWindowContent()
    }

    @objc private func showAdvancedHelp(_ sender: NSButton) {
        let title = sender.identifier?.rawValue ?? ""
        let message = tr(advancedHelpText(for: title))

        let helpWidth: CGFloat = 316
        let horizontalPadding: CGFloat = 16
        let textWidth = helpWidth - (horizontalPadding * 2)
        let content = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: helpWidth, height: 1))
        content.material = .popover
        content.blendingMode = .behindWindow
        content.state = .active
        content.wantsLayer = true
        content.layer?.cornerRadius = 12

        let titleLabel = NSTextField(labelWithString: tr(title))
        titleLabel.frame = NSRect(x: horizontalPadding, y: 0, width: textWidth, height: 18)
        titleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textColor = .labelColor
        content.addSubview(titleLabel)

        let messageLabel = NSTextField(wrappingLabelWithString: message)
        messageLabel.font = .systemFont(ofSize: 12, weight: .regular)
        messageLabel.textColor = .secondaryLabelColor
        messageLabel.maximumNumberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        let messageHeight = advancedHelpHeight(for: message, width: textWidth)
        messageLabel.frame = NSRect(x: horizontalPadding, y: 12, width: textWidth, height: messageHeight)
        content.addSubview(messageLabel)

        let height = max(76, messageHeight + 46)
        content.frame.size = NSSize(width: helpWidth, height: height)
        titleLabel.frame.origin.y = height - 28
        messageLabel.frame.origin.y = 14

        activeAdvancedHelpPopover?.close()
        let popover = NSPopover()
        popover.behavior = .transient
        popover.animates = true
        popover.contentSize = content.frame.size
        let controller = NSViewController()
        controller.view = content
        popover.contentViewController = controller
        activeAdvancedHelpPopover = popover
        popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxX)
    }

    private func advancedHelpHeight(for text: String, width: CGFloat) -> CGFloat {
        let font = NSFont.systemFont(ofSize: 12, weight: .regular)
        let rect = NSAttributedString(string: text, attributes: [.font: font]).boundingRect(
            with: NSSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading]
        )
        return max(ceil(rect.height) + 8, 34)
    }

    private func advancedHelpText(for title: String) -> String {
        if let quick = Self.quickControlDefinitions.first(where: { $0.title == title }) {
            return quick.help
        }
        if let shortcut = Self.shortcutDefinitions.first(where: { $0.title == title }) {
            return shortcut.help
        }

        switch title {
        case "Preset":
            return "Cambia rapidamente la curva del ecualizador guardada en los auriculares."
        case "Clear Bass":
            return "Ajusta la intensidad de graves sin tocar el resto del ecualizador."
        case "Volumen":
            return "Controla el volumen interno que reportan los auriculares."
        case "Controles de reproduccion":
            return "Muestra y controla la metadata y reproduccion remota que reportan los auriculares."
        case "Prioridad":
            return "Elige si prefieres mejor calidad de audio o una conexion Bluetooth mas estable."
        case "DSEE / upscaling":
            return "Intenta mejorar audio comprimido reconstruyendo parte de las frecuencias perdidas."
        case "DSEE disponible":
            return "Indica si el motor DSEE esta disponible en el estado actual de los auriculares."
        case "Tipo DSEE":
            return "Muestra el tipo de escalado de audio que reporta el firmware."
        case "Modo escucha":
            return "Cambia el procesamiento de sonido espacial o ambiental disponible en el modelo."
        case "Espacio BGM":
            return "Ajusta el tamano virtual del espacio cuando usas el modo BGM."
        case "Sensibilidad auto ambiente":
            return "Cambia la sensibilidad del modo auto ambiente compatible con los modelos nuevos."
        case "Reconocimiento de conversacion":
            return "Detecta cuando hablas y reduce el audio para facilitar una conversacion."
        case "Sensibilidad":
            return "Define que tan facil se activa el reconocimiento de conversacion."
        case "Duracion":
            return "Tiempo que tarda en volver al audio normal despues de dejar de hablar."
        case "Pausar al retirar":
            return "Pausa la reproduccion cuando los auriculares detectan que te los quitaste."
        case "Gestos de cabeza":
            return "Activa gestos compatibles, como responder o rechazar con movimientos de cabeza."
        case "Idioma":
            return "Cambia el idioma de XMBar. El cambio se aplica inmediatamente a la interfaz. Si usas Sistema, XMBar usara el idioma de macOS; si no esta soportado, usara English."
        case "Lanzar XMBar con el sistema":
            return "Abre XMBar automaticamente al iniciar sesion en macOS."
        case "Ocultar XMBar al desconectar":
            return "Oculta el icono de la barra cuando no hay auriculares conectados. Al abrir XMBar desde Finder o Spotlight se mostrara Configuracion para no quedar inaccesible."
        case "Mostrar pildora emergente":
            return "Muestra la pildora discreta cuando los auriculares se conectan, cambia el modo de ruido desde el boton fisico o llegan a bateria baja."
        case "Guia de voz":
            return "Activa los avisos hablados de los auriculares para cambios de estado."
        case "Volumen guia":
            return "Ajusta el volumen de los avisos hablados de los auriculares."
        case "Apagado automatico":
            return "Configura cuando los auriculares se apagan solos para ahorrar bateria."
        case "Apagado por sensor":
            return "Usa el sensor de uso para decidir si deben apagarse automaticamente."
        case "Apagar audifonos":
            return "Apaga los auriculares usando el comando MDR POWER_OFF."
        case "Modo emparejamiento":
            return "Permite que los auriculares entren o salgan del modo de emparejamiento Bluetooth."
        case "Modo seguro":
            return "Activa o desactiva el modo seguro de escucha si el modelo lo soporta."
        case "Boton NC/AMB":
            return "Elige que hace el boton fisico de cancelacion de ruido y ambiente."
        case "Touch izquierdo":
            return "Asigna la funcion principal del panel tactil izquierdo, si tu modelo lo permite."
        case "Touch derecho":
            return "Asigna la funcion principal del panel tactil derecho, si tu modelo lo permite."
        default:
            if title.contains("Hz") || title.hasPrefix("Banda") {
                return "Ajusta esta banda del ecualizador. Valores positivos realzan esa frecuencia; negativos la reducen."
            }
            return "Controla esta funcion de los auriculares cuando el modelo conectado la soporta."
        }
    }

    private func advancedLabelWidth(for rowWidth: CGFloat) -> CGFloat {
        min(190, max(145, floor(rowWidth * 0.36)))
    }

    private func advancedLabelHeight(for text: String, width: CGFloat) -> CGFloat {
        let font = NSFont.systemFont(ofSize: 13)
        let rect = NSAttributedString(string: text, attributes: [.font: font]).boundingRect(
            with: NSSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading]
        )
        let lineHeight = ceil(font.ascender - font.descender + font.leading)
        return min(ceil(rect.height) + 2, lineHeight * 2 + 4)
    }

    private func advancedLabel(_ text: String, frame: NSRect, enabled: Bool) -> NSTextField {
        let label = NSTextField(wrappingLabelWithString: tr(text))
        label.frame = frame
        label.font = .systemFont(ofSize: 13)
        label.maximumNumberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = enabled ? .labelColor : .disabledControlTextColor
        return label
    }

    private func spacer(height: CGFloat) -> NSView {
        NSView(frame: NSRect(x: 0, y: 0, width: 1, height: height))
    }

    private func statusText() -> String {
        switch displayPhase() {
        case .idle:
            return "Conecta los WH-1000XM5 desde el menu para activar estos ajustes."
        case .connecting, .initializing, .syncing:
            return "La app esta preparando la conexion MDR. Los ajustes se activaran al terminar."
        case .committing:
            return "Los audifonos estan aplicando el ultimo cambio."
        case .error:
            return lastError()
        case .ready:
            return ""
        }
    }

    private func eqBandTitle(index: Int, count: Int) -> String {
        let fiveBand = ["400 Hz", "1 kHz", "2.5 kHz", "6.3 kHz", "16 kHz"]
        let tenBand = ["31 Hz", "63 Hz", "125 Hz", "250 Hz", "500 Hz", "1 kHz", "2 kHz", "4 kHz", "8 kHz", "16 kHz"]
        if count == 5 && index < fiveBand.count {
            return fiveBand[index]
        }
        if count == 10 && index < tenBand.count {
            return tenBand[index]
        }
        return "Banda \(index + 1)"
    }

    private func applyAdvancedSetting(
        refreshAdvanced: Bool = true,
        refreshPopover: Bool = false,
        _ setter: @escaping () -> Int32
    ) {
        let now = Date()
        let elapsed = now.timeIntervalSince(lastAdvancedSettingCommandAt)
        if elapsed < advancedSettingMinimumCommandSpacing {
            let delay = advancedSettingMinimumCommandSpacing - elapsed
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.applyAdvancedSetting(
                    refreshAdvanced: refreshAdvanced,
                    refreshPopover: refreshPopover,
                    setter
                )
            }
            return
        }

        lastAdvancedSettingCommandAt = Date()
        advancedSettingSyncStartedAt = Date()
        advancedSettingReconnectQuietUntil = Date().addingTimeInterval(advancedSettingReconnectQuietInterval)
        connectionAttemptStartedAt = nil
        connectionRetryScheduled = false

        _ = setter()
        updateCommitVisibility()
        updateStatusButton()

        if refreshAdvanced, advancedWindow?.isVisible == true {
            rebuildAdvancedWindowContent()
        }
        if refreshPopover, popover.isShown {
            refreshPopoverContent()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + advancedSettingSyncTimeout + 0.15) { [weak self] in
            guard let self, self.shouldTreatAdvancedSettingSyncAsReady() else {
                return
            }
            self.updateStatusButton()
            if refreshAdvanced, self.advancedWindow?.isVisible == true {
                self.rebuildAdvancedWindowContent()
            }
            if refreshPopover, self.popover.isShown {
                self.refreshPopoverContent()
            }
        }
    }

    private func updateSliderValueLabel(for slider: NSSlider, value: Int32) {
        guard let row = slider.superview else {
            return
        }
        for subview in row.subviews {
            guard let label = subview as? NSTextField,
                  label.identifier == NSUserInterfaceItemIdentifier("advancedSliderValueLabel") else {
                continue
            }
            label.stringValue = "\(value)"
            break
        }
    }

    private func schedulePlayVolumeUpdate(_ value: Int32, refreshAdvanced: Bool, refreshPopover: Bool) {
        pendingPlayVolumeValue = value
        playVolumeApplyTimer?.invalidate()

        let timer = Timer(timeInterval: volumeSliderDebounceInterval, repeats: false) { [weak self] _ in
            guard let self, let pendingValue = self.pendingPlayVolumeValue else {
                return
            }
            self.pendingPlayVolumeValue = nil
            self.playVolumeApplyTimer = nil
            self.applyAdvancedSetting(refreshAdvanced: refreshAdvanced, refreshPopover: refreshPopover) {
                mdrNativeSetPlayVolume(self.native, pendingValue)
            }
        }
        playVolumeApplyTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    private func scheduleVoiceGuidanceVolumeUpdate(_ value: Int32, refreshAdvanced: Bool, refreshPopover: Bool) {
        pendingVoiceGuidanceVolumeValue = value
        voiceGuidanceVolumeApplyTimer?.invalidate()

        let timer = Timer(timeInterval: volumeSliderDebounceInterval, repeats: false) { [weak self] _ in
            guard let self, let pendingValue = self.pendingVoiceGuidanceVolumeValue else {
                return
            }
            self.pendingVoiceGuidanceVolumeValue = nil
            self.voiceGuidanceVolumeApplyTimer = nil
            self.applyAdvancedSetting(refreshAdvanced: refreshAdvanced, refreshPopover: refreshPopover) {
                mdrNativeSetVoiceGuidanceVolume(self.native, pendingValue)
            }
        }
        voiceGuidanceVolumeApplyTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    private func shortcutDefaultsKey(_ id: String) -> String {
        "\(shortcutPrefix)\(id)"
    }

    private func shortcut(for id: String) -> KeyboardShortcut? {
        KeyboardShortcut.fromStorage(UserDefaults.standard.string(forKey: shortcutDefaultsKey(id)))
    }

    private func setShortcut(_ shortcut: KeyboardShortcut?, for id: String) {
        let key = shortcutDefaultsKey(id)
        if let shortcut {
            UserDefaults.standard.set(shortcut.storageString, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    private func shortcutSupported(_ id: String) -> Bool {
        switch id {
        case "openPanel", "openSettings", "volumeDown", "volumeUp":
            return true
        case "noiseCancelling", "ambient", "passive":
            return canUseControls()
        case "speakToChat":
            return mdrNativeSupportsSpeakToChat(self.native) != 0
        case "dsee":
            return mdrNativeSupportsUpscaling(self.native) != 0
        case "voiceGuidance":
            return mdrNativeSupportsVoiceGuidance(self.native) != 0
        case "voiceGuidanceVolumeDown", "voiceGuidanceVolumeUp":
            return mdrNativeSupportsVoiceGuidanceVolume(self.native) != 0
        default:
            return true
        }
    }

    private func installShortcutMonitors() {
        localShortcutMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self else { return event }
            return self.handleShortcutEvent(event) ? nil : event
        }
        globalShortcutMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            _ = self?.handleShortcutEvent(event)
        }
    }

    private func removeShortcutMonitors() {
        if let localShortcutMonitor {
            NSEvent.removeMonitor(localShortcutMonitor)
            self.localShortcutMonitor = nil
        }
        if let globalShortcutMonitor {
            NSEvent.removeMonitor(globalShortcutMonitor)
            self.globalShortcutMonitor = nil
        }
    }

    private func handleShortcutEvent(_ event: NSEvent) -> Bool {
        if let recordingID = recordingShortcutID {
            if event.keyCode == 53 {
                self.recordingShortcutID = nil
            } else if let shortcut = KeyboardShortcut.fromEvent(event) {
                setShortcut(shortcut, for: recordingID)
                self.recordingShortcutID = nil
            }
            if advancedWindow?.isVisible == true {
                updateVisibleShortcutButtons(for: recordingID)
            }
            return true
        }

        guard displayPhase() == .ready || Self.shortcutDefinitions.contains(where: { ($0.id == "openPanel" || $0.id == "openSettings") && shortcut(for: $0.id)?.matches(event) == true }) else {
            return false
        }

        for definition in Self.shortcutDefinitions where shortcutSupported(definition.id) {
            guard let shortcut = shortcut(for: definition.id), shortcut.matches(event) else {
                continue
            }
            performShortcut(definition.id)
            return true
        }
        return false
    }

    private func performShortcut(_ id: String) {
        switch id {
        case "openPanel":
            showPopover()
        case "openSettings":
            openAdvancedSettings(nil)
        case "noiseCancelling":
            setNoiseControl(mode: .noiseCancelling)
        case "ambient":
            setNoiseControl(mode: .ambient)
        case "passive":
            setNoiseControl(mode: .off)
        case "speakToChat":
            applyAdvancedSetting(refreshAdvanced: false, refreshPopover: true) {
                mdrNativeSetSpeakToChatEnabled(self.native, mdrNativeGetSpeakToChatEnabled(self.native) == 0 ? 1 : 0)
            }
        case "volumeDown":
            let value = max(0, mdrNativeGetPlayVolume(self.native) - 1)
            applyAdvancedSetting(refreshAdvanced: false, refreshPopover: true) {
                mdrNativeSetPlayVolume(self.native, value)
            }
        case "volumeUp":
            let value = min(30, mdrNativeGetPlayVolume(self.native) + 1)
            applyAdvancedSetting(refreshAdvanced: false, refreshPopover: true) {
                mdrNativeSetPlayVolume(self.native, value)
            }
        case "dsee":
            applyAdvancedSetting(refreshAdvanced: false, refreshPopover: true) {
                mdrNativeSetUpscalingEnabled(self.native, mdrNativeGetUpscalingEnabled(self.native) == 0 ? 1 : 0)
            }
        case "voiceGuidance":
            applyAdvancedSetting(refreshAdvanced: false, refreshPopover: true) {
                mdrNativeSetVoiceGuidanceEnabled(self.native, mdrNativeGetVoiceGuidanceEnabled(self.native) == 0 ? 1 : 0)
            }
        case "voiceGuidanceVolumeDown":
            let value = max(-2, mdrNativeGetVoiceGuidanceVolume(self.native) - 1)
            applyAdvancedSetting(refreshAdvanced: false, refreshPopover: true) {
                mdrNativeSetVoiceGuidanceVolume(self.native, value)
            }
        case "voiceGuidanceVolumeUp":
            let value = min(2, mdrNativeGetVoiceGuidanceVolume(self.native) + 1)
            applyAdvancedSetting(refreshAdvanced: false, refreshPopover: true) {
                mdrNativeSetVoiceGuidanceVolume(self.native, value)
            }
        default:
            break
        }
    }

    private func updateVisibleShortcutButtons(for id: String) {
        guard let window = advancedWindow else { return }
        let title = shortcut(for: id)?.displayString ?? (recordingShortcutID == id ? "Pulsa atajo..." : "Sin asignar")
        func visit(_ view: NSView) {
            if let button = view as? NSButton, button.identifier?.rawValue == id {
                if button.action == #selector(recordShortcutClicked(_:)) {
                    button.title = title
                } else if button.action == #selector(clearShortcutClicked(_:)) {
                    button.isEnabled = shortcut(for: id) != nil
                }
            }
            for subview in view.subviews { visit(subview) }
        }
        if let contentView = window.contentView { visit(contentView) }
    }

    private func shortcutsPermissionGranted() -> Bool {
        AXIsProcessTrusted()
    }

    private func requestShortcutsPermissionIfNeeded() {
        guard !shortcutsPermissionGranted() else { return }

        let alert = NSAlert()
        alert.messageText = "XMBar necesita permiso para atajos globales"
        alert.informativeText = "Para que los atajos funcionen fuera de XMBar, macOS debe permitir acceso de Accesibilidad/Monitoreo de entrada. Puedes grabar el atajo ahora, pero no funcionara globalmente hasta conceder el permiso."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Abrir Configuracion")
        alert.addButton(withTitle: "Continuar")

        if alert.runModal() == .alertFirstButtonReturn {
            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
            AXIsProcessTrustedWithOptions(options)
            openKeyboardPermissionSettings()
        }
    }

    private func openKeyboardPermissionSettings() {
        let urls = [
            "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility",
            "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension?Privacy_Accessibility",
            "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent"
        ]
        for raw in urls {
            if let url = URL(string: raw), NSWorkspace.shared.open(url) {
                return
            }
        }
    }

    @objc private func recordShortcutClicked(_ sender: NSButton) {
        guard let id = sender.identifier?.rawValue else { return }
        requestShortcutsPermissionIfNeeded()
        let previousRecordingID = recordingShortcutID
        recordingShortcutID = id
        if let previousRecordingID, previousRecordingID != id {
            updateVisibleShortcutButtons(for: previousRecordingID)
        }
        updateVisibleShortcutButtons(for: id)
    }

    @objc private func clearShortcutClicked(_ sender: NSButton) {
        guard let id = sender.identifier?.rawValue else { return }
        if recordingShortcutID == id {
            recordingShortcutID = nil
        }
        setShortcut(nil, for: id)
        updateVisibleShortcutButtons(for: id)
    }

    @objc private func quickControlPreferenceChanged(_ sender: NSButton) {
        guard let id = sender.identifier?.rawValue else {
            return
        }
        setQuickControl(id, enabled: sender.state == .on)
    }

    @objc private func quickUpscalingClicked(_ sender: NSButton) {
        let target = Int32(sender.tag == 0 ? 0 : 1)
        applyAdvancedSetting(refreshAdvanced: false, refreshPopover: true) {
            mdrNativeSetUpscalingEnabled(self.native, target)
        }
    }

    @objc private func quickVoiceGuidanceClicked(_ sender: NSButton) {
        let target = Int32(sender.tag == 0 ? 0 : 1)
        applyAdvancedSetting(refreshAdvanced: false, refreshPopover: true) {
            mdrNativeSetVoiceGuidanceEnabled(self.native, target)
        }
    }

    @objc private func deviceClicked(_ sender: NSButton) {
        guard sender.tag >= 0 && sender.tag < cachedDevices.count else {
            return
        }
        connect(device: cachedDevices[sender.tag])
    }

    @objc private func noiseModeClicked(_ sender: NSButton) {
        guard let mode = NoiseMode(rawValue: Int32(sender.tag)) else {
            return
        }
        setNoiseControl(mode: mode)
    }

    @objc private func speakToChatClicked(_ sender: NSButton) {
        applyAdvancedSetting(refreshAdvanced: false, refreshPopover: true) {
            mdrNativeSetSpeakToChatEnabled(self.native, sender.tag == 1 ? 1 : 0)
        }
    }

    @objc private func ambientSliderChanged(_ sender: NSSlider) {
        setNoiseControl(mode: .ambient, ambientLevel: Int32(sender.integerValue))
    }

    @objc private func toggleDeviceList(_ sender: Any?) {
        guard canShowDeviceListInPopover() else { return }
        deviceListExpanded.toggle()
        refreshPopoverContent()

        if deviceListExpanded {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                guard let self, self.popover.isShown, self.deviceListExpanded else {
                    return
                }
                let oldDevices = self.cachedDevices
                self.refreshDevices()
                if oldDevices != self.cachedDevices {
                    self.refreshPopoverContent()
                }
            }
        }
    }

    @objc private func languageChanged(_ sender: NSPopUpButton) {
        switch sender.selectedItem?.tag ?? 0 {
        case 1:
            setSelectedLanguageSetting(.spanish)
        case 2:
            setSelectedLanguageSetting(.english)
        default:
            setSelectedLanguageSetting(.system)
        }
    }

    @objc private func launchAtLoginChanged(_ sender: NSButton) {
        setLaunchAtLogin(sender.state == .on)
    }

    @objc private func hideWhenDisconnectedChanged(_ sender: NSButton) {
        setHideWhenDisconnected(sender.state == .on)
    }

    @objc private func notificationPillEnabledChanged(_ sender: NSButton) {
        setNotificationPillEnabled(sender.state == .on)
    }

    @objc private func openAdvancedSettings(_ sender: Any?) {
        let window = ensureAdvancedWindow()
        rebuildAdvancedWindowContent()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func eqPresetChanged(_ sender: NSPopUpButton) {
        applyAdvancedSetting {
            mdrNativeSetEqPreset(self.native, Int32(sender.selectedItem?.tag ?? 0))
        }
    }

    @objc private func eqClearBassChanged(_ sender: NSSlider) {
        applyAdvancedSetting {
            mdrNativeSetEqClearBass(self.native, Int32(sender.integerValue))
        }
    }

    @objc private func eqBandChanged(_ sender: NSSlider) {
        applyAdvancedSetting {
            mdrNativeSetEqBand(self.native, Int32(sender.tag), Int32(sender.integerValue))
        }
    }

    @objc private func playVolumeChanged(_ sender: NSSlider) {
        let value = Int32(sender.integerValue)
        updateSliderValueLabel(for: sender, value: value)
        let isQuickControl = sender.identifier?.rawValue == "quickPlayVolumeSlider"
        schedulePlayVolumeUpdate(value, refreshAdvanced: !isQuickControl, refreshPopover: isQuickControl)
    }

    @objc private func playbackControlClicked(_ sender: NSButton) {
        applyAdvancedSetting(refreshAdvanced: false, refreshPopover: true) {
            mdrNativeSetPlaybackControl(self.native, Int32(sender.tag))
        }
    }

    @objc private func audioPriorityChanged(_ sender: NSPopUpButton) {
        applyAdvancedSetting {
            mdrNativeSetAudioPriorityMode(self.native, Int32(sender.selectedItem?.tag ?? 0))
        }
    }

    @objc private func upscalingChanged(_ sender: NSButton) {
        applyAdvancedSetting {
            mdrNativeSetUpscalingEnabled(self.native, sender.state == .on ? 1 : 0)
        }
    }

    @objc private func listeningModeChanged(_ sender: NSPopUpButton) {
        applyAdvancedSetting {
            mdrNativeSetListeningMode(self.native, Int32(sender.selectedItem?.tag ?? 0))
        }
    }

    @objc private func bgmRoomSizeChanged(_ sender: NSPopUpButton) {
        applyAdvancedSetting {
            mdrNativeSetBgmRoomSize(self.native, Int32(sender.selectedItem?.tag ?? 1))
        }
    }

    @objc private func noiseAdaptiveSensitivityChanged(_ sender: NSPopUpButton) {
        applyAdvancedSetting {
            mdrNativeSetNoiseAdaptiveSensitivity(self.native, Int32(sender.selectedItem?.tag ?? 0))
        }
    }

    @objc private func advancedSpeakToChatChanged(_ sender: NSButton) {
        applyAdvancedSetting {
            mdrNativeSetSpeakToChatEnabled(self.native, sender.state == .on ? 1 : 0)
        }
    }

    @objc private func speakSensitivityChanged(_ sender: NSPopUpButton) {
        applyAdvancedSetting {
            mdrNativeSetSpeakToChatSensitivity(self.native, Int32(sender.selectedItem?.tag ?? 0))
        }
    }

    @objc private func speakDurationChanged(_ sender: NSPopUpButton) {
        applyAdvancedSetting {
            mdrNativeSetSpeakToChatModeOutTime(self.native, Int32(sender.selectedItem?.tag ?? 1))
        }
    }

    @objc private func autoPauseChanged(_ sender: NSButton) {
        applyAdvancedSetting {
            mdrNativeSetAutoPauseEnabled(self.native, sender.state == .on ? 1 : 0)
        }
    }

    @objc private func headGestureChanged(_ sender: NSButton) {
        applyAdvancedSetting {
            mdrNativeSetHeadGestureEnabled(self.native, sender.state == .on ? 1 : 0)
        }
    }

    @objc private func voiceGuidanceChanged(_ sender: NSButton) {
        applyAdvancedSetting {
            mdrNativeSetVoiceGuidanceEnabled(self.native, sender.state == .on ? 1 : 0)
        }
    }

    @objc private func voiceGuidanceVolumeChanged(_ sender: NSSlider) {
        let value = Int32(sender.integerValue)
        updateSliderValueLabel(for: sender, value: value)
        let isQuickControl = sender.identifier?.rawValue == "quickVoiceGuidanceVolumeSlider"
        scheduleVoiceGuidanceVolumeUpdate(value, refreshAdvanced: !isQuickControl, refreshPopover: isQuickControl)
    }

    @objc private func powerAutoOffChanged(_ sender: NSPopUpButton) {
        applyAdvancedSetting {
            mdrNativeSetPowerAutoOff(self.native, Int32(sender.selectedItem?.tag ?? 0x11))
        }
    }

    @objc private func powerAutoOffWearingChanged(_ sender: NSPopUpButton) {
        applyAdvancedSetting {
            mdrNativeSetPowerAutoOffWearingDetection(self.native, Int32(sender.selectedItem?.tag ?? 0x11))
        }
    }

    @objc private func ncAsmButtonChanged(_ sender: NSPopUpButton) {
        applyAdvancedSetting {
            mdrNativeSetNcAsmButtonFunction(self.native, Int32(sender.selectedItem?.tag ?? 0))
        }
    }

    @objc private func touchLeftChanged(_ sender: NSPopUpButton) {
        applyAdvancedSetting {
            mdrNativeSetTouchFunctionLeft(self.native, Int32(sender.selectedItem?.tag ?? 0xFF))
        }
    }

    @objc private func touchRightChanged(_ sender: NSPopUpButton) {
        applyAdvancedSetting {
            mdrNativeSetTouchFunctionRight(self.native, Int32(sender.selectedItem?.tag ?? 0xFF))
        }
    }

    @objc private func shutdownHeadphonesClicked(_ sender: NSButton) {
        applyAdvancedSetting(refreshAdvanced: true, refreshPopover: true) {
            mdrNativeSetShutdown(self.native)
        }
    }

    @objc private func pairingModeChanged(_ sender: NSButton) {
        applyAdvancedSetting {
            mdrNativeSetPairingMode(self.native, sender.state == .on ? 1 : 0)
        }
    }

    @objc private func generalSettingChanged(_ sender: NSButton) {
        applyAdvancedSetting {
            mdrNativeSetGeneralSetting(self.native, Int32(sender.tag), sender.state == .on ? 1 : 0)
        }
    }

    @objc private func safeListeningPreviewChanged(_ sender: NSButton) {
        applyAdvancedSetting {
            mdrNativeSetSafeListeningPreviewMode(self.native, sender.state == .on ? 1 : 0)
        }
    }

    @objc private func setMultipointDeviceClicked(_ sender: NSButton) {
        guard let address = sender.identifier?.rawValue else { return }
        applyAdvancedSetting {
            var result: Int32 = 0
            address.withCString { pointer in
                result = mdrNativeSetMultipointDeviceMac(self.native, pointer)
            }
            return result
        }
    }

    @objc private func connectPairedDeviceClicked(_ sender: NSButton) {
        guard let address = sender.identifier?.rawValue else { return }
        applyAdvancedSetting {
            var result: Int32 = 0
            address.withCString { pointer in
                result = mdrNativeConnectPairedDevice(self.native, pointer)
            }
            return result
        }
    }

    @objc private func disconnectPairedDeviceClicked(_ sender: NSButton) {
        guard let address = sender.identifier?.rawValue else { return }
        applyAdvancedSetting {
            var result: Int32 = 0
            address.withCString { pointer in
                result = mdrNativeDisconnectPairedDevice(self.native, pointer)
            }
            return result
        }
    }

    @objc private func unpairDeviceClicked(_ sender: NSButton) {
        guard let address = sender.identifier?.rawValue else { return }
        applyAdvancedSetting {
            var result: Int32 = 0
            address.withCString { pointer in
                result = mdrNativeUnpairDevice(self.native, pointer)
            }
            return result
        }
    }

    @objc private func openPanelFromEmergencyMenu(_ sender: Any?) {
        showPopover()
    }

    @objc private func openSoundSettings(_ sender: Any?) {
        if let url = URL(string: "x-apple.systempreferences:com.apple.Sound-Settings.extension") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func syncState(_ sender: Any?) {
        _ = mdrNativeRequestSync(self.native)
        refreshPopoverContent()
    }

    @objc private func disconnect(_ sender: Any?) {
        autoReconnectEnabled = false
        connectionAttemptStartedAt = nil
        connectionRetryCount = 0
        connectionRetryScheduled = false
        mdrNativeDisconnect(self.native)
        deviceListExpanded = true
        refreshPopoverContent()
    }

    @objc private func quit(_ sender: Any?) {
        NSApp.terminate(nil)
    }
}

private let app = NSApplication.shared
private let appDelegate = AppDelegate()
app.delegate = appDelegate
app.run()
