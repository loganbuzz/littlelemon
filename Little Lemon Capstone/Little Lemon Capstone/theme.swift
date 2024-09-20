//
//  theme.swift
//  Little Lemon Capstone
//
//  Created by Logan Buzzard on 10/22/24.
//

import Foundation
import SwiftUI

struct BrandColors {
    static let primary1 = Color(hex: "#495E57") // Dark Green
    static let primary2 = Color(hex: "#F4CE14") // Yellow
    static let secondary1 = Color(hex: "#EE9972") // Peach
    static let secondary2 = Color(hex: "#FBDABB") // Light Peach
    static let highlight = Color(hex: "#EDEFEE") // Light Grey
    static let darkShade = Color(hex: "#333333") // Dark Grey
}

// Helper extension to support Hex colors
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

struct BrandFonts {
    static let display = Font.custom("MarkaziText-Medium", size: 64)
    static let subheading = Font.custom("MarkaziText-Regular", size: 40)
    static let body = Font.custom("Karla-Regular", size: 16)
    static let caption = Font.custom("Karla-Regular", size: 14)
    static let navbar = Font.custom("Karla-Bold", size: 20)
}
