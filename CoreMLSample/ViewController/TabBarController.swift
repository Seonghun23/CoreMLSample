//
//  TabBarController.swift
//  CoreMLSample
//
//  Created by Seonghun Kim on 2022/01/06.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inAppViewController = ViewController(predictor: InAppModelImagePredictor())
        inAppViewController.view.backgroundColor = .red
        let inAppBarItem = UITabBarItem(
            title: "InApp",
            image: UIImage(systemName: "opticaldiscdrive"),
            selectedImage: UIImage(systemName: "opticaldiscdrive.fill")
        )
        inAppViewController.tabBarItem = inAppBarItem
        
        let downloadViewController = ViewController(predictor: DownloadModelWithVisionImagePredictor())
        downloadViewController.view.backgroundColor = .purple
        let downloadBarItem = UITabBarItem(
            title: "Download",
            image: UIImage(systemName: "cloud"),
            selectedImage: UIImage(systemName: "cloud.fill")
        )
        downloadViewController.tabBarItem = downloadBarItem
    
        setViewControllers([inAppViewController, downloadViewController], animated: false)
        tabBar.backgroundColor = .white
    }
}
