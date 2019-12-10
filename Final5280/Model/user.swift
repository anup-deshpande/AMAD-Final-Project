//
//  user.swift
//  Final5280
//
//  Created by Adwait Tathe on 12/3/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import Foundation

class User{
    
    var userId : String?
    var firstName : String?
    var lastName : String?
    var email : String?
    var profilePicture : String?
    var bidPrice: String?
    
    init(_ id: String,_ firstName: String, _ lastName : String , _ email : String , _ profilePicture: String) {
        self.userId = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.profilePicture = profilePicture
    }
    init(){
        
    }
    
    
}
