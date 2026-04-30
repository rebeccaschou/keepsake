//
//  StorageService.swift
//  Keepsake
//
//  Created by Rebecca Chou on 4/20/26.
//

import UIKit

class StorageService {
    static let shared = StorageService()
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func loadAllKeepsakes() -> [Keepsake] {
        var loadedKeepsakes: [Keepsake] = []
        
        do {
            // 1. Get all folder names in the Documents Directory
            let folderURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            
            for folderURL in folderURLs {
                // 2. Read the metadata.txt
                let metaURL = folderURL.appendingPathComponent("metadata.txt")
                let metaContent = try String(contentsOf: metaURL)
                
                // 3. Read the photo.pdf and turn it back into a UIImage
                let imageURL = folderURL.appendingPathComponent("photo.pdf")
                let imageData = try Data(contentsOf: imageURL)
                let uiImage = UIImage(data: imageData) // Re-hydrating the PDF/Data
                
                // 4. Parse the text back into a Keepsake object
                // (You would write a small helper to pull "RECIPIENT", "CAPTION", etc. from the string)
                let keepsake = parseMetadata(metaContent, image: uiImage)
                loadedKeepsakes.append(keepsake)
            }
        } catch {
            print("Failed to load archive: \(error)")
        }
        
        return loadedKeepsakes
    }
    
    func saveKeepsakeToArchive(_ keepsake: Keepsake) {
        // 1. Create a unique folder for this memory
        let folderName = "Keepsake_\(keepsake.id.uuidString)"
        let folderURL = documentsDirectory.appendingPathComponent(folderName)
        
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            
            // 2. Save Image as PDF
            if let image = keepsake.image {
                let pdfData = convertToPDF(image: image)
                let imageURL = folderURL.appendingPathComponent("photo.pdf")
                try pdfData.write(to: imageURL)
            }
            
            // 3. Save Metadata as Plain Text (YAML style)
            let metadataString = """
            SENDER: \(keepsake.sender)
            RECIPIENT: \(keepsake.recipient)
            DATE: \(keepsake.captureDate ?? "Unknown")
            TIME: \(keepsake.captureTime ?? "Unknown")
            LOCATION: \(keepsake.location ?? "Unknown")
            CAPTION: \(keepsake.caption)
            DELIVERY_DATE: \(keepsake.deliveryDate)
            """
            
            let metaURL = folderURL.appendingPathComponent("metadata.txt")
            try metadataString.write(to: metaURL, atomically: true, encoding: .utf8)
            
            print("Successfully archived to: \(folderURL.path)")
            
        } catch {
            print("Archival failed: \(error)")
        }
    }
    
    private func parseMetadata(_ text: String, image: UIImage?) -> Keepsake {
        let lines = text.components(separatedBy: .newlines)
        var dict: [String: String] = [:]
        
        for line in lines {
            let parts = line.components(separatedBy: ": ")
            if parts.count >= 2 {
                let key = parts[0].trimmingCharacters(in: .whitespaces)
                let value = parts.dropFirst().joined(separator: ": ").trimmingCharacters(in: .whitespaces)
                dict[key] = value
            }
        }
        
        // Convert the string date back into a real Date object for the logic
        let df = ISO8601DateFormatter()
        let deliveryDate = df.date(from: dict["DELIVERY_DATE"] ?? "") ?? Date()

        return Keepsake(
            sender: dict["SENDER"] ?? "Unknown",
            recipient: dict["RECIPIENT"] ?? "Unknown",
            caption: dict["CAPTION"] ?? "",
            image: image,
            deliveryDate: deliveryDate,
            location: dict["LOCATION"] == "Unknown" ? nil : dict["LOCATION"],
            captureDate: dict["DATE"] == "Unknown" ? nil : dict["DATE"],
            captureTime: dict["TIME"] == "Unknown" ? nil : dict["TIME"]
        )
    }
    
    private func convertToPDF(image: UIImage) -> Data {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: image.size))
        return pdfRenderer.pdfData { context in
            context.beginPage()
            image.draw(in: CGRect(origin: .zero, size: image.size))
        }
    }
}
