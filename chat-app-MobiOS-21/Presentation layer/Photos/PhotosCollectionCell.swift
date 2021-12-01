//
//  PhotosCollectionCell.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 22.11.2021.
//

import UIKit

final class PhotosCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = "PhotosCollectionCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "noimage"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
        ])
    }
    
    func configureCell(with model: URL) {
        imageView.setImage(from: model)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = UIImage(named: "noimage")
    }
}
