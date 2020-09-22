//
//  MainViewController.swift
//  DeveloperTest
//
//  Created by Ines Ceh on 17/09/2020.
//  Copyright © 2020 Ines Ceh. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    var teachersViewConttoller: UIViewController = TeachersViewController()
    var studentsViewController: UIViewController = StudentsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.applicationBackgroundColor
        self.delegate = self
        
        createTabBar()
    }

        
    override func viewWillAppear(_ animated: Bool) {
        
        createNavigationController()
        self.viewControllers = [teachersViewConttoller, studentsViewController]
    }
    
    internal func createTabBar() {
        
        self.tabBar.barTintColor = UIColor.tabBarTintColor
        
        let textAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Medium", size: 10)!, NSAttributedString.Key.kern: -0.24] as [NSAttributedString.Key : Any]

        UITabBarItem.appearance().setTitleTextAttributes(textAttributes, for: .normal)
        let teachersTabBarItem = UITabBarItem()
        teachersTabBarItem.title = NSLocalizedString("main_teachers", comment: "")
        teachersTabBarItem.image = UIImage(named: "Teachers_unselected")
        teachersTabBarItem.selectedImage = UIImage(named: "Teachers_selected")
        teachersViewConttoller.tabBarItem = teachersTabBarItem
        
        let studentsTabBarItem = UITabBarItem()
        studentsTabBarItem.title = NSLocalizedString("main_students", comment: "")
        studentsTabBarItem.image = UIImage(named: "Students_unselected")
        studentsTabBarItem.selectedImage = UIImage(named: "Students_selected")
        studentsViewController.tabBarItem = studentsTabBarItem
        
    }
    
    internal func createNavigationController() {
        
        let textAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 34)!, NSAttributedString.Key.foregroundColor:UIColor.navigationTitleColor ?? UIColor.black, NSAttributedString.Key.kern: 0.37] as [NSAttributedString.Key : Any]
        self.navigationController?.navigationBar.largeTitleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        //self.navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = NSLocalizedString("main_teachers", comment: "")
        
    }
}

extension MainViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
        
        if selectedIndex == 0 {
            
            self.title = NSLocalizedString("main_teachers", comment: "")
        } else if selectedIndex == 1 {
             
            self.title = NSLocalizedString("main_students", comment: "")
         }
    }
}


