//
//  ImageCell.swift
//  PhotoEditor
//
//  Created by Anna Zharkova on 19.05.2022.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let cellId = String(describing: ImageCell.self)

    @IBOutlet weak var photoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupOutputImage(image: UIImage) {
        self.photoImageView.image = image
    }
}
