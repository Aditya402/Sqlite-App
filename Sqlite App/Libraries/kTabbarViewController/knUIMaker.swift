//
//  UIMaker.swift
//  knCollection
//
//  Created by Mouritech on 06/03/20.
//  Copyright © 2020 Mouritech. All rights reserved.
//

import UIKit

var screenWidth: CGFloat { return UIScreen.main.bounds.width }

struct knUIMaker {
    static func makeLabel(text: String? = nil, font: UIFont = .systemFont(ofSize: 9),
                          color: UIColor = .black, numberOfLines: Int = 1,
                          alignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"proximanova-regular",size:9)
        label.textColor = color
        label.text = text
        label.numberOfLines = numberOfLines
        label.textAlignment = alignment
        return label
    }
    
    static func makeImageView(image: UIImage? = nil,
                              contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImageView {
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = contentMode
        iv.clipsToBounds = true
        return iv
    }
}

