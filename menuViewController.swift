//
//  MenuViewController.swift
//  Final5280
//
//  Created by Anup Deshpande on 11/27/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit

enum MenuType: Int{
    case searchJobs
    case ongoingJobs
    case jobPostings
    case logout
}

class menuViewController: UITableViewController {

    var didTapMenuType: ((MenuType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else {return}
        dismiss(animated: true){ [weak self] in
            self?.didTapMenuType?(menuType)
        }
    }
    
}
