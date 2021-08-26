//
//  NotificationViewController.swift
//  TrackApp
//
//  Created by sanganan on 11/20/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit
import SDWebImage


class NotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate{
    func friendPageRedirect(_ id: String, _ userName:String) {
        if id != ""{
        let vc = AppUtils.Controllers.statsVC.get() as! StatsViewController
        vc.fromFriendPage = true
       
            vc.userId = id as! NSString
            vc.userName = userName as! NSString
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func whichBtnTapped(name: String, id: String) {
        self.reqId = id
         if name == "acceptBtn"
               {
                   approveReqApi()
               }
               else{
                   rejectReqApi()
               }
    }
    
    var friendRed = [friendrequestidViewModal]()
    var usernotifViewApi = [GetNotificationsViewModal]()
    var dataTemp = [notificationsModal]()
    var page:Int = 0
    var reqId : String = String()
    @IBOutlet weak var notifyTbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.applicationIconBadgeNumber = 0

        self.commonNavigationBar(title: "NotificationsKey".localized(), controller: AppUtils.Controllers.notificationVC, badgeCount: "0")
     //   self.view.backgroundColor = Constant.Color.backGroundColor
    //    self.notifyTbl.backgroundColor = Constant.Color.backGroundColor
        notifyTbl.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        notifyTbl.delegate = self
        notifyTbl.dataSource = self
        self.getNotificationApi()
        }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernotifViewApi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notifyTbl.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.notificationVCUI(modal:dataTemp[indexPath.row] )
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let modal = dataTemp[indexPath.row] as notificationsModal
        
//           if modal.notificationType == 2201
//            {
//                print("performance clicked with id ",modal.performanceId?._id!)
//                let vc = AppUtils.Controllers.performanceDetailsVC.get() as! PerformanceDetailsViewController
//                vc.perfDetails = nil
//                vc.userIdStr = modal.performanceId?.userId?._id
//                vc.perfomanceIDStr = modal.performanceId?._id
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        if modal.notificationType == 2203 || modal.notificationType == 2201
        {
//            print("performance clicked with id ",modal.performanceId?._id!)
           let vc = AppUtils.Controllers.comment.get() as! AddCommentViewController
            vc.performanceId = modal.performanceId?._id
            vc.isFrmNotification = true
            self.navigationController?.pushViewController(vc, animated: true)
       }
        
        
    }
    
    //MARK:- ALL NOTIFICATIONS API
    func getNotificationApi() {
        Utils.startLoading(self.view)
        let url:String = Constant.basicApi + "/getAllNotifications/\(AppUtils.AppDelegate().userId)"
        
        Service.sharedInstance.getRequest(Url:url, modalName: getNotificationsModal.self , completion: { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.success == 1{
                    if response?.Notifications.count == 0{
                        AppUtils.showToast(message: "YoudonthaveanynotificationsKey".localized())
                        return
                    }
            //    print(response,"notification case")
                    self.usernotifViewApi.removeAll()
                    self.dataTemp.removeAll()
                    if  response?.Notifications[0].friendRequestId != nil
                    {
                        self.reqId = (response?.Notifications[0].friendRequestId?._id)!
                    }
                    for item in (response?.Notifications)!
                    {
                        self.dataTemp.append(item)
                    //    print(self.dataTemp,"data entry")
                        if item.notificationType == 2201
                        {
                            let modal = GetNotificationsViewModal(allnotificationsModal: item)
                            self.usernotifViewApi.append(modal)
                        }
                        else if item.notificationType == 2200
                        {
                            let modal = GetNotificationsViewModal(allnotificationsModal: item)
                          
                            self.usernotifViewApi.append(modal)
                        }
                        else if item.notificationType == 2202
                        {
                            let modal = GetNotificationsViewModal(allnotificationsModal: item)
                              print(item.friendReqAcceptedId?.userId?.userImage)
                            self.usernotifViewApi.append(modal)
                        print(self.usernotifViewApi,"accepted request")
                        }
                        else if item.notificationType == 2203
                        {
                            let modal = GetNotificationsViewModal(allnotificationsModal: item)
                         //     print(item.friendReqAcceptedId?.userId?.userImage)
                            self.usernotifViewApi.append(modal)
                     //   print(self.usernotifViewApi,"accepted request")
                        }
                    }
                    self.notifyTbl.reloadData()
                }
            }
        })
    }
    
}

extension NotificationViewController{
//MARK:- APPROVE FRIEND REQUEST API
func approveReqApi()
    {
        Utils.startLoading(self.view)
        let url:String = "\(Constant.basicApi)/approveFreindReq"
        var reqId : String = String()
        let dict:[String:Any] = ["reqId" : self.reqId ]
        
            Service.sharedInstance.postRequest(Url:url,modalName: ApproveFriendRequestModal.self , parameter: dict as [String:Any]) { (response, error) in
                
                DispatchQueue.main.async {
                    Utils.stopLoading()
                    
                    if let res = response?.Success
                    {
                        if res == 1{
                            AppUtils.showToast(message: "FriendRequestAcceptedKey".localized())
                            self.getNotificationApi()
                        }
                    }
                }
            }
        }
   //MARK:- REJECT FRIEND REQUEST API
    func rejectReqApi()
    {
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/rejectFreindReq/\(self.reqId)"
       Service.sharedInstance.getRequest(Url:url,modalName:RejectRequestModal.self,completion: { (response, error) in
                DispatchQueue.main.async {
                    Utils.stopLoading()
                    if response?.Success == 1
                    {
                        self.getNotificationApi()
                        AppUtils.showToast(message: "FriendrequestwasrejectedKey".localized())
                    }
                }
            })
        }
}


