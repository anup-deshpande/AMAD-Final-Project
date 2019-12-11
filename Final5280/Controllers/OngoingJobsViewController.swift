//
//  OngoingJobsViewController.swift
//  Final5280
//
//  Created by Anup Deshpande on 11/28/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Firebase

class OngoingJobsViewController: UIViewController {

    @IBOutlet weak var ongoingJobsTableView: UITableView!
    
    var ref: DatabaseReference!
    let refreshControl = UIRefreshControl()
    var results = [job]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize firebase database reference
        self.ref = Database.database().reference()
        
        // Get Jobs accepted by current user and show in the table
        getOngoingJobs()
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshJobPostings(_:)), for: .valueChanged)
        
        
        // Assign table view delegates
        ongoingJobsTableView.delegate = self
        ongoingJobsTableView.dataSource = self
        ongoingJobsTableView.refreshControl = refreshControl
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getOngoingJobs()
    }
    
    @objc private func refreshJobPostings(_ sender: Any) {
        // Fetch new data
        getOngoingJobs()
    }
    
    
    
    // MARK: get refreshed list of all ongoing jobs
    func getOngoingJobs(){
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("Users").child(userID!).child("ongoingJobs").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Clear table view data before adding new
            self.results.removeAll()
            
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                
                guard let dict = snap.value as? [String:Any?] else{return}
                
                let jobObject = job()
                jobObject.title = dict["title"] as? String
                jobObject.price = dict["price"] as? String
                jobObject.location = dict["location"] as? String
                jobObject.id = dict["id"] as? String
                jobObject.date = dict["date"] as? String
                jobObject.comments = dict["comment"] as? String
                jobObject.image = dict["image"] as? String
                jobObject.requesterName = dict["requesterName"] as? String
                jobObject.requesterId = dict["requesterId"] as? String
                jobObject.latitiude = dict["latitude"] as? String
                jobObject.longitude = dict["longitude"] as? String
                jobObject.description = dict["description"] as? String
                self.results.append(jobObject)
            }
            
            self.refreshControl.endRefreshing()
            self.ongoingJobsTableView.reloadData()
           
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    

}



// MARK: Table View Delegate method
extension OngoingJobsViewController: UITableViewDelegate{
    
}

extension OngoingJobsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "ongoingJobTableViewCell", for: indexPath) as! ongoingJobsTableViewCell
        
        cell.jobTitleLabel.text = results[indexPath.row].title!
        cell.jobAddressLabel.text = results[indexPath.row].location!
        cell.priceLabel.text = "$" + results[indexPath.row].price!
        cell.dateLabel.text = "\(results[indexPath.row].date!.split(separator: " ").first!)"
        
        return cell
    }
    
    
}
