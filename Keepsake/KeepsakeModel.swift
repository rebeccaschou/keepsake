//
//  KeepsakeModel.swift
//  Keepsake
//
//  Created by Rebecca Chou on 4/8/26.
//

import SwiftUI

// The Navigation States
enum AppScreen {
    case camera
    case home
    case compose
}

// The Data Model
struct Keepsake: Identifiable {
    let id = UUID()
    let sender: String
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

class KeepsakeStore: ObservableObject {
    @Published var messages: [Keepsake] = []
    
    init() {
        let seedImage = UIImage.placeholder()
        let now = Date()
        let cal = Calendar.current
        
        self.messages = [
            // 1. Fully populated - Opened
            Keepsake(
                sender: "Alice",
                caption: "Testing the flow.",
                image: seedImage,
                deliveryDate: now,
                location: "PROVIDENCE, RI",
                captureDate: "APR 08, 2026",
                captureTime: "14:22"
            ),
            
            // 2. Minimal metadata - Locked (Arriving in 3 days)
            Keepsake(
                sender: "Jordan",
                caption: "A secret for later.",
                image: seedImage,
                deliveryDate: cal.date(byAdding: .day, value: 3, to: now)!,
                location: "THE STUDIO",
                captureDate: "APR 15, 2026",
                captureTime: "09:00"
            ),
            
            // 3. No location - Opened (Arrived yesterday)
            Keepsake(
                sender: "Mom",
                caption: "The flowers look great today.",
                image: seedImage,
                deliveryDate: cal.date(byAdding: .day, value: -1, to: now)!,
                captureDate: "APR 19, 2026",
                captureTime: "11:30"
            ),
            
            // 4. Long-term vault - Locked (Arriving in 1 year)
            Keepsake(
                sender: "Self",
                caption: "Note to self: You did it.",
                image: seedImage,
                deliveryDate: cal.date(byAdding: .year, value: 1, to: now)!,
                location: "NYC",
                captureDate: "JAN 01, 2026",
                captureTime: "00:01"
            ),
            
            // 5. Short-term - Opened (Arrived 2 hours ago)
            Keepsake(
                sender: "Maya",
                caption: "Coffee's on me next time.",
                image: seedImage,
                deliveryDate: cal.date(byAdding: .hour, value: -2, to: now)!,
                location: "BOLT COFFEE",
                captureDate: "APR 20, 2026",
                captureTime: "08:15"
            )
        ]
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
