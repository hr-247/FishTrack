//
//  MyFriendsViewController.swift
//  TrackApp
//
//  Created by sanganan on 11/7/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit
import Cosmos


class MyFriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var durationVar : Date = Date()
    var now : String = String()
    //   @IBOutlet weak var btmConstraint: NSLayoutConstraint!
    @IBOutlet weak var myFriendsTableView: UITableView!
    // @IBOutlet weak var addImage: UIImageView!
    var userArr1 = [FriendInfoViewModal]()
    var transferdata = [FriendInfoModal]()
    @IBOutlet weak var messageLblOutlet: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    
    //MARK:- VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonNavigationBar(title: "MyFriendsKey".localized(), controller: AppUtils.Controllers.myFriendsVC, badgeCount: "0")
        self.messageLblOutlet.text = "NofriendstimelinetoshowKey".localized()
        //    self.view.backgroundColor = Constant.Color.backGroundColor
        //    self.myFriendsTableView.backgroundColor = Constant.Color.backGroundColor
        //     self.bgView.backgroundColor = Constant.Color.backGroundColor
        //      self.addImage.image = UIImage(named: "add")
        //       self.btmConstraint.constant = (UIScreen.main.bounds.height - (0.99*UIScreen.main.bounds.height))
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pageRefresh), name: NSNotification.Name(rawValue: "unfriend"), object: nil)
        
       // NotificationCenter.default.addObserver(self, selector: #selector(pageRefresh), name: NSNotification.Name(rawValue:"BackButton"), object: nil)
        
        
        
        myFriendsTableView.estimatedRowHeight = 339;
        myFriendsTableView.register(UINib(nibName: "MyFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "MyFriendsTableViewCell")
        myFriendsTableView.dataSource = self
        myFriendsTableView.delegate = self
        Utils.startLoading(self.view)
        //MARK:- GET API CALL
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getMyFriendApi()
    }
    
    @objc func pageRefresh()
    {
        self.getMyFriendApi()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.myFriendsTableView.reloadData()
    }
    
    //MARK:- ACTIONS
    @IBAction func addButton(_ sender: Any) {
        let vc = AppUtils.Controllers.inviteFriendsVC.get() as! InviteFriendsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- TABLE VIEW
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArr1.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyFriendsTableViewCell = myFriendsTableView.dequeueReusableCell(withIdentifier: "MyFriendsTableViewCell", for: indexPath) as! MyFriendsTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.cell = indexPath.row
        cell.fullPerformanceDetails.isHidden = true
        cell.shareBtn.isHidden = true
        
        if let name = userArr1[indexPath.row].user?.username
        {
            cell.userName.text = name
            
        }else
        {
            cell.userName.text =  ""
        }
        if let image = userArr1[indexPath.row].user?.userImage
        {
            cell.profilePic.sd_setImage(with: URL(string: image),placeholderImage: UIImage(named: "avatar1"))
            
        }else
        {
            cell.profilePic.image =  UIImage(named: "avatar1")
        }
        
        now = durationVar.timeAgoDisplay()
        durationVar = AppUtils.dateToTimestamp(date: userArr1[indexPath.row].createdTime!) as Date
        cell.timeLabel.text = "AddedperformanceKey".localized() + String(describing: now)
        cell.timeImg.image = UIImage(named: "watch")
        cell.durationLbl.text = String(describing: userArr1[indexPath.row].duration!) + "minsKey".localized()
        cell.locationImg.image = UIImage(named: "map")
        cell.addressLbl.text = userArr1[indexPath.row].location
        cell.fishArr = self.userArr1[indexPath.row].fishName
        cell.rate = userArr1[indexPath.row].rate
        if let muscleLyk : Int = userArr1[indexPath.row].musclelikeCount
        {
            if muscleLyk != nil
            {
                if muscleLyk == 0
                {
                    cell.musLykCount.isHidden = true
                }else{
                    cell.musLykCount.isHidden = false
                    cell.musLykCount.tag = indexPath.row
                    cell.musLykCount.setTitle(String(describing: muscleLyk), for: .normal)
                    cell.musLykCount.addTarget(self, action: #selector(reactActn), for: .touchUpInside)
                }
            }else{
                cell.musLykCount.isHidden = true
            }
        }
        if let okLyk : Int = userArr1[indexPath.row].thumblikeCount
        {
            if okLyk != nil
            {
                if okLyk == 0
                {
                    cell.okLykCount.isHidden = true
                }else{
                    cell.okLykCount.isHidden = false
                    cell.okLykCount.tag = indexPath.row
                    cell.okLykCount.setTitle(String(describing: okLyk), for: .normal)
                    cell.okLykCount.addTarget(self, action: #selector(reactActn), for: .touchUpInside)
                }
            }else{
                cell.okLykCount.isHidden = true
            }
        }
        cell.muscleBtn.isSelected = false
        cell.okBtn.isSelected = false
        if let muscle = self.userArr1[indexPath.row].muscleLikes
        {
            if muscle.isactive == true
            {
                cell.muscleBtn.isSelected = true
            }
        }
        if let thumb = self.userArr1[indexPath.row].thumbLikes
        {
            if thumb.isactive == true
            {
                cell.okBtn.isSelected = true
            }
        }
        
        cell.statusLbl.text = ""
        if let status = self.userArr1[indexPath.row].statusDescription
        {
            cell.statusLbl.text = status
        }
        if let image = self.userArr1[indexPath.row].performanceImage
        {
            if image.count > 0 && image != "https://cdn4.vectorstock.com/i/1000x1000/14/53/cute-dinosaur-cartoon-vector-6241453.jpg" {
                
                cell.statusImg.sd_setImage(with:URL(string:image), placeholderImage: UIImage(named: "campost"))
                
                cell.imgHgt.constant = 150
                cell.zoomImgBtn.tag = indexPath.row
                cell.zoomImgBtn.addTarget(self, action: #selector(zoomImg(cell: )), for: .touchUpInside)
                
                
            }else
            {
                cell.imgHgt.constant = 0
            }
            
        }else
        {
            cell.imgHgt.constant = 0
        }
        
        if cell.imgHgt.constant == 0 && cell.statusLbl.text == "" {
            cell.statusLblTop.constant = 0
        }else
        {
            cell.statusLblTop.constant = 15
        }
        
        // cell.statusLblTop.constant = 200
        //  cell.imgHgt.constant = 200
        cell.layoutIfNeeded()
        cell.contentView.layoutIfNeeded()
        
        cell.cosmo()
        if AppUtils.AppDelegate().userId == self.userArr1[indexPath.row].user?._id
        {
            if self.userArr1[indexPath.row].shareWithFriends == true
            {
            cell.shareImgBtn.isHidden = false
            }
        }else{
          
            cell.shareImgBtn.isHidden = true
        }
        
        if let count = self.userArr1[indexPath.row].commentCount
        {
            if count == 0
            {
             cell.commentCountBtn.setTitle("", for: .normal)
                
            }else{
            cell.commentCountBtn.setTitle(String(describing: count), for: .normal)
                
            }
        }
        if let isComment = self.userArr1[indexPath.row].isCommented
        {
            if isComment.count > 0
            {
             cell.commentImgBtn.setImage(UIImage(named: "speech-bubble"), for: .normal)
                
            }else{
            cell.commentImgBtn.setImage(UIImage(named: "speechBubble"), for: .normal)
                
            }
        }
  
        return cell
    }
    @objc private  func  reactActn(sender : UIButton)
    {
        let vc = AppUtils.Controllers.reactType.get() as! ReactionsViewController
        vc.perfId = self.userArr1[sender.tag].id!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let vc = AppUtils.Controllers.performanceDetailsVC.get() as! PerformanceDetailsViewController
        //        vc.friendsDetail = self.transferdata[indexPath.row]
        //        // vc.fromFriendPage = true
        //        vc.userIdStr = self.transferdata[indexPath.row].user?._id
        //        vc.perfomanceIDStr = self.transferdata[indexPath.row]._id
        
        let vc = AppUtils.Controllers.comment.get() as! AddCommentViewController
        vc.performanceId = self.transferdata[indexPath.row]._id
        vc.friendsData = self.userArr1[indexPath.row]
        vc.transferData = self.transferdata[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK:- GET API DEFINITION
    func  getMyFriendApi() -> Void {
        
        let url : String = "\(Constant.basicApi)/getFriendsTimeline/\(AppUtils.AppDelegate().userId)"
        Service.sharedInstance.getRequest(Url: url, modalName: MyFriendModal.self, completion:{
            (response,Error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1
                {
                    self.transferdata.removeAll()
                    self.userArr1.removeAll()
                    if response?.Friend_Timeline?.count == 0{
                        self.messageLblOutlet.isHidden = false
                    }
                    else{
                        
                        
                        for item in (response?.Friend_Timeline)!
                        {
                            self.messageLblOutlet.isHidden = true
                            let modal = FriendInfoViewModal(FriendsInfoModal: item)
                            
                            self.transferdata.append(item)
                            self.userArr1.append(modal)
                        }
                        //  print(self.userArr1,"arr123")
                        self.myFriendsTableView.reloadData()
                    }
                }
            }
        })
    }
}
extension Date {
    func timeAgoDisplay() -> String {
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff)" + "secagoKey".localized()
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff)" + "minagoKey".localized()
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            if diff > 1
            {
                return "\(diff)" + "hrsagoKey".localized()
            }else{
                return "\(diff)" + "hragoKey".localized()
            }
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            if diff > 1
            {
                return "\(diff)" + "daysagoKey".localized()
            }
            else{
                return "\(diff)" + "dayagoKey".localized()
            }
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        if diff > 1
        {
            return "\(diff)" + "weeksagoKey".localized()
        }else{
            return "\(diff)" + "weekagoKey".localized()
        }
    }
}

extension MyFriendsViewController:MyFriendsTableViewCellDelegate{
    func profileTaped(cellTag:Int) {
        let vc = AppUtils.Controllers.statsVC.get() as! StatsViewController
        vc.fromFriendPage = true
        if let user = self.userArr1[cellTag].user
        {
            if let useriD = user._id
            {
                vc.userId = useriD as NSString
                vc.userName = user.username as! NSString
            }else
            {
                //                vc.userId = ""
                //                vc.userName = ""
                
                AppUtils.showToast(message: "Track_016".localized())
                
                return
            }
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func muscleTaped(cellTag:Int)
    {
        if let muscle = transferdata[cellTag].musclelikes
        {
            self.toggleLikeStatus(likeID: muscle._id, isForMuscle: true, index: cellTag)
        }else
        {
            self.muscleLikeTapped(performaceId:transferdata[cellTag]._id!, cellTag : cellTag)
        }
    }
    func okTaped(cellTag:Int)
    {
        if let thumb = transferdata[cellTag].thumblikes
        {
            self.toggleLikeStatus(likeID: thumb._id, isForMuscle: false, index: cellTag)
        }else
        {
            self.thumbLikeTapped(performaceId:transferdata[cellTag]._id!, cellTag : cellTag)
        }
    }
    
    func shareTaped(cellTag:Int)
    {
        //BASEURL/sharePost/performanceId
        
        let items = [URL(string: "\(Constant.basicApi)/sharePost/\(transferdata[cellTag]._id!)" )!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
}

extension MyFriendsViewController
{
    
    @objc func zoomImg(cell: UIButton)
    {
        var images = [URL]()
        
        images.append(URL(string: self.userArr1[cell.tag].performanceImage!)!)
        
        Utils.imageTapped(index: cell.tag, imageUrls: images, con: self)
    }
    
    
    
    func muscleLikeTapped(performaceId : String, cellTag : Int)
    {
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/likePerformance"
        let dict:[String:Any] = ["userWhoLiked": AppUtils.AppDelegate().userId,
                                 "performance": performaceId,
                                 "likeType" : 8001]
        Service.sharedInstance.postRequestForSearch(Url:url,modalName: MuscleLikeResponse.self , parameter: dict as [String:Any]) { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1{
                    self.transferdata[cellTag].musclelikes = response?.LikeCreated
                    self.userArr1[cellTag].muscleLikes = response?.LikeCreated
                    
                    self.transferdata[cellTag].musclelikeCount = 1
                    self.userArr1[cellTag].musclelikeCount = 1
                    
                    
                    self.myFriendsTableView.reloadData()
                }
            }
        }
        
        
    }
    
    func thumbLikeTapped(performaceId : String, cellTag : Int)
    {
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/likePerformance"
        let dict:[String:Any] = ["userWhoLiked": AppUtils.AppDelegate().userId,
                                 "performance": performaceId,
                                 "likeType" : 8002]
        Service.sharedInstance.postRequestForSearch(Url:url,modalName: ThumbLikeResponse.self , parameter: dict as [String:Any]) { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1{
                    self.transferdata[cellTag].thumblikes = response?.LikeCreated
                    self.userArr1[cellTag].thumbLikes = response?.LikeCreated
                    self.transferdata[cellTag].thumblikeCount = 1
                    self.userArr1[cellTag].thumblikeCount = 1
                    self.myFriendsTableView.reloadData()
                }
            }
        }
    }
    
    
    func toggleLikeStatus(likeID : String, isForMuscle : Bool, index : Int)
    {
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/updateLikeStatus"
        let dict:[String:Any] = ["likeId": likeID]
        Service.sharedInstance.postRequestForSearch(Url:url,modalName: ToggleStatusResponse.self , parameter: dict as [String:Any]) { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1{
                    
                    var thumbs = 0
                    if let thumbCount = self.transferdata[index].thumblikeCount
                    {
                        thumbs = thumbCount
                    }
                    var muscles = 0
                    if let muscleCount = self.transferdata[index].musclelikeCount
                    {
                        muscles = muscleCount
                    }
                    
                    if isForMuscle {
                        self.userArr1[index].muscleLikes?.isactive = response?.isactive?.boolValue
                        self.transferdata[index].musclelikes?.isactive = response?.isactive?.boolValue
                        if response?.isactive == 0
                        {
                            
                            self.userArr1[index].musclelikeCount = muscles - 1
                            self.transferdata[index].musclelikeCount = muscles - 1
                            
                            
                            
                        }else
                        {
                            self.userArr1[index].musclelikeCount = muscles + 1
                            self.transferdata[index].musclelikeCount = muscles + 1
                        }
                        
                        
                        
                    }else
                    {
                        self.userArr1[index].thumbLikes?.isactive = response?.isactive?.boolValue
                        self.transferdata[index].thumblikes?.isactive = response?.isactive?.boolValue
                        
                        if response?.isactive == 0
                        {
                            self.userArr1[index].thumblikeCount = thumbs - 1
                            self.transferdata[index].thumblikeCount = thumbs - 1
                            
                            
                            
                        }else
                        {
                            self.userArr1[index].thumblikeCount = thumbs + 1
                            self.transferdata[index].thumblikeCount = thumbs + 1
                        }
                        
                        
                        
                    }
                    
                    self.myFriendsTableView.reloadData()
                }
            }
        }
        
        
    }
    
    
    
}



extension Int {
    var boolValue: Bool { return self != 0 }
}
