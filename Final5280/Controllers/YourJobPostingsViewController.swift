//
//  YourJobPostingsViewController.swift
//  Final5280
//
//  Created by Anup Deshpande on 11/28/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Firebase

class YourJobPostingsViewController: UIViewController {

    @IBOutlet weak var jobPostingsTableView: UITableView!
    
    var results = [job]()
    var ref: DatabaseReference!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize firebase database reference
        self.ref = Database.database().reference()
        
        // Get Jobs posted by current user and show in the table
        getJobs()
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshJobPostings(_:)), for: .valueChanged)
        
        // Configure table view
        jobPostingsTableView.delegate = self
        jobPostingsTableView.dataSource = self
        jobPostingsTableView.refreshControl = refreshControl
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getJobs()
    }
    
    @objc private func refreshJobPostings(_ sender: Any) {
        // Fetch new data
        getJobs()
    }
    
    // MARK: get refreshed list of all the jobs posted by current user
    func getJobs(){
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("Users").child(userID!).child("createdJobs").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Clear table view data before adding new
            self.results.removeAll()
            
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                
                guard let dict = snap.value as? [String:Any?] else{return}
                
                let jobObject = job()
                jobObject.title = dict["title"] as? String
                jobObject.expectedPrice = dict["expectedPrice"] as? String
                jobObject.location = dict["location"] as? String
                jobObject.id = dict["id"] as? String
                jobObject.date = dict["date"] as? String
                jobObject.comments = dict["comment"] as? String
                self.results.append(jobObject)
            }
            
            self.refreshControl.endRefreshing()
            self.jobPostingsTableView.reloadData()
           
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}


// MARK: TableView Delegate Methods
extension YourJobPostingsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobDescVC = storyboard?.instantiateViewController(identifier: "JobDescriptionViewController") as! JobDescriptionViewController
        jobDescVC.jobToDisplay = results[indexPath.row]
        navigationController?.pushViewController(jobDescVC, animated: true)
        
    }
}

extension YourJobPostingsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobPostingsCell", for: indexPath) as! yourJobPostingsTableViewCell
        
        cell.jobTitleLabel.text = results[indexPath.row].title!
        cell.addressLabel.text = results[indexPath.row].location!
        cell.priceLabel.text = "$\(results[indexPath.row].expectedPrice!)"
        
        
        return cell
    }
    
    
}
