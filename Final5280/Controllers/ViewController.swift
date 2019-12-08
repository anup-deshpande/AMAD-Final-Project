//
//  ViewController.swift
//  Final5280
//
//  Created by Anup Deshpande on 11/20/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "LoginToHomeSeague", sender: nil)
        }
    }
    @IBAction func unWindtoLogin(_ sender: UIStoryboardSegue){
        
    }
    
    func validation() -> Bool
    {
        var flag = true
        if(emailTextField.text == ""){
            print("Email Cannot be empty");
            flag = false
        }
        if(passwordTextField.text == ""){
            print("Password Cannot be empty");
            flag = false
        }
        return flag
    }

    @IBAction func login(_ sender: Any) {
        if(validation())
        {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){ [weak self] authResult, error in
                if(error == nil)
                {
                    guard let strongSelf = self else { return }
                    self!.performSegue(withIdentifier: "LoginToHomeSeague", sender: nil)
                }
                else
                {
                    print("Wrong Email or password");
                }
            }
            
        } 
    }
}

extension ViewController: UITextFieldDelegate{
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

