//
//  ViewController.swift
//  CoffeNote
//
//  Created by Vatsal Chandel on 10/26/24.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .red
        print("TEST")
        
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())

        let vc2 = UINavigationController(rootViewController: NearMeViewController())
        
        let vc3 = UINavigationController(rootViewController: ProfileViewController())
        
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "cup.and.saucer")
        vc3.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        
        vc1.title = "Home"
        vc2.title = "Near Me"
        vc3.title = "Profile"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2, vc3], animated: true)
        
    }


}

