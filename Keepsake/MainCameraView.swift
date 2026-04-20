//
//  MainCameraView.swift
//  Keepsake
//
//  Created by Rebecca Chou on 4/8/26.
//

import SwiftUI

struct MainCameraView: View {
    @Binding var activeScreen: AppScreen
    @EnvironmentObject var store: KeepsakeStore
    @State private var flashOpacity: Double = 0.0
    
    let figDarkBg = Color(red: 28/255, green: 28/255, blue: 28/255)
    let figLightText = Color(red: 211/255, green: 211/255, blue: 211/255)

    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Spacer()
                Text("Keepsake")
                    .font(.custom("Palatino-Bold", size: 28))
                    .foregroundStyle(figLightText)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: { activeScreen = .home }) {
                    Image(systemName: "archivebox")
                        .font(.title2)
                        .foregroundStyle(figLightText)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
            .padding(.bottom, 15)
            .background(figDarkBg)

            // --- REFINED VIEWFINDER ---
            ZStack {
                Rectangle()
                    .fill(Color(white: 0.82))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.gray)
                    )

                // The localized shutter flash
                Color.white
                    .opacity(flashOpacity)
            }
            .clipped() // Ensures the flash doesn't bleed out of the viewfinder area

            // Bottom Bar
            VStack {
                Button(action: triggerCapture) {
                    ZStack {
                        Circle().stroke(figLightText, lineWidth: 6).frame(width: 80, height: 80)
                        Circle().fill(Color(white: 0.8)).frame(width: 68, height: 68)
                    }
                }
                .padding(.top, 40)
                Spacer()
            }
            .frame(height: 180)
            .frame(maxWidth: .infinity)
            .background(figDarkBg)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    func triggerCapture() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // 1. The Shutter "Click" (Fast in)
        withAnimation(.easeInOut(duration: 0.2)) {
            flashOpacity = 0.7
        }
        
        // 2. The "Hold"
        // We wait 0.2 seconds so the user actually sees the flash
        // before the screen begins to move.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            // 3. The "Release"
            // Now we fade the flash out and slide the screen simultaneously
            withAnimation(.easeInOut(duration: 0.6)) {
                flashOpacity = 0.0
                activeScreen = .compose
            }
        }
    }
}
