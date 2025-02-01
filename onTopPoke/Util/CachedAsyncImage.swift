//
//  CachedAsyncImage.swift
//  onTopPoke
//
//  Created by Gabriel Patané Todaro on 31/01/25.
//

import SwiftUI

/// A SwiftUI view that asynchronously loads and caches an image from a URL.
///
/// `CachedAsyncImage` first checks if the image is available in the cache (`ImageCache`).
/// If the image is cached, it loads it immediately. Otherwise, it downloads the image,
/// caches it, and then displays it.
///
/// ## Example Usage:
/// ```swift
/// CachedAsyncImage(url: URL(string: "https://example.com/image.png")!)
///     .frame(width: 100, height: 100)
/// ```
///
/// This component ensures efficient image loading by reducing unnecessary network requests.
///
/// - Important: This component uses `NSCache` internally, meaning that cached images will be
/// removed if the system runs out of memory.
struct CachedAsyncImage: View {
    let url: URL
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .shadow(radius: 3)
            } else {
                ProgressView()
                    .frame(width: 60, height: 60)
                    .task {
                        await loadImage()
                    }
            }
        }
    }
    
    /// Loads an image from the cache or downloads it if necessary.
    ///
    /// - If the image is already cached, it is retrieved instantly.
    /// - If not, it fetches the image from the provided URL, caches it, and updates the state.
    @MainActor
    private func loadImage() async {
        if let cachedImage = ImageCache.shared.get(forKey: url) {
            image = cachedImage
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let loadedImage = UIImage(data: data) {
                ImageCache.shared.set(loadedImage, forKey: url)
                image = loadedImage
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }
}
