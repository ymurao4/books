//
//  MyTubBarController.swift
//  Books
//
//  Created by 村尾慶伸 on 2020/04/25.
//  Copyright © 2020 村尾慶伸. All rights reserved.
//

import UIKit

class MyTubBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
    

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("selected item")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("selected view controller")
    }

}
