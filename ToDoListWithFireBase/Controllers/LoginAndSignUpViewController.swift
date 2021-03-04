//
//  LoginAndSignUpViewController.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 4.03.21.
//

import UIKit
import Firebase

class LoginAndSignUpViewController: UIViewController {

    var registrationLabel = UILabel()
    var emailTextField = UITextField()
    var passTextField = UITextField()
    var secondPassTextField = UITextField()
    var signInButton = UIButton()
    var loginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //MARK: - UI(Registration Label)
        registrationLabel.frame = CGRect(x: 10, y: 50, width: 300, height: 60)
        registrationLabel.text = "Registration"
        registrationLabel.font = UIFont.systemFont(ofSize: 50)
        registrationLabel.shadowOffset = .init(width: 2, height: 0)
        registrationLabel.shadowColor = .black
        
        //MARK: - UI(Text fields)
        emailTextField.frame = CGRect(x: 40, y: 300, width: view.frame.width - 80, height: 40)
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
        emailTextField.delegate = self
        
        passTextField.frame = CGRect(x: 40, y: 380, width: view.frame.width - 80, height: 40)
        passTextField.placeholder = "Password"
        passTextField.isSecureTextEntry = true
        passTextField.borderStyle = .roundedRect
        passTextField.autocapitalizationType = .none
        passTextField.autocorrectionType = .no
        passTextField.returnKeyType = .next
        passTextField.delegate = self
     
        
        secondPassTextField.frame = CGRect(x: 40, y: 460, width: view.frame.width - 80, height: 40)
        secondPassTextField.placeholder = "Repeat password"
        secondPassTextField.isSecureTextEntry = true
        secondPassTextField.borderStyle = .roundedRect
        secondPassTextField.autocapitalizationType = .none
        secondPassTextField.autocorrectionType = .no
        secondPassTextField.returnKeyType = .join
        secondPassTextField.delegate = self
        
        //MARK: - UI(Buttons)
        signInButton.frame = CGRect(x: 80, y: 540, width: view.frame.width - 160, height: 40)
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.backgroundColor = .blue
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonTapped(sender:)), for: .touchUpInside)
        
        
        
        //MARK: - Add subviews
        view.addSubview(registrationLabel)
        view.addSubview(emailTextField)
        view.addSubview(passTextField)
        view.addSubview(secondPassTextField)
        view.addSubview(signInButton)
    }
    
    @objc private func signInButtonTapped(sender: UIButton? = nil) {
        if let sender = sender {
            sender.pulsate()
        }
        if let email = emailTextField.text , let pass = passTextField.text ,let checkPass = secondPassTextField.text, pass != "" && email.contains("@") && pass == checkPass {
            Auth.auth().createUser(withEmail: email, password: pass) {  (authResult, error) in
                SceneDelegate.shared.rootViewController.showTasksScreen()
            }
        } else {
            
        }
    }
    


}

extension LoginAndSignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.passTextField.becomeFirstResponder()
            }
        case passTextField:
            passTextField.resignFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.secondPassTextField.becomeFirstResponder()
            }
        case secondPassTextField:
            signInButtonTapped()
        default:
            break
        }
        return true
    }
}
