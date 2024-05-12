//
//  MediaCovrageCell.swift
//  Assignment
//
//  Created by Pramod Shukla on 11/05/24.
//

import UIKit

class MediaCoverageCell: UICollectionViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with thumbnail: Thumbnail) {
        // Load image from URL and set it to the imageView
        let imageUrlString = thumbnail.domain + "/" + thumbnail.basePath + "/0/" + Key.imageJpg.rawValue
        ImageLoader.shared.loadImage(from: imageUrlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.thumbnailImageView.image = image
            }
        }
    }
}
