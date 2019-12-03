//
//  ViewController.swift
//  Final5280
//
//  Created by Anup Deshpande on 11/20/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
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

