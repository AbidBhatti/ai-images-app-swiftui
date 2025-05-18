//
//  ImageCache.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 15/02/25.
//

import UIKit

actor ImageCache {
    static let shared = ImageCache()
    
    private var cache = NSCache<NSURL, UIImage>()
    private var urlReferences = Set<URL>()
    
    private init() {
        cache.countLimit = 100
    }
    
    func insert(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
        urlReferences.insert(url)
    }
    
    func get(_ url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func clear() {
        cache.removeAllObjects()
        urlReferences.removeAll()
    }
    
    func remove(urls: [URL]) {
        for url in urls {
            cache.removeObject(forKey: url as NSURL)
            urlReferences.remove(url)
        }
    }
    
    func removeAllExcept(urls: [URL]) {
        let urlsToKeep = Set(urls)
        let urlsToRemove = urlReferences.subtracting(urlsToKeep)
        
        for url in urlsToRemove {
            cache.removeObject(forKey: url as NSURL)
            urlReferences.remove(url)
        }
    }
}
