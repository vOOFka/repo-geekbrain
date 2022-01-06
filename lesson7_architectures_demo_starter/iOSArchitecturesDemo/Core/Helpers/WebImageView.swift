//
//  WebImageView.swift
//  iOSArchitecturesDemo
//
//  Created by Home on 06.01.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

final class WebImageView: UIImageView {
    private let imageDownloader = ImageDownloader()
    
    func setImage(url: String?)  {
        guard let url = url else { return }
        self.imageDownloader.getImage(fromUrl: url) { (image, _) in
            self.image = image
        }
    }
}
