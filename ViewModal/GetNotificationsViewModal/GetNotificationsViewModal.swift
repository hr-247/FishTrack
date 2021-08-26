//
//  GetNotificationsViewModal.swift
//  TrackApp
//
//  Created by saurav sinha on 26/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit

struct GetNotificationsViewModal {
    
    var notifitype: Int?
    var _id : String?
    var status : Int?
    var uname : String?
    var uimg : String?
    
    init(allnotificationsModal: notificationsModal) {
        
        if let str = allnotificationsModal.notificationType
        {
            self.notifitype = str
        }else
        {
            self.notifitype = 100
        }
    
        if self.notifitype == 2201
        {
            
            self.status = 99999
            self.uname = allnotificationsModal.performanceId?.userId?.username
            self.uimg = allnotificationsModal.performanceId?.userId?.userImage
        }
            if self.notifitype == 2202
                {
                    self.uimg  = allnotificationsModal.friendReqAcceptedId?.userId?.userImage
                    self.uname = allnotificationsModal.friendReqAcceptedId?.userId?.username
                    self.status = allnotificationsModal.friendReqAcceptedId?.status
                    if let acceptId = allnotificationsModal.friendReqAcceptedId?._id
                    {
                        
                        self._id = acceptId
                    }
                    else
                    {
                        self._id = "id"
                    }
                    
                }
        else
        {  if let sts = allnotificationsModal.friendRequestId?.status
        {
            self.status = sts
        }else
        {
            self.status = 99999
            }
            self.uname = allnotificationsModal.friendRequestId?.userWhoSentRequest?.username
            self.uimg = allnotificationsModal.friendRequestId?.userWhoSentRequest?.userImage
        }
        if self.notifitype == 2202
            {
                self.uimg  = allnotificationsModal.friendReqAcceptedId?.userId?.userImage
                self.uname = allnotificationsModal.friendReqAcceptedId?.userId?.username
                self.status = allnotificationsModal.friendReqAcceptedId?.status
                if let acceptId = allnotificationsModal.friendReqAcceptedId?._id
                {
                    
                    self._id = acceptId
                }
                else
                {
                    self._id = "id"
                }
                
            }
    }
}
struct friendrequestidViewModal
{
    var _id : String
    init(friendReq : friendrequestidModal) {
        self._id = friendReq._id!
    }
}
struct frndReqAccUserViewModal {
    var  username : String?
    
    init(frndReq : frndReqAccUserModal) {
        self.username = frndReq.username
    }
}
struct friendReqAcceptedIdViewModal {
    var _id : String?
    init(reqAccepted : friendAcceptedReqModal) {
        self._id = reqAccepted._id
    }
}
