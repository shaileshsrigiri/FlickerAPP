//
//  FlickrAPIServiceImpl.swift
//  FlickerAPP
//
//  Created by Shailesh Srigiri on 12/12/24.
//


import Foundation
import UIKit

class FlickrAPIServiceImpl: FlickrAPIService {
    static let shared = FlickrAPIServiceImpl()
    private let imageCache = NSCache<NSString, UIImage>()

    private init() {}

    func fetchImages(tags: String) async throws -> FlickrResponse {
        guard let url = FlickrAPIEndpoint.fetchImages(tags: tags).url else {
            throw FlickrAPIError.invalidURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(FlickrResponse.self, from: data)
            return response
        } catch let error as DecodingError {
            throw FlickrAPIError.decodingError
        } catch {
            throw FlickrAPIError.networkError(error)
        }
    }

    func fetchImage(from urlString: String) async -> UIImage? {
        
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            return cachedImage
        }

        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                // Cache the image for future use
                imageCache.setObject(image, forKey: NSString(string: urlString))
                return image
            }
        } catch {
            print("Failed to fetch image: \(error)")
        }
        return nil
    }
}

