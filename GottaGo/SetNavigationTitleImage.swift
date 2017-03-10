//
//  SetNavigationTitleImage.swift
//  GottaGo
//
//  Created by Hyung Jip Moon on 2017-03-09.
//  Copyright © 2017 Scott Hetland. All rights reserved.
//

import Foundation
import UIKit

@objc class SetNavigationTitleImage : NSObject {
    
    func setImage(_ navigationController: UINavigationController, withNavItem navItem: UINavigationItem) {
        let image = UIImage(named: "cresent")
        let logoView = UIImageView(image: image)
        logoView.image = image
        let targetHeight: CGFloat = navigationController.navigationBar.frame.size.height
        logoView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(0), height: CGFloat(targetHeight))
        logoView.contentMode = .scaleAspectFit
        navItem.titleView = logoView
    }
}

