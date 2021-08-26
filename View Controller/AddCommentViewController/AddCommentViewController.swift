//
//  AddCommentViewController.swift
//  TrackApp
//
//  Created by sanganan on 10/6/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import UIKit
import NextGrowingTextView

class AddCommentViewController: UIViewController {
    
    //Variables
    var durationVar : Date = Date()
    var now : String = String()
    var performanceId : String? = ""
    var friendsData : FriendInfoViewModal?
    var transferData : FriendInfoModal?
    var commentArr = [CommentsModal]()
    var perfDetails : FriendInfoViewModal?
    var sendDtaToPerf : FriendInfoModal?
    
    var isFrmNotification : Bool? = false
    
    
    
    //Outlets
    @IBOutlet weak var AddCommentTV: UITableView!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var inputContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var growingTextView: NextGrowingTextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFrmNotification == true{
            performanceFrmNotification()
        }
        
        self.commonNavigationBar(title: "commentsKey".localized(), controller: AppUtils.Controllers.comment, badgeCount: "0")
        inputContainerView.backgroundColor = Constant.Color.navColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        self.growingTextView.layer.cornerRadius = 8
        self.growingTextView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.growingTextView.placeholderAttributedText = NSAttributedString(
            string: "addCommentKey".localized(),
            attributes: [
                .font: self.growingTextView.textView.font!,
                .foregroundColor: UIColor.gray
            ]
        )
        
