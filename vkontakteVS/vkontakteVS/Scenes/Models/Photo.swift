//
//  Photo.swift
//  vkontakteVS
//
//  Created by Home on 26.07.2021.
//

import UIKit

struct Photos {
    let photo: UIImage?
    
    static let photoArray = ["001","002","003","004","005","006","007","008","009","010"]
    
    static func getPhotos() -> [UIImage] {
        
        var photos = [UIImage]()
        for _ in (0...3) {
            let randomPhoto = photoArray.randomElement()!
            photos.append(UIImage(named: randomPhoto)!)
        }
        return photos
    }
}
