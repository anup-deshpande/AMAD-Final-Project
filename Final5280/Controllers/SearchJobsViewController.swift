//
//  SearchJobsViewController.swift
//  Final5280
//
//  Created by Anup Deshpande on 11/27/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import MapKit
class SearchJobsViewController: UIViewController {
    
    @IBOutlet weak var searchJobTableView: UITableView!
    var ref: DatabaseReference!
    var jobList : [job] = []
    var jobObj : job? = nil
    let locationManager = CLLocationManager()
    var userLat : CLLocation?
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
        
        // Configure searchJobTableView
        searchJobTableView.delegate = self
        searchJobTableView.dataSource = self
        searchJobTableView.refreshControl = refreshControl
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshJobPostings(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readJobList()
    }
    
    @objc private func refreshJobPostings(_ sender: Any) {
        // Fetch new data
        readJobList()
    }
    
    
    
    func readJobList()
    {
        self.ref.child("jobs").observe(DataEventType.value) { (snapshot) in  
            self.jobList = []
            for child in snapshot.children
            {
                if let childSnapshot = child as? DataSnapshot{
                    
                    guard let dict = childSnapshot.value as? [String: Any?] else {return}
                    let jb = job()
                    jb.id = dict["id"] as? String
                    jb.comments = dict["comment"] as? String
                    jb.date = dict["date"] as? String
                    jb.price = dict["price"] as? String
                    jb.title = dict["title"] as? String
                    jb.description = dict["description"] as? String
                    jb.location = dict["location"] as? String
                    jb.requesterId = dict["requesterId"] as? String
                    jb.requesterName = dict["requesterName"] as? String
                    jb.latitiude = dict["latitude"] as? String
                    jb.longitude =  dict["longitude"] as? String
                    jb.image = dict["image"] as? String
                    let jobLocation = CLLocation(latitude: Double(jb.latitiude!) as! CLLocationDegrees, longitude: Double(jb.longitude!) as! CLLocationDegrees)
                    let distanceInMeters = self.userLat!.distance(from: jobLocation)
                    let distanceInMiles = distanceInMeters/(1609.34)
                    self.jobList.append(jb);
                    //                    if(distanceInMiles<25 )
                    //                    {
                    //                        self.jobList.append(jb);
                    //                    }
                }
            }
            self.searchJobTableView.reloadData();
            self.refreshControl.endRefreshing()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DisplayJobViewController
        vc.job = self.jobObj
    }
    
}
extension SearchJobsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.jobObj = self.jobList[indexPath.row]
        performSegue(withIdentifier: "seachJobToJobDisplaySeague", sender: self)
        
    }
}

extension SearchJobsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchJobTableViewCell", for: indexPath) as! SearchJobTableViewCell
        cell.setValue(self.jobList[indexPath.row],self.userLat!)
        return cell
    }
}
extension SearchJobsViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //let loc  = locations.last!.coordinate;
        self.userLat = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        readJobList();
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}


