//
//  HomeViewController.swift
//  TrackApp
//
//  Created by sanganan on 11/4/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit
import BadgeSwift
import SDWebImage

class HomeViewController : UIViewController,UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate {
    var badgeC : Int = Int()
    var arr = ["AddYourPerformanceKey".localized(),"MystatsKey".localized(),"MyFriendsKey".localized()]
    var imageArr = ["performance.png","stats.png","Myfriends.png"]
    @IBOutlet weak var topImgConstraint : NSLayoutConstraint!
    @IBOutlet weak var topLblConstraint : NSLayoutConstraint!
    @IBOutlet var profileImg : UIImageView!
    @IBOutlet weak var welcomeLabel : UILabel!
    @IBOutlet var userNameLabel : UILabel!
    @IBOutlet weak var statsTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commonNavigationBar(title: "HOMEKey".localized(), controller: AppUtils.Controllers.home,badgeCount: String(describing:self.badgeC))
     //   self.view.backgroundColor = Constant.Color.backGroundColor
    //    self.statsTableView.backgroundColor = Constant.Color.backGroundColor
        if AppUtils.getStringForKey(key: Constant.userImage) != nil{
            profileImg.sd_setImage(with: URL(string: AppUtils.getStringForKey(key: Constant.userImage)!), completed: nil)
        }else{
            profileImg.image = UIImage(named: "avatar1")
        }
        
        
        let user = UserDefaults.standard
               
               let lat = (user.double(forKey: Constant.latitude))
               let long = (user.double(forKey: Constant.longitude))
               
               
               if (lat == 0 ) || (lat == nil ) || (lat is NSNull) {
                
                Utils.sharedInstance.initLocationManager()
        }
        
        profileImg.layer.masksToBounds = false
        profileImg.layer.borderColor = UIColor.white.cgColor
        profileImg.clipsToBounds = true
        
        statsTableView.backgroundColor = .black
        welcomeLabel.text = "HelloKey".localized()
        userNameLabel.text = AppUtils.getStringForKey(key: Constant.username)
        welcomeLabel.textColor = .white
        userNameLabel.textColor = .white
        
        statsTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        statsTableView.dataSource = self
        statsTableView.delegate = self
        homeApi()
        self.topImgConstraint.constant = (UIScreen.main.bounds.height - (0.98*UIScreen.main.bounds.height))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.homeApi()
    }
    func homeApi()
    {
        let dispatchGrp = DispatchGroup()
        
        dispatchGrp.enter()
        DispatchQueue.main.async {
            self.getNotificationsCount()
            dispatchGrp.leave()
        }
        dispatchGrp.enter()
        DispatchQueue.main.async{
           self.myProfileApi()
            dispatchGrp.leave()
        }
        dispatchGrp.notify(queue: DispatchQueue.main) {
            //    print("done")
        }
    }
    //MARK:-TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : HomeTableViewCell = statsTableView.dequeueReusableCell(withIdentifier : "HomeTableViewCell" ,for: indexPath) as! HomeTableViewCell
        
        cell.cellLabel.text = arr[indexPath.row]
        cell.cellImage.image = UIImage(named: imageArr[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0
        {
            let vc = AppUtils.Controllers.addYourPerfrmnceVC.get() as! AddYourPerformanceViewController
            self.navigationController?.pushViewController(vc, animated: true);
        }
        else if indexPath.row == 1
        {
            let vc = AppUtils.Controllers.statsVC.get() as! StatsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        else
        {
            let vc = AppUtils.Controllers.myFriendsVC.get() as! MyFriendsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
    func getNotificationsCount()
    {
        let url : String = "\(Constant.basicApi)/notificationCount/\(AppUtils.AppDelegate().userId)"
        Service.sharedInstance.getRequest(Url:url,modalName:NotificationsCountModal.self,completion: { (response, error) in
            DispatchQueue.main.async {
                
                if response?.myNotificationsCount?.notifCount != nil
                {
                    self.badgeC = (response?.myNotificationsCount?.notifCount)!
                    self.commonNavigationBar(title: "HOMEKey".localized(), controller: AppUtils.Controllers.home,badgeCount:String(describing:self.badgeC))
                }
            }
        })
    }
    func myProfileApi()
    {
        let url : String = "\(Constant.basicApi)/myProfile/\(AppUtils.AppDelegate().userId)"
        Service.sharedInstance.getRequest(Url:url,modalName:myProfileModal.self,completion: { (response, error) in
            DispatchQueue.main.async {
                if let res = response?.Success
                {
                    if res == 1
                    {
                        //                                  let userData = UserDefaults.standard
                        //                                  userData.set(response?.isPaid, forKey: Constant.isPaid)
                        AppUtils.setStringForKey(key: Constant.referralCode, val: (response?.user.referral)!)
                        AppUtils.setStringForKey(key: Constant.userImage, val: (response?.user.userImage)!)
                        if let data = response?.user.paymentPrem{
                            
                            let data = AppUtils.timestampToDate1(timeStamp: Double(data.endTime))
                            AppUtils.setStringForKey(key: Constant.subscriptionENd, val: data)
                            
                        }

                        if response?.isBasic == 0 {
                            let vc = AppUtils.Controllers.basic.get() as! BasicSubscriptionViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)

                        }
                        
                        
                        if response?.isPremimum == 0
                        {
                            AppUtils.setStringForKey(key: Constant.isPaymentDone, val: "")
                        }else{
                            let userData = UserDefaults.standard
                            userData.set("1", forKey: Constant.isPaid)
                        }
                    }
                }
            }
        })
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if (gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer)
        {
            if ((self.navigationController?.viewControllers.count)! > 1)
            {
                return true
            }
            return false
        }
        
        return true
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true);
        print("view did appear");
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        //GIDSignIn.sharedInstance().signInSilently()
        self.navigationController?.interactivePopGestureRecognizer!.delegate = nil
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        //GIDSignIn.sharedInstance().signInSilently()
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
    }
}
