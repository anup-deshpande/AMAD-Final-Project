//
//  SignUpViewController.swift
//  Final5280
//
//  Created by Adwait Tathe on 11/21/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Firebase
import KRProgressHUD
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    let imagePicker = UIImagePickerController()
    var ref: DatabaseReference!
    let storage = Storage.storage()
    var data = Data()
    var metaData = StorageMetadata()
    var isProfilepic = false;
    var signUpAPI = "http://ec2-54-144-115-37.compute-1.amazonaws.com/signUp"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
        password.isSecureTextEntry = true;
        confirmPassword.isSecureTextEntry = true;
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.imageTapped(gesture:)))
        profilePicture.addGestureRecognizer(tapGesture)
        profilePicture.isUserInteractionEnabled = true
        self.ref = Database.database().reference()
        
    }
    
    func isEverythingValid() -> Bool{
        var flag = true
        
        if firstName.text! == "" {
            self.firstName.layer.borderWidth = 1.0
            self.firstName.layer.borderColor =  #colorLiteral(red: 0.9151673913, green: 0.2175602615, blue: 0.1735651791, alpha: 1)
            self.firstName.layer.cornerRadius = 7
            flag = false
        }
        
        if lastName.text! == "" {
            self.lastName.layer.borderWidth = 1.0
            self.lastName.layer.borderColor =  #colorLiteral(red: 0.9151673913, green: 0.2175602615, blue: 0.1735651791, alpha: 1)
            self.lastName.layer.cornerRadius = 7
            flag = false
        }
        
        if email.text! == "" {
            self.email.layer.borderWidth = 1.0
            self.email.layer.borderColor =  #colorLiteral(red: 0.9151673913, green: 0.2175602615, blue: 0.1735651791, alpha: 1)
            self.email.layer.cornerRadius = 7
            flag = false
        }
        
        if password.text! == "" {
            self.password.layer.borderWidth = 1.0
            self.password.layer.borderColor =  #colorLiteral(red: 0.9151673913, green: 0.2175602615, blue: 0.1735651791, alpha: 1)
            self.password.layer.cornerRadius = 7
            flag = false
        }
        
        if confirmPassword.text! == "" {
            self.confirmPassword.layer.borderWidth = 1.0
            self.confirmPassword.layer.borderColor =  #colorLiteral(red: 0.9151673913, green: 0.2175602615, blue: 0.1735651791, alpha: 1)
            self.confirmPassword.layer.cornerRadius = 7
            flag = false
        }
        
        if password.text != confirmPassword.text{
            self.confirmPassword.layer.borderWidth = 1.0
            self.confirmPassword.layer.borderColor =  #colorLiteral(red: 0.9151673913, green: 0.2175602615, blue: 0.1735651791, alpha: 1)
            self.confirmPassword.layer.cornerRadius = 7
            self.password.layer.borderWidth = 1.0
            self.password.layer.borderColor =  #colorLiteral(red: 0.9151673913, green: 0.2175602615, blue: 0.1735651791, alpha: 1)
            self.password.layer.cornerRadius = 7
            flag = false
        }
        
        if !isProfilepic {
            KRProgressHUD.showWarning(withMessage: "Please upload a profile picture");
            flag = false
        }
        return flag
    }
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        }
    }
    
    func signUptoBraintree(_ userObj : User) {
        let parameters: [String:String] = [
            "firstName" : userObj.firstName!,
            "lastName" : userObj.lastName!,
            "phone" : "1111111111",
            "email" : userObj.email!
        ]
        var customerId : String?
        AF.request(signUpAPI, method: .post , parameters: parameters , encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["status"].stringValue == "200"{
                        customerId = json["customerId"].stringValue
                        self.ref.child("Users").child(userObj.userId!).child("braintreeId").setValue(customerId)
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        if(isEverythingValid())
        {
            let user = User()
            user.email = email.text!
            user.firstName = firstName.text!
            user.lastName = lastName.text!
            user.profilePicture = ""
            
            Auth.auth().createUser(withEmail: user.email!, password: self.password.text!) { (result, error) in
                if(result != nil){
                    user.userId = result?.user.uid
                    // Update new user on database
                    self.ref.child("Users").child(user.userId!).setValue(["userId" : user.userId , "firstName" : user.firstName , "lastName" : user.lastName , "email" : user.email])

                    // Change name in firebase Authentication
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = user.firstName! + " " + user.lastName!
                    changeRequest?.commitChanges { (error) in
                        if error != nil{
                            //print(error)
                        }
                    }
                }
                if(error != nil){
                    print(error!)
                }
                
            }
            let profileRef = self.storage.reference().child("userProfile").child(UUID().uuidString)
            let uploadTask = profileRef.putData(self.data, metadata: self.metaData) { (metadata, error) in
                if error == nil
                {
                    profileRef.downloadURL { (url, error) in
                        user.profilePicture = url?.absoluteString; self.ref.child("Users").child(user.userId!).child("profilePicture").setValue(user.profilePicture)
                            self.signUptoBraintree(user);
                    }
                }
                else
                {
                    print("ERROR")
                    print(error as Any)
                }
            }
            KRProgressHUD.showSuccess(withMessage: "Signed up successfully")
            self.navigationController?.popViewController(animated: true)
        }
    }    
}



extension SignUpViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            profilePicture.image = image
            self.data = (profilePicture.image?.pngData())!
            self.metaData.contentType = "image/png"
            self.isProfilepic = true
        }
        dismiss(animated: true, completion: nil)
        
    }
    
}
extension SignUpViewController: UITextFieldDelegate{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}
