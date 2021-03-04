//
//  ViewController.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 3.03.21.
//

import UIKit

class RootViewController: UIViewController {
    
    var currentView: UIViewController
    
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
        animatedFadeTransition(to: loginAndSignUpScreen)
    }
    
    private func animatedFadeTransition(to new: UIViewController, complition: (()->Void)? = nil) {
        currentView.willMove(toParent: nil)
        addChild(new)
        transition(from: currentView, to: new, duration: 0.3, options: .curveEaseIn) {
            self.currentView.removeFromParent()
            new.didMove(toParent: self)
            self.currentView = new
            complition?()
        }

    }

}

