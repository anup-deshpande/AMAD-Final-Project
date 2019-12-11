//
//  DisplayJobViewController.swift
//  Final5280
//
//  Created by Adwait Tathe on 12/8/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import KRProgressHUD

class DisplayJobViewController: UIViewController {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var requesterNameLabel: UILabel!
    @IBOutlet weak var jobImage: UIImageView!
    var job : job?
    var ref: DatabaseReference!
    @IBOutlet weak var bidPrice: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.job!.title
        bidPrice.delegate = self
        loadJobDetails()
        self.ref = Database.database().reference()
    }
    @IBAction func submit(_ sender: Any) {
        let userId = Auth.auth().currentUser?.uid
        let userName = Auth.auth().currentUser?.displayName
        let jobwithBidref = self.ref.child("Users").child(self.job!.requesterId!).child("createdJobs").child(self.job!.id!).child("InterestedUsers").child(userId!)
        let bid = bidPrice.text
        let bidDetails : [String: Any?] = [
            "userName" : userName,
            "bidPrice" : bid
        ]
        jobwithBidref.setValue(bidDetails);
        KRProgressHUD.showSuccess(withMessage: "Your job request sent successfully")
        navigationController?.popViewController(animated: true)
    }
    
    func loadJobDetails()
    {
    
        commentLabel.text = self.job!.comments!
        locationLabel.text = self.job!.location!
        dateLabel.text = String((self.job!.date!.split(separator: " ")[0]))
        priceLabel.text = self.job!.price!
        
      
        if let stringUrl = self.job!.image {
            let url = URL(string: stringUrl)
            jobImage.kf.setImage(with: url)
        }
        requesterNameLabel.text = self.job!.requesterName!
    }
}

extension DisplayJobViewController : UITextFieldDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}



