import Foundation
import CoreMIDI

struct TrackInfo {
    let name: String
    let faderLevel: Float  // in dB
    let auxSends: [String]
}

struct MIDIDevice: Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let source: MIDIEndpointRef
    
    static func == (lhs: MIDIDevice, rhs: MIDIDevice) -> Bool {
        lhs.id == rhs.id && lhs.source == rhs.source
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(source)
    }
}
