import SwiftUI

struct ContentView: View {
    @EnvironmentObject var midiController: MIDIController
    @EnvironmentObject var logicController: LogicProController
    @EnvironmentObject var pedalManager: PedalStateManager
    
    var body: some View {
        VStack(spacing: 20) {
            // App Header
            VStack(spacing: 5) {
                Text("EPPA")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .accessibilityAddTraits(.isHeader)
                
                Text("Expression Pedal Playback Assistant")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top)
            
            // MIDI Device Selection
            GroupBox("MIDI Device") {
                VStack(alignment: .leading, spacing: 10) {
                    if midiController.availableDevices.isEmpty {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.orange)
                            Text("No MIDI devices found")
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Picker("Select Device", selection: $midiController.selectedDevice) {
                            Text("None").tag(nil as MIDIDevice?)
                            ForEach(midiController.availableDevices) { device in
                                Text(device.name).tag(device as MIDIDevice?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accessibilityLabel("MIDI Device selector")
                    }
                    
                    Button(action: {
                        midiController.refreshDevices()
                    }) {
                        Label("Refresh Devices", systemImage: "arrow.clockwise")
                            .font(.caption)
                    }
                    .buttonStyle(LinkButtonStyle())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            
            // Connection Status
            VStack(spacing: 12) {
                StatusIndicator(
                    isConnected: midiController.isConnected,
                    label: midiController.isConnected ?
                        "Connected to \(midiController.selectedDevice?.name ?? "Unknown")" :
                        "No Device Connected",
                    accessibilityLabel: midiController.isConnected ?
                        "Connected to \(midiController.selectedDevice?.name ?? "Unknown")" :
                        "No MIDI device connected"
                )
                
                StatusIndicator(
                    isConnected: logicController.isLogicRunning,
                    label: logicController.isLogicRunning ? "Logic Pro Connected" : "Logic Pro Not Running",
                    accessibilityLabel: logicController.isLogicRunning ?
                        "Logic Pro is running and connected" : "Logic Pro is not running"
                )
            }
            .padding(.horizontal)
            
            // Pedal position indicator
            VStack(spacing: 15) {
                Text("Pedal Position: \(Int(Double(midiController.currentPedalValue) / 127 * 100))%")
                    .font(.system(.title2, design: .rounded))
                    .monospacedDigit()
                    .accessibilityLabel("Pedal at \(Int(Double(midiController.currentPedalValue) / 127 * 100)) percent")
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 30)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(zoneColor)
                        .frame(width: CGFloat(midiController.currentPedalValue) / 127 * 300, height: 30)
                        .animation(.easeInOut(duration: 0.1), value: midiController.currentPedalValue)
                }
                .frame(width: 300)
                .accessibilityHidden(true)
                
                HStack(spacing: 40) {
                    VStack {
                        Image(systemName: "stop.fill")
                            .foregroundColor(pedalManager.currentZone == .stopped ? .red : .gray)
                        Text("Stop")
                            .font(.caption)
                    }
                    
                    VStack {
                        Image(systemName: "headphones")
                            .foregroundColor(pedalManager.currentZone == .soloing ? .orange : .gray)
                        Text("Solo")
                            .font(.caption)
                    }
                    
                    VStack {
                        Image(systemName: "play.fill")
                            .foregroundColor(pedalManager.currentZone == .playing ? .green : .gray)
                        Text("Play")
                            .font(.caption)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Current zone: \(pedalManager.currentZone.description)")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
            .padding(.horizontal)
            
            Spacer()
            
            // Bottom controls
            HStack {
                Button(action: {
                    // Open settings
                }) {
                    Label("Settings", systemImage: "gear")
                }
                .keyboardShortcut(",", modifiers: .command)
                
                Spacer()
                
                Text("EPPA v1.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .frame(width: 420, height: 550)
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private var zoneColor: Color {
        switch pedalManager.currentZone {
        case .stopped: return .red
        case .soloing: return .orange
        case .playing: return .green
        }
    }
}

struct StatusIndicator: View {
    let isConnected: Bool
    let label: String
    let accessibilityLabel: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(isConnected ? Color.green : Color.red)
                .frame(width: 12, height: 12)
            
            Text(label)
                .font(.system(.body, design: .rounded))
            
            Spacer()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .leading)
            
            Text(value)
                .fontWeight(.medium)
        }
        .font(.system(.body, design: .rounded))
    }
}
