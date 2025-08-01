import CoreMIDI
import Combine

class MIDIController: ObservableObject {
    @Published var currentPedalValue: Int = 0
    @Published var isConnected = false
    @Published var availableDevices: [MIDIDevice] = []
    @Published var selectedDevice: MIDIDevice? {
        didSet {
            if let device = selectedDevice {
                connectToDevice(device)
            }
        }
    }
    
    var onPedalValueChange: ((Int) -> Void)?
    
    private var midiClient = MIDIClientRef()
    private var inputPort = MIDIPortRef()
    private let midiQueue = DispatchQueue(label: "com.huijuhnkim.eppa.midi")
    
    // Static reference to avoid deallocation issues
    private static var sharedInstance: MIDIController?
    
    init() {
        MIDIController.sharedInstance = self
        setupMIDI()
    }
    
    deinit {
        if MIDIController.sharedInstance === self {
            MIDIController.sharedInstance = nil
        }
        if inputPort != 0 {
            MIDIPortDispose(inputPort)
        }
        if midiClient != 0 {
            MIDIClientDispose(midiClient)
        }
    }
    
    private func setupMIDI() {
        // Create MIDI client
        var client = MIDIClientRef()
        let clientName = "EPPA MIDI Client" as CFString
        
        let status = MIDIClientCreate(clientName, nil, nil, &client)
        
        guard status == noErr else {
            print("EPPA: Failed to create MIDI client: \(status)")
            return
        }
        
        self.midiClient = client
        print("EPPA: MIDI client created successfully")
        
        // Create input port with block-based callback
        var port = MIDIPortRef()
        let portName = "EPPA Input Port" as CFString
        
        let portStatus = MIDIInputPortCreateWithBlock(midiClient, portName, &port) { [weak self] packetList, srcConnRefCon in
            self?.handlePacketList(packetList)
        }
        
        guard portStatus == noErr else {
            print("EPPA: Failed to create input port: \(portStatus)")
            return
        }
        
        self.inputPort = port
        print("EPPA: MIDI input port created successfully")
        
        // Scan for devices
        scanForDevices()
    }
    
    func scanForDevices() {
        var devices: [MIDIDevice] = []
        let sourceCount = MIDIGetNumberOfSources()
        
        print("EPPA: Found \(sourceCount) MIDI sources")
        
        for i in 0..<sourceCount {
            let source = MIDIGetSource(i)
            var name: Unmanaged<CFString>?
            MIDIObjectGetStringProperty(source, kMIDIPropertyName, &name)
            
            let deviceName = name?.takeRetainedValue() as String? ?? "Unknown Device \(i)"
            let device = MIDIDevice(id: i, name: deviceName, source: source)
            devices.append(device)
            
            print("EPPA: Found device: \(deviceName)")
        }
        
        DispatchQueue.main.async {
            self.availableDevices = devices
            
            // Auto-select MiniLab if found
            if let minilab = devices.first(where: {
                $0.name.lowercased().contains("minilab") ||
                $0.name.lowercased().contains("arturia")
            }) {
                self.selectedDevice = minilab
            }
        }
    }
    
    private func connectToDevice(_ device: MIDIDevice) {
        // Disconnect all sources first
        disconnectAll()
        
        // Connect to selected device
        let status = MIDIPortConnectSource(inputPort, device.source, nil)
        
        if status == noErr {
            print("EPPA: Successfully connected to \(device.name)")
            DispatchQueue.main.async {
                self.isConnected = true
            }
        } else {
            print("EPPA: Failed to connect to \(device.name), error: \(status)")
            DispatchQueue.main.async {
                self.isConnected = false
            }
        }
    }
    
    private func disconnectAll() {
        for device in availableDevices {
            MIDIPortDisconnectSource(inputPort, device.source)
        }
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }
    
    private func handlePacketList(_ packetList: UnsafePointer<MIDIPacketList>) {
        let packets = packetList.pointee
        var packet = packets.packet
        
        for _ in 0..<packets.numPackets {
            handleMIDIPacket(packet)
            packet = MIDIPacketNext(&packet).pointee
        }
    }
    
    private func handleMIDIPacket(_ packet: MIDIPacket) {
        // Extract bytes safely
        var bytes: [UInt8] = []
        let length = Int(packet.length)
        
        withUnsafeBytes(of: packet.data) { rawBytes in
            for i in 0..<min(length, 256) {
                bytes.append(rawBytes[i])
            }
        }
        
        // Debug: Print all MIDI messages
        if bytes.count >= 1 {
            let hexString = bytes.map { String(format: "%02X", $0) }.joined(separator: " ")
            print("EPPA: MIDI from \(selectedDevice?.name ?? "Unknown"): \(hexString)")
        }
        
        guard bytes.count >= 3 else { return }
        
        let statusByte = bytes[0]
        let data1 = bytes[1]
        let data2 = bytes[2]
        
        if statusByte & 0xF0 == 0xB0 {
            // Accept mod wheel (CC#1) or expression (CC#11)
            if data1 == 1 || data1 == 11 {
                DispatchQueue.main.async { [weak self] in
                    self?.currentPedalValue = Int(data2)
                    self?.onPedalValueChange?(Int(data2))
                }
            }
        }
    }
    
    func refreshDevices() {
        scanForDevices()
    }
}

