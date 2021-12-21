//
//  ImageViewExtension.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 14/12/2021.
//

import Kingfisher
import UIKit

extension UIImageView {
    
    func loadImage(withUrlStr urlStr : String? = "") {
        
        guard let urlString = urlStr,
        let url =  URL(string: urlString)
        else { return }
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
        ])
    }
}
