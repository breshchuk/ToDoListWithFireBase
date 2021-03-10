//
//  LoginAndSignUpViewController.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 4.03.21.
//

import UIKit
import Firebase

class LoginAndSignUpViewController: UIViewController {
    
    private var ref: DatabaseReference!
    private var haveAccountButton = UIButton()
    private var registrationLabel = UILabel()
    private var emailTextField = UITextField()
    private var passTextField = UITextField()
    private var secondPassTextField = UITextField()
    private var registerButton = UIButton()
    private var loginButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        ref = Database.database().reference().child("users")
        
        //MARK: - UI(Labels)
        registrationLabel.frame = CGRect(x: 10, y: 50, width: 300, height: 60)
        registrationLabel.text = "Registration"
        registrationLabel.font = UIFont.systemFont(ofSize: 50)
        registrationLabel.shadowOffset = .init(width: 2, height: 0)
        registrationLabel.shadowColor = .black
        
        
        //MARK: - UI(Text fields)
        emailTextField.frame = CGRect(x: 40, y: 300, width: view.frame.width - 80, height: 40)
        configureEmailTextField(textField: emailTextField)
        
        passTextField.frame = CGRect(x: 40, y: 380, width: view.frame.width - 80, height: 40)
        configurePassTextField(textField: passTextField)
     
        
        secondPassTextField.frame = CGRect(x: 40, y: 460, width: view.frame.width - 80, height: 40)
        secondPassTextField.placeholder = "Repeat password"
        secondPassTextField.isSecureTextEntry = true
        secondPassTextField.borderStyle = .roundedRect
        secondPassTextField.autocapitalizationType = .none
        secondPassTextField.autocorrectionType = .no
        secondPassTextField.returnKeyType = .done
        secondPassTextField.delegate = self
        
        //MARK: - UI(Buttons)
        registerButton.frame = CGRect(x: 80, y: 540, width: view.frame.width - 160, height: 40)
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .blue
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.addTarget(self, action: #selector(registerButtonTapped(sender:)), for: .touchUpInside)
        
        haveAccountButton.frame = CGRect(x: 40, y: 160, width: 300, height: 23)
        haveAccountButton.setTitle("Already have account?", for: .normal)
        haveAccountButton.setTitleColor(.systemBlue, for: .normal)
        haveAccountButton.addTarget(self, action: #selector(haveAccountButtonTapped(sender:)), for: .touchUpInside)
        
        
        
        //MARK: - Add subviews
        view.addSubview(registrationLabel)
        view.addSubview(emailTextField)
        view.addSubview(passTextField)
        view.addSubview(secondPassTextField)
        view.addSubview(registerButton)
        view.addSubview(haveAccountButton)
        
        //MARK: - NSNotifications
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShowAction(notification:)), name: UITextField.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHideAction(notification:)), name: UITextField.keyboardWillHideNotification, object: nil)
        
        //MARK: Tap Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func configureEmailTextField(textField: UITextField) {
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.delegate = self
    }
    
    func configurePassTextField(textField: UITextField) {
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        textField.delegate = self
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc private func dismissKeyboard() {
        if self.view.frame.origin.y != 0 {
        self.view.frame.origin.y = 0
        view.endEditing(true)
        }
    }
    
    @objc private func kbWillShowAction(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
        if let userInfo = notification.userInfo, let kbFrame = userInfo[UITextField.keyboardFrameEndUserInfoKey] as? CGRect {
            self.view.frame.origin.y = view.frame.origin.y - kbFrame.height
        }
        }
    }
        
    
    @objc private func kbWillHideAction(notification: NSNotification) {
        if self.view.isFirstResponder {
        if let userInfo = notification.userInfo, let kbFrame = userInfo[UITextField.keyboardFrameEndUserInfoKey] as? CGRect {
            self.view.frame.origin.y = view.frame.origin.y + kbFrame.maxY
        }
        }
    }
    
    @objc private func registerButtonTapped(sender: UIButton? = nil) {
        if let sender = sender {
            sender.pulsate()
        }
        if let email = emailTextField.text , let pass = passTextField.text ,let checkPass = secondPassTextField.text, pass == checkPass {
            Auth.auth().createUser(withEmail: email, password: pass) { [weak self] (authResult, error) in
                if let error = error {
                    let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .actionSheet)
                    let okButton = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(okButton)
                    self?.present(alertController, animated: true)
                } else {
                    let successfulAlert = UIAlertController(title: "Successful", message: nil, preferredStyle: .actionSheet)
                    self?.present(successfulAlert, animated: true)
                let userRef = self?.ref.child(authResult!.user.uid)
                userRef?.setValue(["email": authResult!.user.email])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        successfulAlert.dismiss(animated: true)
                        SceneDelegate.shared.rootViewController.showTasksScreen()
                    }
                }
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Passwords aren't similar", preferredStyle: .actionSheet)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okButton)
            self.present(alertController, animated: true)
        }
    }
    
    
    @objc private func haveAccountButtonTapped(sender: UIButton) {
        let alertController = UIAlertController.init(title: "Sign in", message: "Enter your data", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] (button) in
            self?.dismissKeyboard()
        }
        let signInButton = UIAlertAction(title: "Sign in", style: .default) { [weak self] (button) in
            if var textFields = alertController.textFields , let email = textFields.removeFirst().text , let pass = textFields.removeFirst().text, email.contains("@") && pass.count >= 6 && pass != ""  {
                Auth.auth().signIn(withEmail: email, password: pass) { (authDataResul, error) in
                    if let error = error {
                        alertController.title = "Wrong Data"
                        alertController.message = error.localizedDescription
                        self?.present(alertController, animated: true)
                    } else {
                        let successfulAlert = UIAlertController(title: "Successful", message: nil, preferredStyle: .actionSheet)
                        self?.present(successfulAlert, animated: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            successfulAlert.dismiss(animated: true)
                            SceneDelegate.shared.rootViewController.showTasksScreen()
                        }
                    }
                }
            } else {
                alertController.title = "Wrong Data"
                alertController.message = "Invalid email or password"
                self?.present(alertController, animated: true)
            }
        }
        
        alertController.addTextField { [weak self] (emailTextField) in
            self?.configureEmailTextField(textField: emailTextField)
        }
        
        alertController.addTextField { [weak self] (passTextField) in
            self?.configurePassTextField(textField: passTextField)
        }
        alertController.addAction(cancelButton)
        alertController.addAction(signInButton)
        
        self.present(alertController, animated: true)
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
            registerButtonTapped()
        default:
            break
        }
        return true
    }
    
    
}
