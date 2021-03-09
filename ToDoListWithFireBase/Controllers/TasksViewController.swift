//
//  TasksViewController.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 4.03.21.
//

import UIKit
import Firebase

class TasksViewController: UIViewController {

   private let tableView = UITableView()
   private let cellIdentifier = "myCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Tasks"
        
        //MARK: - Nav Controller Buttons
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutButtonPressed(target:)))
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 23)]
        navigationItem.setLeftBarButton(signOutButton, animated: true)
        
        
        //MARK: - Table View
        tableView.frame = view.frame
        tableView.center = view.center
        tableView.delegate = self
        tableView.dataSource = self
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

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
