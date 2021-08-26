//
//  TableViewCell.swift
//  TrackApp
//
//  Created by sanganan on 11/20/19.
//  Copyright © 2019 Sanganan. All rights reserved.

import UIKit
protocol TableViewCellDelegate {
    func whichBtnTapped(name:String,id:String)
    func friendPageRedirect(_ id:String, _  userName:String)
}

class TableViewCell: UITableViewCell {
    
    var delegate:TableViewCellDelegate?
    
    @IBOutlet weak var profileImg: UIImageView!
  //  @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var descLbl: UILabel!
  //  @IBOutlet weak var durLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    var reqID:String = ""
    var name = String()
    var friendUserId = ""
    var userName = ""
    override func awakeFromNib() {
        super.awakeFromNib()
   //     self.contentView.backgroundColor = Constant.Color.backGroundColor
    }
        override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            profileImg.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(TableViewCell.imageTapped(_:)))
                       tap.delegate = self
                       tap.numberOfTouchesRequired = 1
                       profileImg.addGestureRecognizer(tap)
         }
        func notificationVCUI(modal: notificationsModal) {
            let val = modal.notificationType
        self.acceptBtn.isHidden = true
        self.rejectBtn.isHidden = true
           // createdTime
           self.timeLbl.text = ""
            if let time = modal.createdTime
            {
                self.timeLbl.text = AppUtils.timestampToDate(timeStamp: Double(time))

            }
            
            
            

        if val == 2202
        {
            if let nma = (modal.friendReqAcceptedId?.userId?.username){
                self.name = nma
                
            }else{
                self.name = "User"
            }
            if let uID = (modal.friendReqAcceptedId?.userId?._id){
               self.friendUserId = uID
            }else
            {
                self.friendUserId = ""
            }
            
            self.acceptBtn.isHidden = true
            self.rejectBtn.isHidden = true
            if let image = modal.friendReqAcceptedId?.userId?.userImage { self.profileImg.sd_setImage(with:URL(string: image) , completed: nil)
                 }else{
                     self.profileImg.image = UIImage(named: "avatar1")
                 }
//            self.descLbl.text = "\(name)" + "acceptedyourfriendrequestKey".localized()
            
            self.descLbl.text = "acceptedyourfriendrequestKey".localized().replacingOccurrences(of: "XXXX", with: "\(name)")

            
            
        }
        else if val == 2200
        {
         //   self.userName.text = name
            if let image = modal.friendRequestId?.userWhoSentRequest?.userImage { self.profileImg.sd_setImage(with:URL(string: image) , completed: nil)
            }else{
                self.profileImg.image = UIImage(named: "avatar1")
            }
            if let nma = (modal.friendRequestId?.userWhoSentRequest?.username){
                self.name = nma
                
            }else{
                self.name = "User"
            }
            let val1 = modal.friendRequestId?.status
            switch val1 {
            case 2001:
                self.acceptBtn.isHidden = false
                self.rejectBtn.isHidden = false
                self.reqID = (modal.friendRequestId?._id)!
               // self.descLbl.text = "\(name)" + "sentyouafriendrequestKey".localized()
                self.descLbl.text = "sentyouafriendrequestKey".localized().replacingOccurrences(of: "XXXX", with: "\(name)")

               
                break;
            case 2002:
             //   var nameA = modal.uname!
               //friendUserId
                self.friendUserId =  (modal.friendRequestId?.userWhoSentRequest?._id)!
                self.userName = (modal.friendRequestId?.userWhoSentRequest?.username)!
                //self.descLbl.text = "YouacceptedKey".localized() + "\(name)" + "friendrequestKey".localized()
                self.descLbl.text = "YouacceptedKey".localized().replacingOccurrences(of: "XXXX", with: "\(name)")

                break;
            case 2003:
                //self.descLbl.text = "YourejectedKey".localized() + "\(name)" + "friendrequestKey".localized()
                self.descLbl.text = "YourejectedKey".localized().replacingOccurrences(of: "XXXX", with: "\(name)")

                
                break;
            default:
                print("")
            }
            // cell.descLbl.text = "request created"
        }
        else if val == 2201
        {
         //   self.userName.text = name
            if let image = modal.performanceId?.userId?.userImage { self.profileImg.sd_setImage(with:URL(string: image) , completed: nil)
            }else{
                self.profileImg.image = UIImage(named: "avatar1")
            }
            if let nma = (modal.performanceId?.userId?.username){
                self.name = nma
                
            }else{
                self.name = "User"
            }
            self.friendUserId =  (modal.performanceId?.userId?._id)!
            self.userName = (modal.performanceId?.userId?.username)!
//            self.descLbl.text = "\(name)" + "addedaperformanceKey".localized()
            self.descLbl.text = "addedaperformanceKey".localized().replacingOccurrences(of: "XXXX", with: "\(name)")

        }
            else if val == 2203
            {
                     //   self.userName.text = name
                if let image = modal.userWhoCommented?.userImage { self.profileImg.sd_setImage(with:URL(string: image) , completed: nil)
                        }else{
                            self.profileImg.image = UIImage(named: "avatar1")
                        }
                        if let nma = (modal.userWhoCommented?.username){
                            self.name = nma
                            
                        }else{
                            self.name = "User"
                        }
                        
                        self.descLbl.text = "addedCommentKey".localized().replacingOccurrences(of: "XXXX", with: "\(name)")

                    }
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer? = nil){
        self.delegate!.friendPageRedirect(self.friendUserId, self.name)
    }
    @IBAction func acceptBtnTapped(_ sender: Any) {
        self.delegate?.whichBtnTapped(name: "acceptBtn", id: self.reqID)
    }
    @IBAction func rejectBtnTapped(_ sender: Any) {
        self.delegate?.whichBtnTapped(name: "rejectBtn", id: self.reqID)
    }
}

   
