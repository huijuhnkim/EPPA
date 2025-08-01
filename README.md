# EPPA - Expression Pedal Playback Assistant

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS-blue">
  <img src="https://img.shields.io/badge/Swift-5.0-orange">
  <img src="https://img.shields.io/badge/Logic%20Pro-Compatible-green">
</p>

EPPA transforms an affordable expression pedal into an intuitive playback controller for Logic Pro, making audio production more accessible for visually impaired musicians and engineers. This project was inspired by [Dr. Abir Saha's research paper "Understanding Audio Production Practices of People with Vision Impairments"](https://doi.org/10.1145/3373625.3416993), which highlights the accessibility challenges and high costs faced by blind audio professionals.

## 🎯 Problem

EPPA addresses two critical challenges identified in accessibility research:

- **Cost Barrier**: Professional accessible control surfaces can cost upwards of $10,000
- **Complexity**: Existing assistive technologies have steep learning curves that create additional barriers

## 💡 Solution

EPPA uses a simple, intuitive control scheme inspired by driving:

- **80-100% (Gas)**: Full playback
- **20-80% (Coasting)**: Solo current track
- **0-20% (Brake)**: Stop playback

### Why Expression Pedals?

- **Affordable**: Quality pedals start at $30 (vs $10,000+ for control surfaces)
- **Intuitive**: Single-axis control mimics familiar gas pedal interaction
- **Accessible**: Hands-free operation leaves hands available for instruments or keyboard navigation
- **Universal**: Works with any standard expression pedal

## 🚀 Features

- Real-time MIDI device selection
- Visual pedal position indicator with accessibility labels
- Native Logic Pro integration via keyboard shortcuts
- Automatic solo state management
- Compatible with VoiceOver

## 🛠 Technical Stack

- **Language**: Swift 5
- **Framework**: SwiftUI
- **APIs**: CoreMIDI, Accessibility API
- **Platform**: macOS 11.0+
- **DAW**: Logic Pro

## 📋 Requirements

- macOS 11.0 or later
- Logic Pro
- Expression pedal (recommended: M-Audio EX-P, Roland EV-5, Yamaha FC7)
- MIDI interface or controller with expression input

## 🔧 Installation

1. Clone the repository
2. Open `EPPA.xcodeproj` in Xcode
3. Build and run (⌘R)
4. Grant accessibility permissions when prompted
5. Connect your expression pedal
6. Select your MIDI device in EPPA
7. Start controlling Logic Pro!

## 🎮 Usage

1. Launch EPPA and Logic Pro
2. Select your MIDI device from the dropdown
3. Use the expression pedal:
   - **Toe down (80-100%)**: Play
   - **Middle (20-80%)**: Solo current track
   - **Heel down (0-20%)**: Stop

## 🔮 Future Roadmap

- [ ] Customizable pedal zones and actions
- [ ] User profiles for different workflows
- [ ] Pro Tools support
- [ ] REAPER integration
- [ ] Ableton Live compatibility
- [ ] Windows version
- [ ] Advanced automation control
- [ ] Multi-pedal support

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## 📧 Contact

Huijuhn Kim - [your email]

Project Link: [https://github.com/huijuhnkim/eppa](https://github.com/huijuhnkim/eppa)