//
//  FlickrAPIError.swift
//  FlickerAPP
//
//  Created by Shailesh Srigiri on 12/13/24.
//


enum FlickrAPIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError
}