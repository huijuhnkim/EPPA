import Foundation

enum PedalZone: CaseIterable {
    case stopped    // 0-20%
    case soloing    // 20-80%
    case playing    // 80-100%
    
    init(pedalValue: Int) {
        // MIDI values are 0-127
        switch pedalValue {
        case 0..<26:    // ~0-20%
            self = .stopped
        case 26..<102:  // ~20-80%
            self = .soloing
        default:        // 102-127 (~80-100%)
            self = .playing
        }
    }
    
    var description: String {
        switch self {
        case .stopped: return "Stopped"
        case .soloing: return "Solo"
        case .playing: return "Playing"
        }
    }
}
