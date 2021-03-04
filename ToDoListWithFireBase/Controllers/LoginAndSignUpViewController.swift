//
//  LoginAndSignUpViewController.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 4.03.21.
//

import UIKit

class LoginAndSignUpViewController: UIViewController {

    var textLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        textLabel.frame = CGRect(x: 100, y: 200, width: 100, height: 23)
        textLabel.text = "Regist\nration"
        textLabel.numberOfLines = 5
        textLabel.lineBreakMode = .byWordWrapping
        view.addSubview(textLabel)
        
    }
    


}
