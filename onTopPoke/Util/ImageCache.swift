//
//  ImageCache.swift
//  onTopPoke
//
//  Created by Gabriel Patané Todaro on 31/01/25.
//

import SwiftUI

/// A singleton class responsible for caching images in memory using `NSCache`.
///
/// `ImageCache` helps avoid redundant network requests by storing previously downloaded images
/// in a cache, improving performance when displaying images repeatedly in a list.
///
/// ## Example Usage:
/// ```swift
/// if let cachedImage = ImageCache.shared.get(forKey: url) {
///     imageView.image = cachedImage
/// } else {
///     let downloadedImage = UIImage(data: data)
///     ImageCache.shared.set(downloadedImage, forKey: url)
/// }
/// ```
///
class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    
    func get(forKey url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    func set(_ image: UIImage, forKey url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
