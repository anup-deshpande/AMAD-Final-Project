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
import MapKit
import CoreLocation

class DisplayJobViewController: UIViewController {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var requesterNameLabel: UILabel!
    @IBOutlet weak var jobImage: UIImageView!
    var job : job!
    var ref: DatabaseReference!
    let locationManager = CLLocationManager()
    @IBOutlet weak var bidPrice: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.job.title
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as! CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        bidPrice.delegate = self
        loadJobDetails()
        self.ref = Database.database().reference()
    }
    @IBAction func submit(_ sender: Any) {
        let userId = Auth.auth().currentUser?.uid
        let userName = Auth.auth().currentUser?.displayName
        let jobwithBidref = self.ref.child("Users").child(self.job.requesterId!).child("createdJobs").child(self.job.id!).child("InterestedUsers").child(userId!)
        
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
        let url = "https://firebasestorage.googleapis.com/v0/b/easydollardb.appspot.com/o/userProfile%2F9ED8C2B2-70B1-43B4-A1D4-A0513DF1796F?alt=media&token=1a7ddcb4-3b4c-42aa-972f-dc3e071ad871"
        commentLabel.text = self.job.comments
        locationLabel.text = self.job.location
        dateLabel.text = String((self.job.date?.split(separator: " ")[0])!)
        priceLabel.text = self.job.expectedPrice
        jobImage.kf.setImage(with: URL(string: url))
        requesterNameLabel.text = self.job.requesterName
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

