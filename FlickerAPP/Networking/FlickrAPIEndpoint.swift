//
//  FlickrAPIEndpoint.swift
//  FlickerAPP
//
//  Created by Shailesh Srigiri on 12/13/24.
//


import Foundation

enum FlickrAPIEndpoint {
    case fetchImages(tags: String)

    var url: URL? {
        switch self {
        case .fetchImages(let tags):
            let tagsEncoded = tags.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlString = "\(API.baseURL)?format=json&nojsoncallback=1&tags=\(tagsEncoded)"
            return URL(string: urlString)
        }
    }
}
