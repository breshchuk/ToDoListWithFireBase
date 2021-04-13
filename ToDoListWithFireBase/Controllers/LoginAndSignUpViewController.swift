//
//  LoginAndSignUpViewController.swift
//  ToDoListWithFireBase
//
//  Created by dimam on 4.03.21.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class LoginAndSignUpViewController: UIViewController {
    
    private var ref: DatabaseReference!
    private var haveAccountButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private var registrationLabel = UILabel()
    private var emailTextField = UITextField()
    private var passTextField = UITextField()
    private var secondPassTextField = UITextField()
    private var registerButton = UIButton()
    private var loginButton = UIButton()
    private var textFieldsStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var fbLoginButton : FBLoginButton = {
        let button = FBLoginButton()
        button.delegate = self
        button.permissions = ["email","public_profile"]
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private var registerButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    lazy private var googleButton: GIDSignInButton = {
        let loginButton = GIDSignInButton()
        return loginButton
    }()
    lazy private var withoutRegButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(withoutRegButtonTapped(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        button.setTitle("Continue without login", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       // view.translatesAutoresizingMaskIntoConstraints = false
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        ref = Database.database().reference().child("users")
        
        //MARK: - UI(Labels)
        registrationLabel.frame = CGRect(x: 10, y: 50, width: 300, height: 60)
        registrationLabel.text = "Registration"
        registrationLabel.font = UIFont.systemFont(ofSize: 50)
        registrationLabel.shadowOffset = .init(width: 2, height: 0)
        registrationLabel.shadowColor = .black
        
        textFieldsStackView.addArrangedSubview(emailTextField)
        textFieldsStackView.addArrangedSubview(passTextField)
        textFieldsStackView.addArrangedSubview(secondPassTextField)
        textFieldsStackView.spacing = 20
        textFieldsStackView.axis = .vertical
        
        for view in textFieldsStackView.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 60).isActive = true
        }
        
        //MARK: - UI(Text fields)
        configureEmailTextField(textField: emailTextField)
        configurePassTextField(textField: passTextField)
       
        secondPassTextField.placeholder = "Repeat password"
        secondPassTextField.isSecureTextEntry = true
        secondPassTextField.borderStyle = .roundedRect
        secondPassTextField.autocapitalizationType = .none
        secondPassTextField.autocorrectionType = .no
        secondPassTextField.returnKeyType = .done
        secondPassTextField.delegate = self
        
        //MARK: - UI(Buttons)
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .blue
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.addTarget(self, action: #selector(registerButtonTapped(sender:)), for: .touchUpInside)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        haveAccountButton.setTitle("Already have account?", for: .normal)
        haveAccountButton.setTitleColor(.systemBlue, for: .normal)
        haveAccountButton.addTarget(self, action: #selector(haveAccountButtonTapped(sender:)), for: .touchUpInside)
        
        
        //MARK: - Reg Stack View
        registerButtonsStackView.addArrangedSubview(registerButton)
        registerButtonsStackView.addArrangedSubview(googleButton)
        registerButtonsStackView.addArrangedSubview(fbLoginButton)
        registerButtonsStackView.addArrangedSubview(withoutRegButton)
        
        for view in registerButtonsStackView.subviews {
            view.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100).isActive = true
            view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        
        //MARK: - Add subviews
        view.addSubview(registrationLabel)
        view.addSubview(haveAccountButton)
        view.addSubview(textFieldsStackView)
        view.addSubview(registerButtonsStackView)
        
        //MARK: - NSNotifications
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShowAction(notification:)), name: UITextField.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHideAction(notification:)), name: UITextField.keyboardWillHideNotification, object: nil)
        
        //MARK: Tap Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    //MARK: - Constraints
    override func viewWillLayoutSubviews() {
        
        haveAccountButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        haveAccountButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        haveAccountButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive = true
        haveAccountButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        textFieldsStackView.topAnchor.constraint(equalTo: haveAccountButton.bottomAnchor, constant: 70).isActive = true
        textFieldsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
//        textFieldsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 30).isActive = true
        
      registerButtonsStackView.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 40).isActive = true
      registerButtonsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        registerButtonsStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        registerButtonsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 60).isActive = true
        
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
            self.view.frame.origin.y = view.frame.origin.y - kbFrame.height / 2
        }
        }
    }
        
    
    @objc private func kbWillHideAction(notification: NSNotification) {
        if self.view.isFirstResponder {
        if let userInfo = notification.userInfo, let kbFrame = userInfo[UITextField.keyboardFrameEndUserInfoKey] as? CGRect {
            self.view.frame.origin.y = view.frame.origin.y + kbFrame.maxY / 2
        }
        }
    }
    
    //MARK: - Buttons Handlers
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
                            self?.setProvider(provider: .firebase)
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
    
    
    @objc private func withoutRegButtonTapped(sender: UIButton) {
        sender.pulsate()
        setProvider(provider: .withoutProvider)
        SceneDelegate.shared.rootViewController.showTasksScreen()
    }
    
    private func setProvider(provider: Provider) {
        UserDefaults.standard.setValue(provider, forKey: "provider")
    }

}

extension LoginAndSignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
            passTextField.becomeFirstResponder()
        case passTextField:
            passTextField.resignFirstResponder()
            secondPassTextField.becomeFirstResponder()
        case secondPassTextField:
            registerButtonTapped()
        default:
            break
        }
        return true
    }
    
    private func signInWithFirebase(credential: AuthCredential,complitionHandler: @escaping ((Result<Any, Error>) -> Void)) {
        Auth.auth().signIn(with: credential) { [weak self] (FIRresult, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                complitionHandler(.failure(error))
                return
            }
            guard let user = FIRresult?.user else { return }
            if FIRresult!.additionalUserInfo!.isNewUser {
                let user = LocalUser(user: user)
                self?.ref.child(user.id).setValue(["email": user.email])
            }
            complitionHandler(.success(user))
    }
  }
}

extension LoginAndSignUpViewController: LoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            debugPrint(error.localizedDescription)
            return
        }
        
        if let result = result , result.isCancelled {
            return
        }
        
        guard let accessToken = result?.token?.tokenString else {return}
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)

        signInWithFirebase(credential: credential) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
                DispatchQueue.main.async {
                    self.setProvider(provider: .facebook)
                    SceneDelegate.shared.rootViewController.showTasksScreen()
                }
            }
        }
//            if let _ = result {
//                self?.saveFBData()
//            }
        }
    
    private func saveFBData() {
        
        GraphRequest(graphPath: "me", parameters: ["fields": "id, email"]).start(completionHandler: { [weak self] (_, result, error) in
             if let userData = result as? [String: Any] {
                let user = LocalUser(data: userData)
                let userRef = self?.ref.child(user.id)
                userRef?.setValue(["email": user.email])
                DispatchQueue.main.async {
                    SceneDelegate.shared.rootViewController.showTasksScreen()
                }
            }
        })
    }
}

extension LoginAndSignUpViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let auth = user.authentication else {return}
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        signInWithFirebase(credential: credential) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
                DispatchQueue.main.async {
                    self.setProvider(provider: .google)
                    SceneDelegate.shared.rootViewController.showTasksScreen()
                }
            }
        }
        
        
    }
    
    
}
