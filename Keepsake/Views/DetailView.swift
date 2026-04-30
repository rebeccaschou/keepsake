//
//  DetailView.swift
//  Keepsake
//
//  Created by Rebecca Chou on 4/8/26.
//

import SwiftUI

struct DetailView: View {
    let message: Keepsake
    @Environment(\.dismiss) var dismiss
    let figDarkBg = Color(red: 28/255, green: 28/255, blue: 28/255)
    let figLightText = Color(red: 211/255, green: 211/255, blue: 211/255)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Photo Area
                if let uiImage = message.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(0.7, contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .padding(.top, 50)
                }
                
                VStack(alignment: .leading, spacing: 30) {
                    // Caption
                    Text(message.caption)
                        .font(.custom("Palatino", size: 22))
                        .italic()
                        .foregroundStyle(figLightText)
                    
                    Divider().background(figLightText.opacity(0.2))
                    
                    // Metadata Grid
                    VStack(alignment: .leading, spacing: 15) {
                        // Row 1: Sent To (Left) & Location (Right)
                        HStack(alignment: .top) {
                            metadataBlock(label: "SENT FROM", value: message.sender, alignment: .leading)
                            
                            Spacer()
                            
                            if let loc = message.location {
                                metadataBlock(label: "LOCATION", value: loc, alignment: .trailing)
                            }
                        }
                        
                        // Row 2: Captured (Left) & Time (Right)
                        HStack(alignment: .top) {
                            if let date = message.captureDate {
                                metadataBlock(label: "CAPTURED", value: date, alignment: .leading)
                            }
                            
                            Spacer()
                            
                            if let time = message.captureTime {
                                metadataBlock(label: "TIME", value: time, alignment: .trailing)
                            }
                        }
                    }
                }
                .padding(30)
            }
        }
        .background(figDarkBg)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(figLightText)
                }
            }
        }
    }

    // Helper for consistent metadata styling
    @ViewBuilder
    func metadataBlock(label: String, value: String, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(figLightText.opacity(0.4))
            
            Text(value.uppercased())
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundStyle(figLightText)
                // Fix: Use .leading and .trailing here
                .multilineTextAlignment(alignment == .leading ? .leading : .trailing)
        }
    }
}
