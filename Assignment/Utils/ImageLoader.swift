//
//  ImageLoader.swift
//  Assignment
//
//  Created by Pramod Shukla on 12/05/24.
//

import Foundation
import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private let memoryCache = NSCache<NSString, UIImage>()
    private let diskCacheDirectory: URL
    
    init() {
        diskCacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("ImageCache")
        // Create disk cache directory if it doesn't exist
        try? FileManager.default.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    private func cachePath(for urlString: String) -> URL {
        let filename = urlString.replacingOccurrences(of: "/", with: "_")
        return diskCacheDirectory.appendingPathComponent(filename)
    }
    
    private func saveImageToDiskCache(_ image: UIImage, with urlString: String) {
        let cachePath = self.cachePath(for: urlString)
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: cachePath)
        }
    }
    
    private func loadImageFromDiskCache(with urlString: String) -> UIImage? {
        let cachePath = self.cachePath(for: urlString)
        guard let data = FileManager.default.contents(atPath: cachePath.path) else { return nil }
        return UIImage(data: data)
    }
    
    private var activeTasks = [URLSessionTask]()
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Check memory cache
        if let cachedImage = memoryCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        // Check disk cache
        if let cachedImage = loadImageFromDiskCache(with: urlString) {
            // Update memory cache
            memoryCache.setObject(cachedImage, forKey: urlString as NSString)
            completion(cachedImage)
            return
        }
        
        // Download the image
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        // Declare task here
        var task: URLSessionTask?
        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self, let task = task else { return }
            
           // Remove the task from activeTasks when it completes or is canceled
            defer { self.activeTasks.removeAll(where: { $0 == task }) }
            
            guard let data = data, let image = UIImage(data: data), error == nil else {
                completion(UIImage(named: "blank-image-icon"))
                return
            }
            
            // Cache the downloaded image
            self.memoryCache.setObject(image, forKey: urlString as NSString)
            self.saveImageToDiskCache(image, with: urlString)
            completion(image)
        }
        
        // Check if task is not nil and resume it
        if let task = task {
            task.resume()
            activeTasks.append(task)
        }
    }
    
    func cancelAllRequests() {
        activeTasks.forEach { $0.cancel() }
        activeTasks.removeAll()
    }
}


