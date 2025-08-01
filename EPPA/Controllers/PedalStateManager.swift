import Combine

class PedalStateManager: ObservableObject {
    @Published private(set) var currentZone: PedalZone = .stopped
    private var previousZone: PedalZone = .stopped
    
    var onZoneChange: ((PedalZone, PedalZone) -> Void)?
    
    func updatePedalPosition(_ midiValue: Int) {
        let newZone = PedalZone(pedalValue: midiValue)
        
        if newZone != currentZone {
            previousZone = currentZone
            currentZone = newZone
            onZoneChange?(previousZone, newZone)
        }
    }
}
