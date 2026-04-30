//
//  KeepsakeStore.swift
//  Keepsake
//
//  Created by Rebecca Chou on 4/30/26.
//

import UIKit

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
                recipient: "Rebecca",
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
                recipient: "Rebecca",
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
                recipient: "Rebecca",
                caption: "The flowers look great today.",
                image: seedImage,
                deliveryDate: cal.date(byAdding: .day, value: -1, to: now)!,
                captureDate: "APR 19, 2026",
                captureTime: "11:30"
            ),
            
            // 4. Long-term vault - Locked (Arriving in 1 year)
            Keepsake(
                sender: "Avery",
                recipient: "Rebecca",
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
                recipient: "Rebecca",
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
