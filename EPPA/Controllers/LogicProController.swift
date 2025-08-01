import Cocoa
import ApplicationServices

class LogicProController: ObservableObject {
    @Published var isLogicRunning = false
    
    private var logicApp: NSRunningApplication?
    private var axLogic: AXUIElement?
    private var isSoloed = false
    
    init() {
        findLogicPro()
        setupNotifications()
    }
    
    private func findLogicPro() {
        let runningApps = NSWorkspace.shared.runningApplications
        logicApp = runningApps.first { $0.bundleIdentifier == "com.apple.logic10" }
        
        if let logicApp = logicApp {
            let pid = logicApp.processIdentifier
            axLogic = AXUIElementCreateApplication(pid)
            isLogicRunning = true
        }
    }
    
    private func setupNotifications() {
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(appDidLaunch),
            name: NSWorkspace.didLaunchApplicationNotification,
            object: nil
        )
    }
    
    @objc private func appDidLaunch(_ notification: Notification) {
        if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
           app.bundleIdentifier == "com.apple.logic10" {
            findLogicPro()
        }
    }
    
    // MARK: - Transport Controls
    
    func play() {
        sendKeyCommand(key: .space)
    }
    
    func stop() {
        sendKeyCommand(key: .space)
    }
    
    func solo() {
        if !isSoloed {
            sendKeyCommand(key: .s)
            isSoloed = true
        }
    }
    
    func unsolo() {
        if isSoloed {
            sendKeyCommand(key: .s)
            isSoloed = false
        }
    }
    
    // MARK: - Helper Methods
    
    private func sendKeyCommand(key: KeyCode, modifiers: NSEvent.ModifierFlags = []) {
        guard let logicApp = logicApp else { return }
        
        logicApp.activate(options: .activateIgnoringOtherApps)
        usleep(50000) // 50ms delay
        
        let keyDown = CGEvent(keyboardEventSource: nil, virtualKey: key.rawValue, keyDown: true)
        let keyUp = CGEvent(keyboardEventSource: nil, virtualKey: key.rawValue, keyDown: false)
        
        // Fix: Proper conversion from UInt to UInt64
        let flags = CGEventFlags(rawValue: UInt64(modifiers.rawValue))
        
        keyDown?.flags = flags
        keyUp?.flags = flags
        
        keyDown?.postToPid(logicApp.processIdentifier)
        keyUp?.postToPid(logicApp.processIdentifier)
    }
}

enum KeyCode: CGKeyCode {
    case space = 49
    case s = 1
    case `return` = 36
}
