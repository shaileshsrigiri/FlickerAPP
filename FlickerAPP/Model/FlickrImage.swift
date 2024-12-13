//
//  FlickrImage.swift
//  FlickerAPP
//
//  Created by Shailesh Srigiri on 12/12/24.
//

import Foundation

struct FlickrImage: Decodable {
    let title: String
    let media: Media
    let author: String
    let description: String?

    struct Media: Decodable {
        let m: String
    }

    enum CodingKeys: String, CodingKey {
        case title
        case media
        case author
        case description = "description"
    }
    
    var cleanAuthor: String {
        return author.extractAuthorName().asPlainText()
    }
    
    var cleanDescription: String {
        return description?.asPlainText() ?? "No description available"
    }
}

struct FlickrResponse: Decodable {
    let items: [FlickrImage]
}




