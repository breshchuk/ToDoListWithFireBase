//
//  TasksViewController.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 4.03.21.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class TasksViewController: UIViewController {
    
   private var user: LocalUser!
   private var tasks = [Tasks]()
   private var ref : DatabaseReference!

   private let tableView = UITableView()
   private let cellIdentifier = "myCell"
   private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        DispatchQueue.global().async(flags: .barrier) { [weak self] in
            guard let currentUser = Auth.auth().currentUser else {return}
            self?.user = LocalUser(user: currentUser)
            self?.ref = Database.database().reference(withPath: "users").child((self?.user.id)!).child("tasks")
        }
        
        view.backgroundColor = .white
        title = "Tasks"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 23)]
        
        
        //MARK: - Nav Controller Buttons
        configureNavigationItemButtons(true)
       
        //MARK: - Table View
        tableView.frame = view.frame
        tableView.center = view.center
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.observe(.value) { [weak self] (snapshot) in
            var _tasks = [Tasks]()
            for item in snapshot.children {
                let task = Tasks(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            self?.tasks = _tasks
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
    }
    

    @objc private func signOutButtonPressed(target: UIBarButtonItem) {
        DispatchQueue.global().async {
            do {
            LoginManager().logOut()
            GIDSignIn.sharedInstance()?.signOut()
            try Auth.auth().signOut()
            } catch {
                print(error.localizedDescription)
            }
        }
        SceneDelegate.shared.rootViewController.showLoginAndSignUpScreen()
        
    }
    
    private func configureNavigationItemButtons(_ whichButtons: Bool) {
        if whichButtons {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
                [weak self] in
                let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(self?.signOutButtonPressed(target:)))
                self?.navigationItem.setLeftBarButton(signOutButton, animated: true)
                let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self?.addButtonPressed(target:)))
                self?.navigationItem.setRightBarButton(addButton, animated: true)
            }
        } else {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
                [weak self] in
                let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self?.saveButtonPressed(target:)))
                self?.navigationItem.setRightBarButton(saveButton, animated: true)
                let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self?.cancelButtonPressed(target:)))
                self?.navigationItem.setLeftBarButton(cancelButton, animated: true)
            }
        }
    }

    @objc private func addButtonPressed(target: UIBarButtonItem) {
        configureNavigationItemButtons(false)
        UIView.animate(withDuration: 1) { [weak self] in
            self?.textView.frame = CGRect(x: 30, y: 100, width: (self?.view.frame.width)! - 60, height: (self?.view.frame.height)! - 150)
            self?.textView.font = UIFont.systemFont(ofSize: 18)
            self?.textView.backgroundColor = .yellow
            self?.textView.keyboardType = .default
            self?.textView.isEditable = true
            self?.textView.isScrollEnabled = true
            self?.textView.delegate = self
            self?.view.addSubview(self!.textView)
        }
        
    }
    
    @objc private func saveButtonPressed(target: UIBarButtonItem) {
        if textView.isFirstResponder && textView.text != "", let title = textView.text {
            let task = Tasks(userID: user.id, title: title)
            let taskRef = self.ref.child(task.title.lowercased())
            taskRef.setValue(task.convertToDict())
            textView.removeFromSuperview()
            textView.text = ""
        } else {
            textView.removeFromSuperview()
            textView.text = ""
        }
        configureNavigationItemButtons(true)
    }
    
    @objc private func cancelButtonPressed(target: UIBarButtonItem) {
        configureNavigationItemButtons(true)
        UIView.animate(withDuration: 1) { [weak self] in
            self?.textView.removeFromSuperview()
            self?.textView.text = ""
        }
    }
}


extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for: indexPath)
        
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        toggle(cell, IsCompleted: task.completed)
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let IsCompleted = !task.completed
        task.ref?.updateChildValues(["completed": IsCompleted])
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        toggle(cell, IsCompleted: IsCompleted)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
        }
    }
    
    func toggle(_ cell: UITableViewCell,IsCompleted: Bool) {
        cell.accessoryType = IsCompleted ? .checkmark : .none
    }
    
    
}

extension TasksViewController: UITextViewDelegate {
    
}
