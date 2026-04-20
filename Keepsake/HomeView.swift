//
//  HomeView.swift
//  Keepsake
//
//  Created by Rebecca Chou on 4/8/26.
//

import SwiftUI

struct HomeView: View {
    @Binding var activeScreen: AppScreen
    @EnvironmentObject var store: KeepsakeStore
    
    let figDarkBg = Color(red: 28/255, green: 28/255, blue: 28/255)
    let figLightText = Color(red: 211/255, green: 211/255, blue: 211/255)

    var body: some View {
        NavigationStack {
            ZStack {
                figDarkBg.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // --- MIRRORED TOP BAR ---
                    // This matches MainCameraView exactly
                    HStack {
                        Spacer()
                        
                        Text("Keepsake")
                            .font(.custom("Palatino-Bold", size: 28))
                            .foregroundStyle(figLightText)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Button(action: { activeScreen = .camera }) {
                            Image(systemName: "camera") // Camera icon instead of archive
                                .font(.title2)
                                .foregroundStyle(figLightText)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)   // Matches Camera
                    .padding(.bottom, 15) // Matches Camera
                    .background(figDarkBg)

                    // --- THE GRID ---
                    ScrollView(showsIndicators: false) {
                        HStack(alignment: .top, spacing: 18) {
                            // Left Column: Even Indices (0, 2, 4...)
                            LazyVStack(spacing: 18) {
                                ForEach(Array(store.messages.enumerated()), id: \.offset) { index, msg in
                                    if index % 2 == 0 {
                                        archiveTile(message: msg, index: index)
                                    }
                                }
                            }
                            
                            // Right Column: Odd Indices (1, 3, 5...)
                            LazyVStack(spacing: 18) {
                                ForEach(Array(store.messages.enumerated()), id: \.offset) { index, msg in
                                    if index % 2 != 0 {
                                        archiveTile(message: msg, index: index)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func archiveTile(message: Keepsake, index: Int) -> some View {
        let heights: [CGFloat] = [320, 220, 280, 180]
        let tileHeight = heights[index % heights.count]
        
        // Using the real DetailView now
        NavigationLink(destination: DetailView(message: message)) {
            ZStack(alignment: .bottomLeading) {
                Rectangle() // Sharp edges to match the grid
                    .fill(Color(white: 0.82))
                    .frame(height: tileHeight)
                    .overlay(
                        // Show a lock if it's not ready to open yet
                        Group {
                            if !message.isReady {
                                Color.black.opacity(0.3)
                                VStack(spacing: 8) {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 16))
                                    Text(message.deliveryDate, style: .date)
                                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                                }
                                .foregroundStyle(figLightText.opacity(0.6))
                            }
                        }
                    )
                
                // Minimalist Label for ready messages
                if message.isReady {
                    Text(message.recipient.uppercased())
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundStyle(.black.opacity(0.6))
                        .padding(12)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        // Disable interaction if the message isn't ready yet
        .disabled(!message.isReady)
    }
}
