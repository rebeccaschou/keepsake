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
            VStack(alignment: .leading, spacing: 30) {
                // The Photo - Adjusted to be even more prominent
                Rectangle()
                    .fill(Color(white: 0.82))
                    .aspectRatio(contentMode: .fit) // Keeps original photo proportions
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20) // Breathing room from the top bar

                VStack(alignment: .leading, spacing: 20) {
                    Text(message.caption)
                        .font(.custom("Palatino", size: 22))
                        .italic()
                        .lineSpacing(6)
                        .foregroundStyle(figLightText)
                    
                    Divider().background(figLightText.opacity(0.2))
                    
                    HStack {
                        Text("FROM \(message.recipient.uppercased())")
                        Spacer()
                        Text(message.deliveryDate.formatted(date: .abbreviated, time: .omitted))
                    }
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundStyle(figLightText.opacity(0.5))
                }
                .padding(.horizontal, 25)
            }
        }
        .background(figDarkBg)
        .navigationBarBackButtonHidden(true) // Remove "Back" text
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    // Replicating your creation flow arrow icon
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(figLightText)
                        .padding(.vertical, 10)
                }
            }
        }
    }
}
