import SwiftUI

struct SettingsView: View {
    @AppStorage("speechRate") private var speechRate: Double = 0.5
    @AppStorage("autoConnectMIDI") private var autoConnectMIDI: Bool = true
    @AppStorage("pedalCC") private var pedalCC: Int = 11  // Default to Expression CC
    
    var body: some View {
        VStack {
            Text("EPPA Settings")
                .font(.largeTitle)
                .padding()
            
            Form {
                Section("Speech") {
                    HStack {
                        Text("Speech Rate")
                        Slider(value: $speechRate, in: 0.1...1.0)
                            .accessibilityLabel("Speech rate")
                            .accessibilityValue("\(Int(speechRate * 100)) percent")
                    }
                }
                
                Section("MIDI") {
                    Toggle("Auto-connect to MIDI devices", isOn: $autoConnectMIDI)
                    
                    Picker("Expression Pedal CC", selection: $pedalCC) {
                        Text("CC 11 (Expression)").tag(11)
                        Text("CC 1 (Modulation)").tag(1)
                        Text("CC 7 (Volume)").tag(7)
                        Text("CC 64 (Sustain)").tag(64)
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("Huijuhn Kim")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
        .frame(width: 450, height: 400)
    }
}
