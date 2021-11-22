//
//  ImageView+extensions.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 22.11.2021.
//

import UIKit

extension UIImageView {
    func setImage(from url: URL) {
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
