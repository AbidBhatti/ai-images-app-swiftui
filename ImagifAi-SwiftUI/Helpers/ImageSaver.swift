//
//  ImageSaver.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 15/02/25.
//

import Foundation
import Photos
import UIKit

actor ImageSaver {
    func saveImage(from urlString: String) async throws -> String {
        guard let url = URL(string: urlString) else {
            throw ImageSaverError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200,
              (httpResponse.mimeType?.contains("image") ?? false) else {
            throw ImageSaverError.invalidImageData
        }
        
        let fileName = "\(UUID().uuidString).jpg"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        try data.write(to: fileURL, options: .atomic)
        
        return fileName
    }
    
    func saveToPhotoLibrary(localPath: String) async throws {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(localPath)
        
        guard let imageData = try? Data(contentsOf: fileURL),
              let uiImage = UIImage(data: imageData) else {
            throw ImageSaverError.invalidImageData
        }
        
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .notDetermined:
            let granted = await PHPhotoLibrary.requestAuthorization(for: .addOnly) == .authorized
            if !granted {
                throw ImageSaverError.photoLibraryAccessDenied
            }
        case .restricted, .denied:
            throw ImageSaverError.photoLibraryAccessDenied
        case .authorized, .limited:
            break
        @unknown default:
            throw ImageSaverError.unknown
        }
        
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
        }
    }
    
    enum ImageSaverError: LocalizedError {
        case invalidURL
        case invalidImageData
        case compressionFailed
        case photoLibraryAccessDenied
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL provided"
            case .invalidImageData:
                return "Could not process image data"
            case .compressionFailed:
                return "Failed to compress image"
            case .photoLibraryAccessDenied:
                return "Photo library access denied"
            case .unknown:
                return "An unknown error occurred"
            }
        }
    }
}

