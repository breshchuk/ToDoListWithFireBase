//
//  ViewController.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 3.03.21.
//

import UIKit
import Firebase

class RootViewController: UIViewController {
    
    private var currentView: UIViewController
    
    init() {
        self.currentView = SplashScreenViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addChild(currentView)
        currentView.view.bounds = self.view.bounds
        currentView.didMove(toParent: self)
        view.addSubview(currentView.view)
    }

    
    func showLoginAndSignUpScreen() {
        let loginAndSignUpScreen = LoginAndSignUpViewController()
        animatedDissmissTransition(to: loginAndSignUpScreen)
    }
    
    func showTasksScreen() {
        let tabBarViewController = TabBarViewController()
//        let navController = UINavigationController(rootViewController: tabBarViewController)
        animatedFadeTransition(to: tabBarViewController)
    }
    
    private func animatedFadeTransition(to new: UIViewController, complition: (()->Void)? = nil) {
        currentView.willMove(toParent: nil)
        addChild(new)
        transition(from: currentView, to: new, duration: 0.3, options: [], animations: {
            
        }) { [weak self] completed in
            self?.currentView.removeFromParent()
            new.didMove(toParent: self)
            self?.currentView = new
            complition?()
        }

    }
    
    private func animatedDissmissTransition(to new: UIViewController, complition: (()->Void)? = nil) {
        currentView.willMove(toParent: nil)
        addChild(new)
        transition(from: currentView, to: new, duration: 0.3, options: [.curveEaseIn,.curveLinear],animations:  {
            new.view.frame = self.view.bounds
        }) { [weak self] completed in
            self?.currentView.removeFromParent()
            new.didMove(toParent: self)
            self?.currentView = new
            complition?()
        }
    
    }

}

