//
//  KeepsakeModel.swift
//  Keepsake
//
//  Created by Rebecca Chou on 4/8/26.
//

import SwiftUI

// The Data Model
struct Keepsake: Identifiable {
    let id = UUID()
    let sender: String
    let recipient: String
    let caption: String
    let image: UIImage?
    let deliveryDate: Date
    
    // Explicit Metadata fields
    var location: String?
    var captureDate: String? // e.g., "APR 08, 2026"
    var captureTime: String? // e.g., "14:22"
    
    var isReady: Bool {
        Date() >= deliveryDate
    }
}

extension UIImage {
    static func placeholder(size: CGSize = CGSize(width: 300, height: 400)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            // Fill with your viewfinder gray
            UIColor(white: 0.82, alpha: 1.0).setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
