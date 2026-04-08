import SwiftUI

// MARK: - App Theme
struct Theme {
    // Backgrounds
    static let bg = Color(red: 0.027, green: 0.035, blue: 0.063)
    static let surface = Color(red: 0.063, green: 0.075, blue: 0.102)
    static let surface2 = Color(red: 0.086, green: 0.110, blue: 0.157)
    static let border = Color(red: 0.145, green: 0.176, blue: 0.239)
    
    // Text
    static let text = Color(red: 0.867, green: 0.878, blue: 0.914)
    static let dim = Color(red: 0.431, green: 0.478, blue: 0.569)
    
    // Accents
    static let gold = Color(red: 0.961, green: 0.718, blue: 0.192)
    static let blue = Color(red: 0.259, green: 0.647, blue: 0.961)
    static let green = Color(red: 0.290, green: 0.867, blue: 0.498)
    static let red = Color(red: 0.973, green: 0.443, blue: 0.443)
    
    // Status colors
    static func statusColor(_ status: PassStatus) -> Color {
        status == .open ? green : red
    }
}

// MARK: - Sorting
enum SortOption: String, CaseIterable {
    case earliestOpen = "Earliest open"
    case earliestClose = "Earliest close"
    case elevation = "Elevation"
    case name = "Name"
}

extension AlpinePass {
    func sortValue(for option: SortOption) -> Int {
        switch option {
        case .earliestOpen:
            return yearRound ? 1 : (history?.typOpenStart ?? 999)
        case .earliestClose:
            return yearRound ? 365 : (history?.typCloseStart ?? 0)
        case .elevation:
            return elevation
        case .name:
            return 0 // handled separately
        }
    }
}
