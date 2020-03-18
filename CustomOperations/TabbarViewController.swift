//
//  TabbarViewController.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-18.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {

    private lazy var controllers: [UINavigationController] = {
        return [
            configureController(DownloadsViewController(), title: "Downloads", image: UIImage(systemName: "square.and.arrow.down")),
            configureController(FinishedViewController(), title: "Finished", image: UIImage(systemName: "folder"))
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = controllers
        tabBar.barTintColor = UIColor.black
    }
    
    private func configureController(_ controller: UIViewController, title: String? = nil, image: UIImage? = nil) -> UINavigationController {
        let image = image?.withTintColor(.white)
        let selectedImage = image?.withTintColor(.gray)
        let tabbarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        controller.tabBarItem = tabbarItem
        return UINavigationController(rootViewController: controller)
    }
    
}
