//
//  ContentView.swift
//  Keepsake
//
//  Created by Rebecca Chou on 4/8/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var store = KeepsakeStore()
    @State private var activeScreen: AppScreen = .camera
    
    let figDarkBg = Color(red: 28/255, green: 28/255, blue: 28/255)

    var body: some View {
        ZStack {
            figDarkBg.ignoresSafeArea()
            
            Group {
                switch activeScreen {
                case .camera:
                    MainCameraView(activeScreen: $activeScreen)
                        .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading)))
                case .home:
                    HomeView(activeScreen: $activeScreen)
                        .transition(.opacity)
                case .compose:
                    CameraFlowView(activeScreen: $activeScreen)
                        .transition(.move(edge: .trailing))
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: activeScreen)
        .environmentObject(store)
        .preferredColorScheme(.dark)
    }
}
