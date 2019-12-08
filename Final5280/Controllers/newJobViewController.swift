//
//  newJobViewController.swift
//  Final5280
//
//  Created by Anup Deshpande on 12/6/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

class newJobViewController: UIViewController {

    @IBOutlet weak var clickImage: UIImageView!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var jobDescTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var commentsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign all textField delegates
        jobTitleTextField.delegate = self
        jobDescTextField.delegate = self
        priceTextField.delegate = self
        commentsTextField.delegate = self
        
        
        // Add tap gesture to clickImage
        let tapClickImage = UITapGestureRecognizer(target: self, action: #selector(tappedClickImage))
        clickImage.isUserInteractionEnabled = true
        clickImage.addGestureRecognizer(tapClickImage)
        
        
    }
    
    @objc func tappedClickImage(_ sender: UITapGestureRecognizer){
        
        // Make sure that device has a camera
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            // setup and present camera
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
        
    }
    
    @IBAction func didTapLocationText(_ sender: UITextField) {
        locationTextField.resignFirstResponder()
        
        // Show autocomplete controller
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func didTapSubmit(_ sender: UIButton) {
        // Check for input validity
        if isEverythingValid(){
            
        }else{
            return
        }
        
        // TODO: Store the image in Firebase storage
        
        // TODO: Store new job in database
        
        
        // TODO: Go back to previous screen
    }
    
    func isEverythingValid() -> Bool{
        var flag = true
        
        if jobTitleTextField.text! == "" {
            self.jobTitleTextField.layer.borderWidth = 1.0
            self.jobTitleTextField.layer.borderColor = #colorLiteral(red: 0.9151673913, green: 0.2175602615, blue: 0.1735651791, alpha: 1)
            self.jobTitleTextField.layer.cornerRadius = 7
            flag = false
        }
        
        if jobDescTextField.text! == "" {
            self.jobDescTextField.layer.borderWidth = 1.0
            self.jobDescTextField.layer.borderColor = #colorLiteral(red: 0.9151673913, green: 0.2175602615, blue: 0.1735651791, alpha: 1)
            self.jobDescTextField.layer.cornerRadius = 7
            flag = false
        }
        
        if priceTextField.text! == "" {
            self.priceTextField.layer.borderWidth = 1.0
            self.priceTextField.layer.borderColor = #colorLiteral(red: 0.9151673913, green: 0.2175602615, blue: 0.1735651791, alpha: 1)
            self.priceTextField.layer.cornerRadius = 7
            flag = false
        }
        
        if locationTextField.text! == "" {
            self.locationTextField.layer.borderWidth = 1.0
            self.locationTextField.layer.borderColor = #colorLiteral(red: 0.9151673913, green: 0.2175602615, blue: 0.1735651791, alpha: 1)
            self.locationTextField.layer.cornerRadius = 7
            flag = false
        }
        
        
        return flag
    }
}

// MARK: Click image delegate methods
extension newJobViewController:  UIImagePickerControllerDelegate , UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            clickImage.image = image
        }
        dismiss(animated: true, completion: nil)
        
    }
}

// MARK: Google places autocomplete code
extension newJobViewController: GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController',
        // display the name in textField
        
        locationTextField.text = place.name!
        locationTextField.layer.borderWidth = 0
        print(place.coordinate)
        
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
    
    
}


// MARK: TextField Delegate
extension newJobViewController: UITextFieldDelegate{
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



