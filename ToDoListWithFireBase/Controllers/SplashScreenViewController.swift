//
//  SplashScreenViewController.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 4.03.21.
//

import UIKit

class SplashScreenViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = UIActivityIndicatorView(style: .large)
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.1)
    }
    
    func loadDataFromFirebase() {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)) {
           // SceneDelegate.shared.rootViewController
        }
    }
    

  

}
