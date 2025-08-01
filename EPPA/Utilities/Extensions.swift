import Foundation
import SwiftUI

extension View {
    // Removed the problematic accessibilityFocusedIfNeeded function
    
    func conditionalModifier<T: View>(_ condition: Bool, _ modifier: (Self) -> T) -> some View {
        if condition {
            return AnyView(modifier(self))
        } else {
            return AnyView(self)
        }
    }
}

extension Double {
    func toPercentage() -> String {
        return "\(Int(self * 100))%"
    }
}

extension Float {
    func toDecibels() -> String {
        if self <= -60 {
            return "-∞ dB"
        } else {
            return String(format: "%.1f dB", self)
        }
    }
}
