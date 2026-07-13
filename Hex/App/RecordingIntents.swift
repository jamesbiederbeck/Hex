import AppIntents
import HexCore

/// Exposes recording control to Shortcuts.app, Siri, and Spotlight.
///
/// This is a permission-free alternative entry point for triggering recording:
/// it does not use CGEventTap and requires no Accessibility or Input Monitoring
/// access. It complements (rather than replaces) the global hotkey system in
/// `KeyEventMonitorClient`, which is still needed for modifier-only hotkeys and
/// press-and-hold/double-tap timing that App Intents cannot express.
struct ToggleRecordingIntent: AppIntent {
  static var title: LocalizedStringResource = "Toggle Recording"
  static var description = IntentDescription("Starts or stops a Hex transcription recording.")
  static var openAppWhenRun: Bool = false

  @MainActor
  func perform() async throws -> some IntentResult {
    let store = HexApp.appStore
    if store.transcription.isRecording {
      await store.send(.transcription(.hotKeyReleased)).finish()
    } else {
      await store.send(.transcription(.hotKeyPressed)).finish()
    }
    return .result()
  }
}

struct HexShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: ToggleRecordingIntent(),
      phrases: [
        "Toggle recording in \(.applicationName)",
        "Start recording in \(.applicationName)"
      ],
      shortTitle: "Toggle Recording",
      systemImageName: "mic"
    )
  }
}
