//
//  FlickrViewController.swift
//  FlickerAPP
//
//  Created by Shailesh Srigiri on 12/12/24.
//

import UIKit

class FlickrViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    let searchBar = UISearchBar()
    var collectionView: UICollectionView!
    var viewModel = FlickrViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Flickr Images"
        navigationController?.navigationBar.prefersLargeTitles = true

        setupUI()
        setupBindings()

        Task {
            await viewModel.searchImages(with: "nature")
        }
    }

    func setupUI() {
        view.backgroundColor = .white

        searchBar.delegate = self
        searchBar.placeholder = "Search Flickr"
        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 175, height: 175)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FlickrCollectionViewCell.self, forCellWithReuseIdentifier: "FlickrCell")
        collectionView.backgroundColor = UIColor.systemGroupedBackground
        view.addSubview(collectionView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupBindings() {
        viewModel.onImagesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }

        viewModel.onErrorOccurred = { [weak self] in
            guard let errorMessage = self?.viewModel.errorMessage else { return }
            DispatchQueue.main.async {
                self?.showError(message: errorMessage)
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Task {
            let query = searchText.isEmpty ? "nature" : searchText
            await viewModel.searchImages(with: query)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrCell", for: indexPath) as? FlickrCollectionViewCell else {
            return UICollectionViewCell()
        }

        let image = viewModel.images[indexPath.item]
        cell.configure(with: image)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = viewModel.images[indexPath.item]
        let detailVC = FlickrDetailViewController(image: selectedImage)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
