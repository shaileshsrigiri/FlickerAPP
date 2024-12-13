//
//  FlickrViewModel.swift
//  FlickerAPP
//
//  Created by Shailesh Srigiri on 12/12/24.
//


import Foundation

class FlickrViewModel {
    let apiService: FlickrAPIService

    var images: [FlickrImage] = []
    var errorMessage: String? = nil

    var onImagesUpdated: (() -> Void)?
    var onErrorOccurred: (() -> Void)?

    init(apiService: FlickrAPIService = FlickrAPIServiceImpl.shared) { 
        self.apiService = apiService
    }

    func searchImages(with tags: String) async {
        do {
            let response = try await apiService.fetchImages(tags: tags)
            self.images = response.items
            onImagesUpdated?()
        } catch {
            self.errorMessage = error.localizedDescription
            onErrorOccurred?()
        }
    }
}

