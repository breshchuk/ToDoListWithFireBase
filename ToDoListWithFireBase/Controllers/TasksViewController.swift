//
//  TasksViewController.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 4.03.21.
//

import UIKit
import Firebase

class TasksViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Tasks"
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutButtonPressed(target:)))
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 23)]
        navigationItem.setLeftBarButton(signOutButton, animated: true)
    }
    

    @objc private func signOutButtonPressed(target: UIBarButtonItem) {
        DispatchQueue.global().async {
            do {
            try Auth.auth().signOut()
            } catch {
                print(error.localizedDescription)
            }
        }
        SceneDelegate.shared.rootViewController.showLoginAndSignUpScreen()
        
    }

}
