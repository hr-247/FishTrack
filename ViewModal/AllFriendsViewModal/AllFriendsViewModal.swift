//
//  AllFriendsViewModal.swift
//  TrackApp
//
//  Created by saurav sinha on 16/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit

struct AllFriendsViewModal {
    
    var id: String?
    var usrnme: String?
    var usrimg: String?
    
    init(allFriendsModal: friendModal) {
        
        self.id = allFriendsModal._id
        self.usrnme = allFriendsModal.username
        self.usrimg = allFriendsModal.userImage
    }
}
