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
                        // Inside HomeView ScrollView
                        HStack(alignment: .top, spacing: 18) {
                            // Left Column
                            LazyVStack(spacing: 18) {
                                ForEach(Array(store.messages.enumerated()), id: \.offset) { index, msg in
                                    if index % 2 == 0 { archiveTile(message: msg, index: index) }
                                }
                            }
                            
                            // Right Column (Staggered down)
                            LazyVStack(spacing: 18) {
                                ForEach(Array(store.messages.enumerated()), id: \.offset) { index, msg in
                                    if index % 2 != 0 { archiveTile(message: msg, index: index) }
                                }
                            }
                            .padding(.top, 40) // This creates the "Keepsake" offset look
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                    
                    // --- EXPORT BUTTON ROW ---
                    HStack {
                        Spacer()
                        Button(action: {
                            // This is where the export functionality would be implemented
                            // This would retrieve the universal format stored keepsakes and download to the user's device
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "square.and.arrow.up")
                                Text("Export All Keepsakes")
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                            }
                            .foregroundStyle(figLightText)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.08))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
            }
        }
    }
    
    @ViewBuilder
    func archiveTile(message: Keepsake, index: Int) -> some View {
        if message.isReady {
            // 1. CLICKABLE: Wrapped in NavigationLink
            NavigationLink(destination: DetailView(message: message)) {
                tileContent(message: message)
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            // 2. NOT CLICKABLE: Just the view, no link
            tileContent(message: message)
        }
    }
    
    @ViewBuilder
    func tileContent(message: Keepsake) -> some View {
        ZStack(alignment: .bottomLeading) {
            if let uiImage = message.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(0.7, contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .clipped()
            }
            
            if !message.isReady {
                Color.black.opacity(0.4)
                VStack(spacing: 6) {
                    Image(systemName: "lock.fill").font(.system(size: 14))
                    Text(message.deliveryDate, style: .date)
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                }
                .foregroundStyle(figLightText)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text(message.sender.uppercased())
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
                    .padding(12)
                    .shadow(radius: 2)
            }
        }
        .aspectRatio(0.7, contentMode: .fit)
        .frame(maxWidth: .infinity)
        .clipped()
    }
}
