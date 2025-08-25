//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2025 AppTrix AB. All rights reserved.
//
import SwiftUI
import SwiftIslandDataLogic

// Simple in-memory image cache
private actor ImageCache {
    static let shared = ImageCache()
    private var cache: [String: UIImage] = [:]
    private let maxCacheSize = 100 // Maximum number of images to keep in memory
    
    func get(_ key: String) -> UIImage? {
        return cache[key]
    }
    
    func set(_ image: UIImage, for key: String) {
        // Remove oldest images if cache is full
        if cache.count >= maxCacheSize {
            let oldestKey = cache.keys.first
            if let key = oldestKey {
                cache.removeValue(forKey: key)
            }
        }
        cache[key] = image
    }
    
    func clear() {
        cache.removeAll()
    }
    
    func getCacheSize() -> Int {
        return cache.count
    }
}

// Extension to provide cache management
extension RemoteImageView {
    /// Clear the in-memory image cache
    static func clearCache() async {
        await ImageCache.shared.clear()
    }
    
    /// Get the current size of the in-memory cache
    static func getCacheSize() async -> Int {
        return await ImageCache.shared.getCacheSize()
    }
}

struct RemoteImageView: View {
    let imagePath: String?
    let fallbackImageName: String
    
    @State private var uiImage: UIImage?
    @State private var isLoading = true
    @State private var hasFailed = false
    
    // Generate a cache key that includes the image path
    private var cacheKey: String {
        return imagePath ?? fallbackImageName
    }
    
    var body: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .transition(.opacity.animation(.easeInOut(duration: 0.2)))
            } else if isLoading {
                // Show fallback while loading
                Image(fallbackImageName)
                    .resizable()
                    .opacity(0.7)
                    .overlay(
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.secondary)
                    )
            } else if hasFailed {
                // Show fallback if loading failed
                Image(fallbackImageName)
                    .resizable()
                    .opacity(0.5)
            } else {
                // Initial state
                Image(fallbackImageName)
                    .resizable()
            }
        }
        .task {
            await loadImage()
        }
        .onAppear {
            // Reset states when view appears
            if uiImage == nil {
                isLoading = true
                hasFailed = false
            }
        }
    }
    
    private func loadImage() async {
        guard let imagePath = imagePath else {
            await MainActor.run {
                self.isLoading = false
                self.hasFailed = true
            }
            return
        }
        
        // Check memory cache first (fastest)
        if let cachedImage = await ImageCache.shared.get(cacheKey) {
            await MainActor.run {
                self.uiImage = cachedImage
                self.isLoading = false
                self.hasFailed = false
            }
            return
        }
        
        do {
            // Check if image is already cached locally on disk
            let localURL = DataSync.localImageURL(for: imagePath)
            if DataSync.hasLocalImage(for: imagePath) {
                // Load from local disk cache
                if let data = try? Data(contentsOf: localURL),
                   let image = UIImage(data: data) {
                    // Store in memory cache for faster future access
                    await ImageCache.shared.set(image, for: cacheKey)
                    await MainActor.run {
                        self.uiImage = image
                        self.isLoading = false
                        self.hasFailed = false
                    }
                    return
                }
            }
            
            // Download the image from network
            let imageData = try await DataSync.fetchImage(imagePath)
            if let image = UIImage(data: imageData) {
                // Store in both memory cache and disk cache
                await ImageCache.shared.set(image, for: cacheKey)
                await MainActor.run {
                    self.uiImage = image
                    self.isLoading = false
                    self.hasFailed = false
                }
            } else {
                await MainActor.run {
                    self.isLoading = false
                    self.hasFailed = true
                }
            }
        } catch {
            print("Failed to load image at \(imagePath): \(error)")
            await MainActor.run {
                self.isLoading = false
                self.hasFailed = true
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Remote Image View Demo")
            .font(.headline)
        
        RemoteImageView(
            imagePath: "https://example.com/test-image.jpg",
            fallbackImageName: "mentor-placeholder"
        )
        .frame(width: 200, height: 200)
        .clipped()
        
        Text("Fallback Image")
            .font(.caption)
        
        RemoteImageView(
            imagePath: nil,
            fallbackImageName: "mentor-placeholder"
        )
        .frame(width: 200, height: 200)
        .clipped()
    }
    .padding()
}
