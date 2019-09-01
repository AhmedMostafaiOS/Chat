//
//  SignInViewController.swift
//  InstagramClone
//
//  Created by The Zero2Launch Team on 11/30/16.
//  Copyright © 2016 The Zero2Launch Team. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ProgressHUD
class SignInViewController: UIViewController {
    var db:DatabaseReference?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Database.database().reference(withPath: "Users")

        emailTextField.backgroundColor = UIColor.clear
        emailTextField.tintColor = UIColor.white
        emailTextField.textColor = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayerEmail)
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)
        signInButton.isEnabled = false
        handleTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Helper.currentUser != nil {
            showHome()
        }
    }
    
   
    @IBAction func SignUp(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        show(vc, sender: nil)
    }
    
    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                signInButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
                signInButton.isEnabled = false
                return
        }
        
        signInButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        signInButton.isEnabled = true
    }
    
    @IBAction func signInButton_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        Auth.auth().signIn(withEmail:  emailTextField.text!, password: passwordTextField.text!) { (response, error) in
            if (error != nil) {
                ProgressHUD.showError(error.debugDescription )
                return
            }
            let id = Auth.auth().currentUser?.uid ?? ""

            self.db?.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    ProgressHUD.showSuccess("Success")

                    guard let value = snapshot.value as? [String: Any] else { return }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                        self.db?.child(id).child("status").setValue(true)
                        
        
                        let user = try JSONDecoder().decode(User.self, from: jsonData)
                        Helper.currentUser = user
                        self.showHome()
                    } catch let error {
                        print(error)
                    }
                }
            })
        }
    }
    func showHome()  {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "NavHomeViewController"))! 
        present(vc, animated: true, completion: nil)
    }
    
}
