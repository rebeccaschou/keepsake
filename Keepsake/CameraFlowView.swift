//
//  CameraFlowView.swift
//  Keepsake
//
//  Created by Rebecca Chou on 4/8/26.
//

import SwiftUI

struct CameraFlowView: View {
    @Binding var activeScreen: AppScreen
    @EnvironmentObject var store: KeepsakeStore
    @State private var currentStep = 0
    
    // Data
    @State private var selectedRecipient = "Alice"
    @State private var caption = ""
    @State private var deliveryDelay: Double = 24
    @State private var isSent = false
    
    @State private var includeLocation = false
    @State private var includeDate = false
    @State private var includeTime = false
    
    let capturedImage: UIImage?
    
    let figDarkBg = Color(red: 28/255, green: 28/255, blue: 28/255)
    let figLightText = Color(red: 211/255, green: 211/255, blue: 211/255)
    
    // Add this array to your CameraFlowView
    let timeSteps: [(label: String, value: String)] = [
        ("1 day", "Tomorrow"),
        ("3 days", "This week"),
        ("1 week", "Next week"),
        ("2 weeks", "Soon"),
        ("1 month", "Next month"),
        ("3 months", "Next season"),
        ("6 months", "Half a year"),
        ("1 year", "Next year"),
        ("5 years", "The future"),
        ("10 years", "A long time")
    ]
    
    @State private var stepIndex: Double = 0 // The slider will control this index
    
