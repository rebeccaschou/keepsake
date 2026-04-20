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
    let recipient: String
    let caption: String
    let imageName: String
    let deliveryDate: Date
    let metadata: [String]
    
    // ADD THIS PART:
    // This returns true if the current time is past the delivery date
    var isReady: Bool {
        Date() >= deliveryDate
    }
}

class KeepsakeStore: ObservableObject {
    @Published var messages: [Keepsake] = []
    
    // In KeepsakeStore.swift
    init() {
        let now = Date()
        let cal = Calendar.current
        
        self.messages = [
            Keepsake(recipient: "Alice", caption: "Sunrise.", imageName: "p1",
                     deliveryDate: cal.date(byAdding: .day, value: -2, to: now)!, metadata: []), // OPEN
            Keepsake(recipient: "Maya", caption: "Paris 2024.", imageName: "p3",
                     deliveryDate: cal.date(byAdding: .hour, value: -5, to: now)!, metadata: []), // OPEN
            Keepsake(recipient: "Luca", caption: "See you in a year.", imageName: "p4",
                     deliveryDate: cal.date(byAdding: .year, value: 1, to: now)!, metadata: []), // LOCKED
            Keepsake(recipient: "Mom", caption: "Garden update.", imageName: "p5",
                     deliveryDate: cal.date(byAdding: .day, value: -10, to: now)!, metadata: []), // OPEN
            Keepsake(recipient: "Self", caption: "Future thoughts.", imageName: "p2",
                     deliveryDate: cal.date(byAdding: .month, value: 3, to: now)!, metadata: []), // LOCKED
            Keepsake(recipient: "Self", caption: "Locked Archive.", imageName: "p6",
                     deliveryDate: cal.date(byAdding: .day, value: 5, to: now)!, metadata: [])   // LOCKED
        ]
    }
    
    // Computed property for the "Inbox" list if you still use it elsewhere
    var deliveredMessages: [Keepsake] {
        messages.filter { $0.isReady }
               .sorted(by: { $0.deliveryDate > $1.deliveryDate })
    }
}
