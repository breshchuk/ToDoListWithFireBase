//
//  SplashScreenViewController.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 4.03.21.
//

import UIKit
import Firebase

class SplashScreenViewController: UIViewController {

    private let activityIndicator =  UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        activityIndicator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        view.addSubview(activityIndicator)
        loadData()
    }
    
    func loadData() {
        activityIndicator.startAnimating()

          if let provider = UserDefaults.standard.value(forKey: "provider") as? Provider,
             provider == .withoutProvider {
              SceneDelegate.shared.rootViewController.showTasksScreen()
          }
        
        if Auth.auth().currentUser != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) { [weak self] in
                self?.activityIndicator.stopAnimating()
                SceneDelegate.shared.rootViewController.showTasksScreen()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) { [weak self] in
                self?.activityIndicator.stopAnimating()
                SceneDelegate.shared.rootViewController.showLoginAndSignUpScreen()
            }
        }
    }
    

  

}