        AddCommentTV.register(UINib(nibName: "MyFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "MyFriendsTableViewCell")
        AddCommentTV.register(UINib(nibName: "AddCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "AddCommentTableViewCell")
        self.AddCommentTV.dataSource = self
        self.AddCommentTV.delegate = self
        
        inputContainerView.isHidden = true
        growingTextView.isHidden = true
        sendBtn.isHidden = true
        chatBtn.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        
        getCommentsApi()
        inputContainerView.isHidden = false
        growingTextView.isHidden = false
        sendBtn.isHidden = false
     //   growingTextView.becomeFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func chatBtnActn(_ sender: Any) {
        
//        inputContainerView.isHidden = false
//        growingTextView.isHidden = false
//        sendBtn.isHidden = false
//        //  chatBtn.isHidden = true
//        growingTextView.becomeFirstResponder()
    }
    
    @IBAction func handleSendButton(_ sender: AnyObject) {
        if self.growingTextView.textView.text.trimmingCharacters(in: .whitespaces) == ""
        {
            return
        }else{
            addComment()
            self.growingTextView.textView.text = ""
            self.view.endEditing(true)
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                //key point 0,
                self.inputContainerViewBottom.constant =  0
                //textViewBottomConstraint.constant = keyboardHeight
                UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        }
    }
    @objc func keyboardWillShow(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if var keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                
                if #available(iOS 11.0, *) {
                    let bottomInset = view.safeAreaInsets.bottom
                    keyboardHeight -= bottomInset
                }
                
                
                self.inputContainerViewBottom.constant = keyboardHeight
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    
    
}
extension AddCommentViewController: UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }else{
            return commentArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell : MyFriendsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsTableViewCell", for: indexPath) as! MyFriendsTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.cell = indexPath.row
            cell.shareBtn.isHidden = true
            //      if self.isFrmNotification == false{
            
            if let name = friendsData?.user?.username
            {
                cell.userName.text = name
                
            }else
            {
                cell.userName.text =  ""
            }
            if let image = friendsData?.user?.userImage
            {
                cell.profilePic.sd_setImage(with: URL(string: image),placeholderImage: UIImage(named: "avatar1"))
                
            }else
            {
                cell.profilePic.image =  UIImage(named: "avatar1")
            }
            if let tym = friendsData?.createdTime
            {
                durationVar = AppUtils.dateToTimestamp(date: tym) as Date
                now = durationVar.timeAgoDisplay()
                cell.timeLabel.text = "AddedperformanceKey".localized() + String(describing: now)
            }
            
            cell.timeImg.image = UIImage(named: "watch")
            if let duration = friendsData?.duration
            {
                cell.durationLbl.text = String(describing: duration) + "minsKey".localized()
            }
            cell.locationImg.image = UIImage(named: "map")
            cell.addressLbl.text = friendsData?.location
            cell.fishArr = friendsData?.fishName
            cell.rate = friendsData?.rate
            if let muscleLyk : Int = friendsData?.musclelikeCount
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
            if let okLyk : Int = friendsData?.thumblikeCount
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
            if let muscle = friendsData?.muscleLikes
            {
                if muscle.isactive == true
                {
                    cell.muscleBtn.isSelected = true
                }
            }
            if let thumb = friendsData?.thumbLikes
            {
                if thumb.isactive == true
                {
                    cell.okBtn.isSelected = true
                }
            }
            
            cell.statusLbl.text = ""
            if let status = friendsData?.statusDescription
            {
                cell.statusLbl.text = status
            }
            if let image = friendsData?.performanceImage
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
            
            if let id = self.friendsData?.user?._id
            {
                
                if AppUtils.AppDelegate().userId == id
                {
                    if self.friendsData?.shareWithFriends == true
                    {
                    cell.shareImgBtn.isHidden = false
                    }else{
                        cell.shareImgBtn.isHidden = true
                    }
                }else{
                    cell.shareImgBtn.isHidden = true
                }
            }
            if let count = self.friendsData?.commentCount
            {
                if count == 0
                {
                 cell.commentCountBtn.setTitle("", for: .normal)
                    
                }else{
                cell.commentCountBtn.setTitle(String(describing: count), for: .normal)
                    
                }
            }
            if let isComment = self.friendsData?.isCommented
            {
                if isComment.count > 0
                {
                 cell.commentImgBtn.setImage(UIImage(named: "speech-bubble"), for: .normal)
                    
                }else{
                cell.commentImgBtn.setImage(UIImage(named: "speechBubble"), for: .normal)
                    
                }
            }
            
            //     }
            
            //            if isFrmNotification == true{
            //                if let name = perfDetails?.user?.username
            //                    {
            //                        cell.userName.text = name
            //
            //                    }else
            //                    {
            //                        cell.userName.text =  ""
            //                    }
            //                if let image = perfDetails?.user?.userImage
            //                    {
            //                        cell.profilePic.sd_setImage(with: URL(string: image),placeholderImage: UIImage(named: "avatar1"))
            //
            //                    }else
            //                    {
            //                        cell.profilePic.image =  UIImage(named: "avatar1")
            //                    }
            //
            ////                    if let tym = perfDetails!.createdTime{
            ////                    durationVar = AppUtils.dateToTimestamp(date: tym) as Date
            ////                    now = durationVar.timeAgoDisplay()
            ////                    cell.timeLabel.text = "AddedperformanceKey".localized() + String(describing: now)
            ////                    }
            //                    cell.timeImg.image = UIImage(named: "watch")
            //                    if let duration = perfDetails?.duration
            //                    {
            //                    cell.durationLbl.text = String(describing: duration) + "minsKey".localized()
            //                    }
            //                    cell.locationImg.image = UIImage(named: "map")
            //                    cell.addressLbl.text = perfDetails?.location
            //                    cell.fishArr = perfDetails?.fishName
            //                    cell.rate = perfDetails?.rate
            //                    if let muscleLyk : Int = perfDetails?.musclelikeCount
            //                    {
            //                        if muscleLyk != nil
            //                        {
            //                            if muscleLyk == 0
            //                            {
            //                               cell.musLykCount.isHidden = true
            //                            }else{
            //                            cell.musLykCount.isHidden = false
            //                            cell.musLykCount.tag = indexPath.row
            //                            cell.musLykCount.setTitle(String(describing: muscleLyk), for: .normal)
            //                            cell.musLykCount.addTarget(self, action: #selector(reactActn), for: .touchUpInside)
            //                            }
            //                        }else{
            //                            cell.musLykCount.isHidden = true
            //                        }
            //                    }
            //                    if let okLyk : Int = perfDetails?.thumblikeCount
            //                    {
            //                        if okLyk != nil
            //                        {
            //                            if okLyk == 0
            //                            {
            //                              cell.okLykCount.isHidden = true
            //                            }else{
            //                            cell.okLykCount.isHidden = false
            //                            cell.okLykCount.tag = indexPath.row
            //                            cell.okLykCount.setTitle(String(describing: okLyk), for: .normal)
            //                            cell.okLykCount.addTarget(self, action: #selector(reactActn), for: .touchUpInside)
            //                            }
            //                        }else{
            //                            cell.okLykCount.isHidden = true
            //                        }
            //                    }
            //                    cell.muscleBtn.isSelected = false
            //                    cell.okBtn.isSelected = false
            //                    if let muscle = perfDetails?.muscleLikes
            //                    {
            //                        if muscle.isactive == true
            //                        {
            //                            cell.muscleBtn.isSelected = true
            //                        }
            //                    }
            //                    if let thumb = friendsData?.thumbLikes
            //                    {
            //                        if thumb.isactive == true
            //                        {
            //                            cell.okBtn.isSelected = true
            //                        }
            //                    }
            //
            //                    cell.statusLbl.text = ""
            //                    if let status = perfDetails?.statusDescription
            //                    {
            //                        cell.statusLbl.text = status
            //                    }
            //                    if let image = perfDetails?.performanceImage
            //                    {
            //                        if image.count > 0 && image != "https://cdn4.vectorstock.com/i/1000x1000/14/53/cute-dinosaur-cartoon-vector-6241453.jpg" {
            //
            //                            cell.statusImg.sd_setImage(with:URL(string:image), placeholderImage: UIImage(named: "campost"))
            //
            //                            cell.imgHgt.constant = 150
            //                            cell.zoomImgBtn.tag = indexPath.row
            //                            cell.zoomImgBtn.addTarget(self, action: #selector(zoomImg(cell: )), for: .touchUpInside)
            //
            //
            //                        }else
            //                        {
            //                            cell.imgHgt.constant = 0
            //                        }
            //
            //                    }else
            //                    {
            //                        cell.imgHgt.constant = 0
            //                    }
            //
            //                    if cell.imgHgt.constant == 0 && cell.statusLbl.text == "" {
            //                        cell.statusLblTop.constant = 0
            //                    }else
            //                    {
            //                        cell.statusLblTop.constant = 15
            //                    }
            //
            //                   // cell.statusLblTop.constant = 200
            //                  //  cell.imgHgt.constant = 200
            //                    cell.layoutIfNeeded()
            //                    cell.contentView.layoutIfNeeded()
            //
            //                    cell.cosmo()
            //                    }
            cell.fullPerformanceDetails.addTarget(self, action: #selector(fullPerformanceDet), for: .touchUpInside)
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentTableViewCell", for: indexPath) as! AddCommentTableViewCell
            
            cell.commentTxtVw.isUserInteractionEnabled = false
            
            if let tym = self.commentArr[indexPath.row].createdTime
            {
                now = AppUtils.timestampToDate(timeStamp: Double(tym))
            }
            
            
            
            if let image = self.commentArr[indexPath.row].user!.userImage
            {
                cell.profilePic.sd_setImage(with: URL(string: image),placeholderImage: UIImage(named: "avatar1"))
                
            }else
            {
                cell.profilePic.image =  UIImage(named: "avatar1")
            }
            if let name = self.commentArr[indexPath.row].user?.username
            {
                cell.nameLbl.text = name + " • " + "\(now)"
                
            }else
            {
                cell.nameLbl.text =  "" + " • " + "\(now)"
            }
            
            
            //    cell.timeLbl.text = now
            cell.commentTxtVw.text = self.commentArr[indexPath.row].comment
            return cell
        }
    }
    
    @objc private  func  reactActn(sender : UIButton)
    {
        let vc = AppUtils.Controllers.reactType.get() as! ReactionsViewController
        vc.perfId = (self.friendsData?.id!)!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func fullPerformanceDet()
    {
        let vc = AppUtils.Controllers.performanceDetailsVC.get() as! PerformanceDetailsViewController
        //        if isFrmNotification == true
        //        {
        //        }
        vc.friendsDetail =  transferData
        vc.perfomanceIDStr = performanceId
        vc.userIdStr = transferData?.user?._id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension AddCommentViewController{
    func addComment()
    {
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/addComment"
        let dict:[String:Any] = ["user": AppUtils.AppDelegate().userId,
                                 "performance": performanceId!,
                                 "comment": growingTextView.textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
        
        Service.sharedInstance.postRequest(Url:url,modalName: ForgetPasswordModal.self, parameter: dict as [String:Any]) { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if let res = response?.Success
                {
                    if res == 1{
                        
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CommentCount"), object: nil)
                        
                    //    AppUtils.showToast(message: (response?.Message)!)
                        if let count = self.friendsData?.commentCount
                                                    {
                                                     self.friendsData?.commentCount = count + 1;
                                                     
                                                    }else
                                         {
                                             self.friendsData?.commentCount = 1
                                         }
                        
                        let modal = isCommentedModal(_id: "123")
                        self.friendsData?.isCommented?.append(modal)
                        self.AddCommentTV.reloadData()
                        
                    }else
                    {
                        AppUtils.showToast(message: (response?.Message)!)
                    }
                    
                    
                 
                    
                    
                    
                    
                    self.inputContainerView.isHidden = false
                    self.growingTextView.isHidden = false
                    self.sendBtn.isHidden = false
               //     self.chatBtn.isHidden = false
                    self.getCommentsApi()
                }
                
            }
        }
    }
    
    func getCommentsApi() {
     //   Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/getComments/\(self.performanceId!)"
        
        Service.sharedInstance.getRequest(Url:url,modalName:GetCommentsModal.self,completion: { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1
                {
                    self.commentArr = (response?.Comments)!
                }
                self.AddCommentTV.reloadData()
            }
        })
    }
}
extension AddCommentViewController: MyFriendsTableViewCellDelegate{
    func profileTaped(cellTag: Int) {
        let vc = AppUtils.Controllers.statsVC.get() as! StatsViewController
        vc.fromFriendPage = true
        if let user = self.friendsData?.user
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
    
    func shareTaped(cellTag: Int) {
        let items = [URL(string: "\(Constant.basicApi)/sharePost/\(performanceId!)" )!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    func muscleTaped(cellTag:Int)
    {
        if let muscle = transferData?.musclelikes
        {
            self.toggleLikeStatus(likeID: muscle._id, isForMuscle: true, index: cellTag)
        }else
        {
            self.muscleLikeTapped(performaceId:(transferData?._id!)!, cellTag : cellTag)
        }
    }
    func okTaped(cellTag:Int)
    {
        if let thumb = transferData?.thumblikes
        {
            self.toggleLikeStatus(likeID: thumb._id, isForMuscle: false, index: cellTag)
        }else
        {
            self.thumbLikeTapped(performaceId:(transferData?._id!)!, cellTag : cellTag)
        }
    }
    
    
    @objc func zoomImg(cell: UIButton)
    {
        var images = [URL]()
        
        images.append(URL(string: (self.friendsData?.performanceImage!)!)!)
        
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
                    self.transferData?.musclelikes = response?.LikeCreated
                    self.friendsData?.muscleLikes = response?.LikeCreated
                    
                    self.transferData?.musclelikeCount = 1
                    self.friendsData?.musclelikeCount = 1
                    
                    
                    self.AddCommentTV.reloadData()
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
                    self.transferData?.thumblikes = response?.LikeCreated
                    self.friendsData?.thumbLikes = response?.LikeCreated
                    self.transferData?.thumblikeCount = 1
                    self.friendsData?.thumblikeCount = 1
                    self.AddCommentTV.reloadData()
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
                    if let thumbCount = self.transferData?.thumblikeCount
                    {
                        thumbs = thumbCount
                    }
                    var muscles = 0
                    if let muscleCount = self.transferData?.musclelikeCount
                    {
                        muscles = muscleCount
                    }
                    
                    if isForMuscle {
                        self.friendsData?.muscleLikes?.isactive = response?.isactive?.boolValue
                        self.transferData?.musclelikes?.isactive = response?.isactive?.boolValue
                        if response?.isactive == 0
                        {
                            
                            self.friendsData?.musclelikeCount = muscles - 1
                            self.transferData?.musclelikeCount = muscles - 1
                            
                            
                            
                        }else
                        {
                            self.friendsData?.musclelikeCount = muscles + 1
                            self.transferData?.musclelikeCount = muscles + 1
                        }
                        
                        
                        
                    }else
                    {
                        self.friendsData?.thumbLikes?.isactive = response?.isactive?.boolValue
                        self.transferData?.thumblikes?.isactive = response?.isactive?.boolValue
                        
                        if response?.isactive == 0
                        {
                            self.friendsData?.thumblikeCount = thumbs - 1
                            self.transferData?.thumblikeCount = thumbs - 1
                            
                            
                            
                        }else
                        {
                            self.friendsData?.thumblikeCount = thumbs + 1
                            self.transferData?.thumblikeCount = thumbs + 1
                        }
                        
                        
                        
                    }
                    
                    self.AddCommentTV.reloadData()
                }
            }
        }
        
        
    }
    
    
    
}
extension Date {
    func timeAgoDisplay1() -> String {
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff)" + "secKey".localized()
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff)" + "minKey".localized()
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            if diff > 1
            {
                return "\(diff)" + "hrsKey".localized()
            }else{
                return "\(diff)" + "hrKey".localized()
            }
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            if diff > 1
            {
                return "\(diff)" + "daysKey".localized()
            }
            else{
                return "\(diff)" + "dayKey".localized()
            }
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        if diff > 1
        {
            return "\(diff)" + "weeksKey".localized()
        }else{
            return "\(diff)" + "weekKey".localized()
        }
    }
}
extension AddCommentViewController
{
    func performanceFrmNotification()
    {
        
          Utils.startLoading(self.view)
        
        
        let url:String = Constant.basicApi + "/getPerfomanceDetails"
        
        let dict:[String:Any] = ["performanceId": performanceId!,
                                 "userWhoIsChecking": AppUtils.AppDelegate().userId,
        ]
        Service.sharedInstance.postRequestForSearch(Url:url,modalName: MyFriendModal.self , parameter: dict as [String:Any]) { (response, error) in
            DispatchQueue.main.async {
           //     Utils.stopLoading()
                if response?.Success == 1
                {
                    self.friendsData = FriendInfoViewModal(FriendsInfoModal: (response?.Details)!)
                    self.transferData = response?.Details
                    self.performanceId = response?.Details?._id
                    
                }
                
                self.AddCommentTV.reloadData()
            }
        }
        
    }
}
