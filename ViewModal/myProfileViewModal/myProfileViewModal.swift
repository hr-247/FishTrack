//
//  myProfileViewModal.swift
//  TrackApp
//
//  Created by sanganan on 1/16/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//
import UIKit
struct myProfileViewModal {
     var Success : Int
        var isPaid : Int
        var User : userDetailModal
    init(myProfiles : myProfileModal) {
        self.Success = myProfiles.Success
        self.isPaid = myProfiles.isPremimum
        self.User = myProfiles.user
    }
        
   
        }
        
    
    struct userDetailViewModal {
        var username : String
        var email : String
        var userImage : String
        init(userDetails : userDetailModal) {
            self.username = userDetails.username!
            self.email = userDetails.email!
            self.userImage = userDetails.userImage!
        }
        
  
        }
    