    var body: some View {
        ZStack {
            figDarkBg.ignoresSafeArea()
            
            // Background tap dismisses keyboard
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { hideKeyboard() }
            
            VStack(spacing: 0) {
                // --- TOP NAVIGATION BAR ---
                HStack(alignment: .center) {
                    Button(action: {
                        hideKeyboard()
                        if currentStep == 0 { withAnimation { activeScreen = .camera } }
                        else { withAnimation { currentStep -= 1 } }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundStyle(figLightText)
                            .padding(10)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        ForEach(0..<4) { i in
                            Capsule()
                                .fill(i <= currentStep ? figLightText : Color.white.opacity(0.1))
                                .frame(width: 35, height: 3)
                        }
                    }
                    
                    Spacer()
                    
                    if currentStep < 3 {
                        Button(action: {
                            hideKeyboard()
                            withAnimation { currentStep += 1 }
                        }) {
                            Image(systemName: "arrow.right")
                                .font(.title2)
                                .foregroundStyle(figLightText)
                                .padding(10)
                        }
                    } else {
                        Color.clear.frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                
                // --- MAIN CONTENT ---
                TabView(selection: $currentStep) {
                    // STEP 1: RECIPIENT
                    promptView(title: "Who is this keepsake for?") {
                        Picker("", selection: $selectedRecipient) {
                            ForEach(["Alice", "Bob", "Charlie", "Mom"], id: \.self) { name in
                                Text(name)
                                // This applies the serif font to the picker items
                                    .font(.custom("Palatino-Bold", size: 20))
                                    .foregroundStyle(figLightText)
                                    .tag(name)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 200)
                        // This modifier helps overcome some of the system default styling
                        .compositingGroup()
                    }
                    .tag(0)
                    
                    // STEP 2: CAPTION
                    promptView(title: "What would you like to say?") {
                        VStack(spacing: 12) {
                            ZStack(alignment: .topLeading) {
                                // Placeholder text
                                if caption.isEmpty {
                                    Text("Add your message here...")
                                        .font(.custom("Palatino", size: 18))
                                        .foregroundStyle(figLightText.opacity(0.3)) // Faded out
                                        .padding(.horizontal, 45) // Match TextEditor padding
                                        .padding(.top, 8)
                                }
                                
                                TextEditor(text: $caption)
                                    .scrollContentBackground(.hidden)
                                    .font(.custom("Palatino", size: 18))
                                    .lineSpacing(6)
                                    .foregroundStyle(figLightText)
                                    .padding(.horizontal, 40)
                                    .frame(height: 180)
                                    .onChange(of: caption) { newValue in
                                        if newValue.count > 300 {
                                            caption = String(newValue.prefix(300))
                                        }
                                    }
                            }
                            .overlay(
                                VStack {
                                    Spacer()
                                    Rectangle()
                                        .fill(figLightText.opacity(0.15))
                                        .frame(height: 1)
                                        .padding(.horizontal, 40)
                                }
                            )
                            
                            HStack {
                                Spacer()
                                Text("\(caption.count) / 300")
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundStyle(caption.count >= 300 ? .red : figLightText.opacity(0.4))
                            }
                            .padding(.horizontal, 50)
                        }
                    }
                    .tag(1)
                    
                    // STEP 3: METADATA
                    promptView(title: "What else should they know?") {
                        VStack(spacing: 12) {
                            metadataRow(icon: "map", label: "Location", isOn: $includeLocation)
                            metadataRow(icon: "calendar", label: "Date", isOn: $includeDate)
                            metadataRow(icon: "clock", label: "Time", isOn: $includeTime)
                        }
                        .padding(.horizontal, 60)
                    }
                    .tag(2)
                    
                    // STEP 4: TIME
                    promptView(title: "When should this arrive?") {
                        VStack(spacing: 60) { // More space for the slider to breathe
                            
                            // Time Display
                            VStack(spacing: 8) {
                                Text("In " + timeSteps[Int(stepIndex)].label)
                                    .font(.custom("Palatino-Bold", size: 32)) // Prominent time
                                    .foregroundStyle(figLightText)
                                
                                Text(timeSteps[Int(stepIndex)].value)
                                    .font(.system(size: 14, design: .monospaced))
                                    .foregroundStyle(figLightText.opacity(0.4))
                            }
                            .frame(height: 80)
                            
                            // The Custom Step Slider
                            Slider(value: $stepIndex, in: 0...Double(timeSteps.count - 1), step: 1)
                                .tint(figLightText)
                                .padding(.horizontal, 40)
                                .onChange(of: stepIndex) { _ in
                                    UISelectionFeedbackGenerator().selectionChanged()
                                }
                            
                            // Refined Send Button (Smaller & Elegant)
                            Button(action: send) {
                                Image(systemName: "paperplane")
                                    .font(.system(size: 20, weight: .regular)) // Smaller icon
                                    .foregroundStyle(figDarkBg)
                                    .frame(width: 64, height: 64) // Shrunk from 80 to 64
                                    .background(Circle().fill(figLightText))
                                    .shadow(color: figLightText.opacity(0.1), radius: 10)
                            }
                            .padding(.top, 20)
                        }
                    }
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            if isSent {
                ZStack {
                    figDarkBg.ignoresSafeArea()

                    VStack(spacing: 40) {
                        Spacer()

                        // 1. HERO PHOTO PREVIEW
                        if let uiImage = capturedImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 280, height: 400)
                                .clipShape(RoundedRectangle(cornerRadius: 2))
                                .shadow(color: .black.opacity(0.5), radius: 30, y: 15)
                                .transition(.scale(scale: 0.95).combined(with: .opacity))
                        } else {
                            // Fallback if no image was captured
                            Rectangle()
                                .fill(Color(white: 0.82))
                                .frame(width: 280, height: 400)
                        }

                        // 2. THE CAPTION (Refined)
                        if !caption.isEmpty {
                            Text(caption)
                                .font(.custom("Palatino", size: 18))
                                .italic()
                                .foregroundStyle(figLightText.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 50)
                                .lineLimit(2)
                        }

                        // 3. THE ARRIVAL MESSAGE
                        VStack(spacing: 20) {
                            Text("Your keepsake will arrive in \(timeSteps[Int(stepIndex)].label).")
                                .font(.system(size: 15, weight: .light, design: .serif))
                                .foregroundStyle(figLightText)

                            // The Progress Track (Width of photo: 280)
                            ZStack(alignment: .leading) {
                                // 1. The "Track" (Faded background line)
                                Rectangle()
                                    .fill(figLightText.opacity(0.1))
                                    .frame(width: 280, height: 1)
                                
                                // 2. The "Active" Growing Line
                                Rectangle()
                                    .fill(figLightText)
                                    .frame(width: 280, height: 1)
                                    .modifier(ProgressBarAnimation(endValue: 1.0))
                            }
                            .frame(width: 280)
                            .padding(.top, 10)
                        }
                        
                        Spacer()
                        Spacer()
                    }
                }
                .transition(.opacity.animation(.easeInOut(duration: 1.0)))
            }
        }
    }
    
    // Helper to keep the reflective prompt style perfectly aligned
    @ViewBuilder
    func promptView<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            // FIXED TOP SPACE: This ensures the title is always at the same height
            Text(title)
                .font(.custom("Palatino-Italic", size: 26))
                .foregroundStyle(figLightText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 80) // Exact distance from the nav bar
                .frame(height: 160) // Fixed height box for the title area
            
            // CONTENT: Input fields go here
            content()
            
            // SPACER: Pushes everything above it to the top
            Spacer()
        }
    }
    
    @ViewBuilder
    func metadataRow(icon: String, label: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 14)) // Smaller icon
                .frame(width: 20)
            
            // Label
            Text(label)
                .font(.system(size: 15, weight: .light, design: .serif)) // Smaller, lighter font
            
            Spacer()
            
            // Custom Sharper Checkbox
            ZStack {
                RoundedRectangle(cornerRadius: 2) // Less round, almost sharp corners
                    .stroke(figLightText.opacity(0.3), lineWidth: 1)
                    .frame(width: 18, height: 18) // Smaller checkbox
                
                if isOn.wrappedValue {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(figLightText)
                }
            }
        }
        .foregroundStyle(figLightText)
        .padding(.vertical, 4) // Tighter vertical padding
        .background(Color.black.opacity(0.001)) // Necessary to make the whole row tappable
        .onTapGesture {
            // Haptic feel without the visual gray-out
            UISelectionFeedbackGenerator().selectionChanged()
            withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                isOn.wrappedValue.toggle()
            }
        }
    }
    
    func send() {
        hideKeyboard()
        
        // 1. Calculate Delivery Date
        let calendar = Calendar.current
        let now = Date()
        var arrivalDate = now
        
        switch Int(stepIndex) {
        case 0: arrivalDate = calendar.date(byAdding: .day, value: 1, to: now)!
        case 1: arrivalDate = calendar.date(byAdding: .day, value: 3, to: now)!
        case 2: arrivalDate = calendar.date(byAdding: .weekOfYear, value: 1, to: now)!
        case 3: arrivalDate = calendar.date(byAdding: .weekOfYear, value: 2, to: now)!
        case 4: arrivalDate = calendar.date(byAdding: .month, value: 1, to: now)!
        case 5: arrivalDate = calendar.date(byAdding: .month, value: 3, to: now)!
        case 6: arrivalDate = calendar.date(byAdding: .month, value: 6, to: now)!
        case 7: arrivalDate = calendar.date(byAdding: .year, value: 1, to: now)!
        case 8: arrivalDate = calendar.date(byAdding: .year, value: 5, to: now)!
        case 9: arrivalDate = calendar.date(byAdding: .year, value: 10, to: now)!
        default: arrivalDate = calendar.date(byAdding: .day, value: 1, to: now)!
        }
        
        // 2. Prepare Formatted Metadata (matching your Model fields)
        let locValue = includeLocation ? "PROVIDENCE, RI" : nil
        
        var dateValue: String? = nil
        if includeDate {
            let df = DateFormatter()
            df.dateFormat = "MMM dd, yyyy" // e.g., APR 20, 2026
            dateValue = df.string(from: now).uppercased()
        }
        
        var timeValue: String? = nil
        if includeTime {
            let tf = DateFormatter()
            tf.dateFormat = "HH:mm" // e.g., 14:30
            timeValue = tf.string(from: now)
        }
        
        // 3. Create the Keepsake Object
        let newKeepsake = Keepsake(
            sender: "Rebecca",
            recipient: selectedRecipient, // Assumes 'recipient' is a @State variable in your view
            caption: caption,
            image: capturedImage, // Assumes 'capturedImage' is the UIImage from the camera
            deliveryDate: arrivalDate,
            location: locValue,
            captureDate: dateValue,
            captureTime: timeValue
        )
        
        // 4. Archive the new Keepsake in long-term storage
        StorageService.shared.saveKeepsakeToArchive(newKeepsake)
        
        // 5. Success Haptics & Transition
        let successImpact = UINotificationFeedbackGenerator()
        successImpact.notificationOccurred(.success)
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isSent = true
        }
        
        // 6. Reset & Return
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            withAnimation(.easeInOut(duration: 0.8)) {
                activeScreen = .camera
                isSent = false
                currentStep = 0
                caption = ""
                selectedRecipient = "" // Clear for next use
                // capturedImage = nil // Optional: clear the image buffer
            }
        }
    }
    
    struct ProgressBarAnimation: ViewModifier {
        @State private var width: CGFloat = 0
        var endValue: CGFloat

        func body(content: Content) -> some View {
            content
                .scaleEffect(x: width, y: 1, anchor: .leading)
                .onAppear {
                    // A 3-second linear draw to build anticipation
                    withAnimation(.linear(duration: 3.0)) {
                        width = endValue
                    }
                }
        }
    }
}

// 3. KEYBOARD DISMISSAL EXTENSION
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
