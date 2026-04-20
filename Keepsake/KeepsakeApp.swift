//
//  KeepsakeApp.swift
//  Keepsake
//
//  Created by Rebecca Chou on 4/8/26.
//

import SwiftUI

@main
struct KeepsakeApp: App {
    @StateObject private var store = KeepsakeStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
