//
//  MediaViewController.swift
//  Assignment
//
//  Created by Pramod Shukla on 11/05/24.
//

import UIKit

class MediaViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var mediaCoverages: [MediaCoverage] = []
    let mediaCoverageViewModel = MediaCoverageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchMediaCoverages()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func fetchMediaCoverages() {
        
        mediaCoverageViewModel.fetchMediaCoverages { [weak self] mediaCoverages in
            // Handle successful response and reload collection view
            self?.mediaCoverages = mediaCoverages
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
           
        } onError: { error in
            // Handle error
            DispatchQueue.main.async {
                let errorMessage = ErrorMessageService.errorMessage(for: error)
                AlertManager.showErrorAlert(title: "Error", withMessage: errorMessage)
            }
        }
        
    }
}

extension MediaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaCoverages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCoverageCell", for: indexPath) as! MediaCoverageCell
        let mediaCoverage = mediaCoverages[indexPath.item]
        cell.configure(with: mediaCoverage.thumbnail)
        return cell
    }
}

extension MediaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = (collectionViewWidth - 40) / 3 // Adjust spacing as needed
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust spacing as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust spacing as needed
    }
}

extension MediaViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView.superview)
        // If the velocity exceeds a certain threshold, cancel ongoing image loading requests
        if velocity.y > 500 || velocity.y < -500 {
             ImageLoader.shared.cancelAllRequests()
        }
    }
    
}
