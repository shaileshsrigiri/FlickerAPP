//
//  FlickrAPIService.swift
//  FlickerAPP
//
//  Created by Shailesh Srigiri on 12/13/24.
//


protocol FlickrAPIService {
    func fetchImages(tags: String) async throws -> FlickrResponse
}