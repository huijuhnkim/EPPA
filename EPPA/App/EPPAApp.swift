import SwiftUI

@main
struct EPPAApp: App {
    @StateObject private var midiController = MIDIController()
    @StateObject private var logicController = LogicProController()
    @StateObject private var pedalManager = PedalStateManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(midiController)
                .environmentObject(logicController)
                .environmentObject(pedalManager)
                .onAppear {
                    setupControllers()
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
    
    private func setupControllers() {
        // Connect MIDI to pedal manager
        midiController.onPedalValueChange = { [weak pedalManager] value in
            pedalManager?.updatePedalPosition(value)
        }
        
        // Connect pedal manager to Logic controller
        pedalManager.onZoneChange = { [weak logicController] oldZone, newZone in
            switch newZone {
            case .playing:
                // Phase 1: Full playback (unsolo if needed and play)
                logicController?.unsolo()
                logicController?.play()
                
            case .soloing:
                // Phase 2: Solo the current track
                logicController?.solo()
                
            case .stopped:
                // Phase 3: Stop playback and unsolo
                logicController?.unsolo()
                logicController?.stop()
            }
        }
    }
}
