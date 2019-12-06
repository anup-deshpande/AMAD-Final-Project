//
//  YourJobPostingsViewController.swift
//  Final5280
//
//  Created by Anup Deshpande on 11/28/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit

class YourJobPostingsViewController: UIViewController {

    @IBOutlet weak var jobPostingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobPostingsTableView.delegate = self
        jobPostingsTableView.dataSource = self
    }

}

extension YourJobPostingsViewController: UITableViewDelegate{
    
}

extension YourJobPostingsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobPostingsCell", for: indexPath)
        
        return cell
    }
    
    
}
