//
//  TasksViewController.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 4.03.21.
//

import UIKit
import Firebase

class TasksViewController: UIViewController {
    
   private var user: LocalUser!
   private var tasks = [Tasks]()
   private var ref : DatabaseReference!

   private let tableView = UITableView()
   private let cellIdentifier = "myCell"
   private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        DispatchQueue.main.async { [weak self] in
            guard let currentUser = Auth.auth().currentUser else {return}
            self?.user = LocalUser(user: currentUser)
            self?.ref = Database.database().reference(withPath: "users").child((self?.user.id)!).child("tasks")
        }
        
        view.backgroundColor = .white
        title = "Tasks"
        
        //MARK: - Nav Controller Buttons
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutButtonPressed(target:)))
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 23)]
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed(target:)))
        navigationItem.setLeftBarButtonItems([signOutButton,saveButton], animated: true)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(target:)))
        navigationItem.setRightBarButton(addButton, animated: true)
        
        
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
            try Auth.auth().signOut()
            } catch {
                print(error.localizedDescription)
            }
        }
        SceneDelegate.shared.rootViewController.showLoginAndSignUpScreen()
        
    }

    @objc private func addButtonPressed(target: UIBarButtonItem) {
        UIView.animate(withDuration: 1) { [weak self] in
            self?.textView.frame = CGRect(x: 60, y: 100, width: (self?.view.frame.width)! - 40, height: (self?.view.frame.height)! - 100)
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
        } else if textView.isFirstResponder {
            textView.removeFromSuperview()
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
        
        cell.textLabel?.text = tasks[indexPath.row].title
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ref = Database.database().reference()
        let textView = UITextView()
        textView.frame = self.view.frame
        textView.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
        view.addSubview(textView)
        
    }
    
    
}

extension TasksViewController: UITextViewDelegate {
    
}
