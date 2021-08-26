//
//  PerformanceDetailsViewController.swift
//  TrackApp
//
//  Created by sanganan on 1/22/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import UIKit
import AVFoundation
class detailsModal : NSObject {
    
    let duration: String
    let userPartner: String
    let positions: [positionsModal]
    let satisfactionRating: Int
    let experienceRating: Int
    let shareWithFriends:Bool
    let _id: String
    //    let userId: String
    let userLocation: String
    let rate: String
    let asanaName: String
    let extra: String
    let satisfaction: String
    let datewise:String
    
    init(dur:String,userP:String,positions: [positionsModal],satisfactionRating: Int,experienceRating: Int,shareWithFriends:Bool,_id: String,userLocation: String,rate: String,asanaName: String,extra: String,satisfaction: String,datewise: String){
        self.duration = dur
        self.userPartner = userP
        //self.userId = _id
        self.positions = positions
        self.satisfactionRating = satisfactionRating
        self.experienceRating = experienceRating
        self.shareWithFriends = shareWithFriends
        self._id = _id
        self.userLocation = userLocation
        self.rate = rate
        self.asanaName = asanaName
        self.extra = extra
        self.satisfaction = satisfaction
        self.datewise = datewise
    }
    override init()
    {
        self.duration = ""
        self.userPartner = ""
        //self.userId = _id
        self.positions = [positionsModal]()
        self.satisfactionRating = 0
        self.experienceRating = 0
        self.shareWithFriends = false
        self._id = ""
        self.userLocation = ""
        self.rate = ""
        self.asanaName = ""
        self.extra = ""
        self.satisfaction = ""
        self.datewise = ""
    }
}

class PerformanceDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,PerformanceDetailsCellDelegate
{
    func zoomImgP() {
        let images : [URL] = [URL(string: self.detailData.statusImage)!]
     
        Utils.imageTapped(index: 0, imageUrls: images, con: self)
    }
    
    
    var perfDetails : performancelistModal?
    var perfomanceIDStr : String? = ""
    var userIdStr : String? = ""
    var friendsDetail: FriendInfoModal?
    //  var detailData:detailsModal?
    var detailData : PerformanceHelperModal = PerformanceHelperModal()
    
    var dataArr   = [String]()
    var dataR  = [String]()
    var statstiimeModal:GetUserStatsViewModal1?
    //var fromFriendPage:Bool = false
    @IBOutlet weak var perfDetailsTV: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commonNavigationBar(title: "PerformanceDetailsKey".localized(), controller: AppUtils.Controllers.performanceDetailsVC,badgeCount: "0")
        //  self.view.backgroundColor = Constant.Color.backGroundColor
        // detailData = detailsModal.init()
        if perfDetails != nil{
            self.perf()
        }else
        {
            self.getPerformanceDetailsFromServer()
        }
        
        perfDetailsTV.register(UINib(nibName: "AddYourPerformanceTableViewCell", bundle: nil), forCellReuseIdentifier: "AddYourPerformanceTableViewCell")
        perfDetailsTV.register(UINib(nibName: "AddYourPerformanceTableViewCell2", bundle: nil), forCellReuseIdentifier: "AddYourPerformanceTableViewCell2")
        perfDetailsTV.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        
        
        //    print(perfDetails ,"data")
    }
    override func viewWillAppear(_ animated: Bool) {
        //        if AppUtils.getStringForKey(key: Constant.isPaid) == "1"{
        //            self.dataArr = ClassConstant.perfarrDetail
        //        }
        //        else{
        //            self.dataArr = ClassConstant.perfarrPaid
        //        }
        
        self.dataArr = ClassConstant.perfarrDetail
        
    }
    
    func getPerformanceDetailsFromServer()
    {
        
        Utils.startLoading(self.view)
        
        
        let url:String = Constant.basicApi + "/performanceDetailss/\(self.perfomanceIDStr!)"
        
        Service.sharedInstance.getRequest(Url:url, modalName: dateWisePerfrmnceModal.self , completion: { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1
                {
                    self.statstiimeModal = GetUserStatsViewModal1(perfrmncelistmodal: response!)
                    
                    if self.statstiimeModal!.perfrmncelist.count > 0 {
                        self.perfDetails = self.statstiimeModal!.perfrmncelist[0]
                        print(self.perfDetails ,"dataPerf")
                    }
                    self.perf()
                    
                    //  self.perfDetailsTV.reloadData()
                    
                    //                        for item in self.statstiimeModal!.perfrmncelist{
                    //                            self.perfomanceArray.append(item)
                    //                        }
                    
                }
                
            }
        })
        
    }
    
    
    func deletePerformaceAPI()
    {
        
        Utils.startLoading(self.view)
        
        let url:String = Constant.basicApi + "/deletePerformance/\(self.perfomanceIDStr!)"
        
        Service.sharedInstance.getRequest(Url:url, modalName: DeletePerformanceModal.self , completion: { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1
                {
                    
                    
                    AppUtils.showToast(message: (response?.Message)!)
                    
                    var viwArray = self.navigationController?.viewControllers as! [UIViewController]

                    let count = viwArray.count


                    viwArray.remove(at: count - 2)

                    self.navigationController?.viewControllers = viwArray
                    //NSNotification.Name(rawValue:"refreshpage")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshpage"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                    
                    
                }else{
                    AppUtils.showToast(message: (response?.Message)!)
                }
            }
        })
        
    }
    
    
    @objc func deletePerformance()
    {
        let alertController = UIAlertController(title: "", message: "deletePerformanceKey".localized(), preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "YesKey".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.deletePerformaceAPI()
        }
        
        let cancelAction = UIAlertAction(title: "NoKey".localized(), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancelled")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func perf()
    {
        //        if fromFriendPage == false{
        
        
        //        self.title = "PerformanceDetailsKey".localized().lowercased().capitalizingFirstLetter()
        //                     navigationController?.navigationBar.barTintColor = Constant.Color.navColor
        //                     navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 25)!]
        //                     navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //                     let button1 = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(backButton))
        //                     self.navigationItem.leftBarButtonItem  = button1
        //                     navigationItem.leftBarButtonItem?.tintColor = .white
        
        
        

        if AppUtils.AppDelegate().userId == self.userIdStr
        {
            
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "delete_performance.png"), for: .normal)
            button.addTarget(self, action: #selector(deletePerformance), for: .touchUpInside)
         //   button2.frame = CGRect(x: 0.0, y: 0.0, width: 35, height: 35)
            
            
            button.widthAnchor.constraint(equalToConstant: 22).isActive = true
            button.heightAnchor.constraint(equalToConstant: 22).isActive = true
            
            
            let barButtonItem = UIBarButtonItem(customView: button)
            
            
            
            navigationItem.rightBarButtonItem?.tintColor = .white
            
            
            if self.perfDetails?.shareWithFriends == true || self.friendsDetail?.shareWithFriends == true
            {
                
                let button2 = UIButton(type: .custom)
                button2.setImage(UIImage(named: "share_pic-1"), for: .normal)
                button2.addTarget(self, action: #selector(shareFriends), for: .touchUpInside)
           //     button2.frame = CGRect(x: 0.0, y: 0.0, width: 35, height: 35)
                
                button2.widthAnchor.constraint(equalToConstant: 22).isActive = true
                button2.heightAnchor.constraint(equalToConstant: 22).isActive = true
                
                let barButtonItem2 = UIBarButtonItem(customView: button2)
                self.navigationItem.rightBarButtonItems  = [barButtonItem2, barButtonItem]
                
            }else
            {
                self.navigationItem.rightBarButtonItem = barButtonItem


            }
            
            
            
                        
       }
        
        
        var dur = "0minKey".localized()
        if let dur1 = perfDetails?.duration{
            dur =  "\(dur1)" + "minsKey".localized()
        }
        
        
        var date = ""
        
        switch perfDetails?.createdTime {
        case .string(let text):
            print(text)
            date = AppUtils.timestampToDate(timeStamp: Double(text)!)
            
        case .float(let num):
            print(num)
            
            date = AppUtils.timestampToDate(timeStamp: Double(num))
            
            
        case .int(let inte):
            date = AppUtils.timestampToDate(timeStamp: Double(inte))
            
            print(inte)
        case .none:
            date = ""
        }
        
        
        
        var userP = ""
        
        
        
        self.detailData.dateTimeStamp = date
        self.detailData.duration = dur
        if let status = self.perfDetails?.statusDescription
        {
            self.detailData.status = status
        }
        if let image = self.perfDetails?.performanceImage
        {
            self.detailData.statusImage = image
        }
        
        if let fish = perfDetails?.fishName
        {
            //self.
            var nameArray = [String]()
            for item in fish {
                nameArray.append(item.fishName!)
            }
            self.detailData.fishNames = nameArray
        }
        
        if let location = perfDetails?.userLocation?.locationName {
            self.detailData.location = location
        }
        if perfDetails?.lengthInString == ""{
            if let length = perfDetails?.fishLength
                   {
                       self.detailData.lengthName = length.fishLength!
                   }
            
        }else{
            if let length = perfDetails?.lengthInString
            {
                self.detailData.lengthName = length
            }
        }
       if perfDetails?.weightInString == ""{
        if let wgt = perfDetails?.fishWeight
        {
            self.detailData.wgtName = wgt.fishWeight!
        }
       }else{
        if let wgt = perfDetails?.weightInString
               {
                   self.detailData.wgtName = wgt
               }
        }
        if let bait = perfDetails?.baitName
        {
            self.detailData.baitName = bait.baitName!
        }
        
        if let rod = perfDetails?.rodName
        {
            self.detailData.rodName = rod.rodName!
        }
        if perfDetails?.depthInString == ""
        {
        if let depth = perfDetails?.waterDepth
        {
            self.detailData.waterDepName = depth.waterDepth!
        }
        }else{
            if let depth = perfDetails?.depthInString
            {
                self.detailData.waterDepName = depth
            }
        }
        
        if let license = self.perfDetails!.fishingLicence
        {
            self.detailData.licenseID = String(describing:license)
        }
        
        if let rate = perfDetails?.experienceRating
        {
            self.detailData.experienceRate = String(describing: rate)
        }
        
        
        //          var rate = ""
        //                 if let data = perfDetails?.rate{
        //                     rate = "\(data.rate)"
        //                 }else{
        //                     rate = "0"
        //                 }
        //                     //var rate = friendsDetail?.rate?.rate
        //                     if rate == "0"{
        //                     rate = "No Rate"
        //                     }
        //                     var satisfaction = ""
        //                 if let data = perfDetails?.satisfaction{
        //                     satisfaction = "\(data.satisfaction)"
        //                 }else{
        //                     satisfaction = "0"
        //                 }
        //                     if satisfaction == "0"{
        //                     satisfaction = "No satisfaction"
        //                     }
        //
        //                 var asanaNa = ""
        //                 if let data = perfDetails?.asanaName{
        //                     asanaNa = "\(data.asanaName)"
        //                 }else{
        //                     asanaNa = "0"
        //                 }
        //
        //                     //var asanaNa = friendsDetail?.asanaName?.asanaName
        //                     if asanaNa == "0"{
        //                     asanaNa = "No asanas"
        //                     }
        //
        //                 var ext = ""
        //                 if let data = perfDetails?.extra{
        //                     ext = "\(data.extraName)"
        //                 }else{
        //                     ext = "0"
        //                 }
        //                     //var ext = friendsDetail?.extra?.extraName
        //                     if ext == "0"{
        //                     ext = "No extra"
        //                     }
        //            var locat = ""
        //                           if let loc = perfDetails?.userLocation?.locationName
        //                           {
        //                             locat = loc
        //                           }else
        //                           {
        //                               locat = "Delhi"
        //                           }
        //
        //
        //
        //        self.detailData = detailsModal(dur: dur, userP: userP, positions: perfDetails!.positions as! [positionsModal], satisfactionRating: (perfDetails?.satisfactionRating)!, experienceRating: (perfDetails?.experienceRating)!, shareWithFriends: (perfDetails?.shareWithFriends)!, _id: (perfDetails?._id)!, userLocation: locat, rate: rate, asanaName: asanaNa, extra: ext, satisfaction: satisfaction, datewise: AppUtils.timestampToDate(timeStamp: Double( (perfDetails?.createdTime)!)))
        //        }else{
        //
        //            var dur =  "0 min"
        
        //            if let dur1 = friendsDetail?.duration{
        //             dur =  "\(dur1) mins"
        //            }
        //                var date = AppUtils.timestampToDate(timeStamp: Double( (friendsDetail?.createdTime)!))
        //                var userP = ""
        //            for (i,item) in (friendsDetail?.userPartners!.enumerated())!{
        //                if (i == ((friendsDetail?.userPartners?.count)! - 1)){
        //                    userP += "\(item.name!)"
        //                    }else{
        //                        userP += "\(item.name!),"
        //                    }
        //                }
        //                if userP != ""{
        //                //userP = userP
        //                }else{
        //                   userP = "No partner"
        //                }
        //
        //                var swf = friendsDetail?.shareWithFriends
        //            var rate = ""
        //            if let data = friendsDetail?.rate{
        //                rate = "\(data.rate)"
        //            }else{
        //                rate = "0"
        //            }
        //                //var rate = friendsDetail?.rate?.rate
        //                if rate == "0"{
        //                rate = "No Rate"
        //                }
        //                var satisfaction = ""
        //            if let data = friendsDetail?.satisfaction{
        //                satisfaction = "\(data.satisfaction)"
        //            }else{
        //                satisfaction = "0"
        //            }
        //                if satisfaction == "0"{
        //                satisfaction = "No satisfaction"
        //                }
        //
        //            var asanaNa = ""
        //            if let data = friendsDetail?.asanaName{
        //                asanaNa = "\(data.asanaName)"
        //            }else{
        //                asanaNa = "0"
        //            }
        //
        //                //var asanaNa = friendsDetail?.asanaName?.asanaName
        //                if asanaNa == "0"{
        //                asanaNa = "No Asanas"
        //                }
        //
        //            var ext = ""
        //            if let data = friendsDetail?.extra{
        //                ext = "\(data.extraName)"
        //            }else{
        //                ext = "0"
        //            }
        //                //var ext = friendsDetail?.extra?.extraName
        //                if ext == "0"{
        //                ext = "No extra"
        //                }
        print(friendsDetail)
        //            self.detailData = detailsModal(dur: dur, userP: userP, positions: friendsDetail!.userPositions!, satisfactionRating: Int((friendsDetail?.satisfactionRating)!), experienceRating: Int((friendsDetail?.experienceRating)!), shareWithFriends: (friendsDetail?.shareWithFriends)!, _id: (friendsDetail?._id)!, userLocation: (friendsDetail?.userLocation?.locationName)!, rate: rate, asanaName: asanaNa, extra: ext, satisfaction: satisfaction, datewise: AppUtils.timestampToDate(timeStamp: Double( (friendsDetail?.createdTime)!)))
        //        }
        
        perfDetailsTV.dataSource = self
        perfDetailsTV.delegate = self
        perfDetailsTV.reloadData()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 110
        }else{
            
            if indexPath.section == 1 {
                
                switch indexPath.row {
                    
                case 0:
                    if detailData.dateTimeStamp == nil{
                        return 0
                    }
                    
                case 1:
                    if detailData.duration.count == 0{
                        return 0
                    }
                case 4:
                    //self.rightLbl.isHidden = false
                    // self.detailImagePOs(modal: modal.positions as! [positionsModal])
                    if detailData.lengthName.count == 0 {
                        return 0
                    }
                case 2:
                    if detailData.fishNames.count == 0{
                        return 0
                    }
                    
                case 5:
                    
                    if detailData.wgtName.count == 0 {
                        return 0
                    }
                case 6:
                    if detailData.baitName.count == 0{
                        return 0
                    }
                case 7:
                    if detailData.rodName.count == 0{
                        return 0
                    }
                case 8:
                    if detailData.waterDepName.count == 0{
                        return 0
                    }
                case 9:
                    if detailData.licenseID.count == 0{
                        return 0
                    }
                case 3:
                    if detailData.location.count == 0{
                        return 0
                    }
                default:
                    return UITableView.automaticDimension
                    
                }
                
                
                
            }
            
            
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1
        {
            return dataArr.count
        }else
        {
            if section == 0 {
                
                if let desc = self.perfDetails?.statusDescription
                {
                    if desc.count > 0 {
                        return 1
                    }
                }
                if let image = self.perfDetails?.performanceImage
                {
                    if image.count > 0 && image != "https://cdn4.vectorstock.com/i/1000x1000/14/53/cute-dinosaur-cartoon-vector-6241453.jpg" {
                        return 1
                    }
                }
                
                return 0
            }
            
            if section == 2 {
                if let rate = self.perfDetails?.experienceRating
                {
                    if rate == 0
                    {
                        return 0
                    }
                }
            }
            
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1
        {return 30}
        else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        //   footerView.backgroundColor = Constant.Color.backGroundColor
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //SECTION 0
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
            cell.selectionStyle = .none
            cell.postTxtView.isUserInteractionEnabled = false
            cell.postTxtView.placeholder = ""
            cell.postTxtView.text = detailData.status
            cell.cameraImgView.sd_setImage(with:URL(string:self.detailData.statusImage), placeholderImage: UIImage(named: "campost"))
            cell.zoomDelegate = self
            return cell
            
        }
        if indexPath.section == 1
        {
            let cell : AddYourPerformanceTableViewCell = perfDetailsTV.dequeueReusableCell(withIdentifier: "AddYourPerformanceTableViewCell", for: indexPath) as! AddYourPerformanceTableViewCell
            cell.selectionStyle = .none
            cell.whichCell = indexPath.row
            cell.collectionView.isHidden = true
            cell.topBtn.isHidden = true
            cell.rightLbl.isHidden = false
            cell.performanceLabel.isHidden = false
            //            if dataArr.count == ClassConstant.perfarrPaid.count{
            //                cell.detailPageUI(modal: detailData!, arr: self.dataArr as NSArray)
            //            }else{
            cell.detailPagePaidUI(modal: detailData, arr: self.dataArr as NSArray)
            //            }
            
            return cell
        }
        else         //SECTION 2
        {
            let cell : AddYourPerformanceTableViewCell2 = perfDetailsTV.dequeueReusableCell(withIdentifier: "AddYourPerformanceTableViewCell2", for: indexPath) as! AddYourPerformanceTableViewCell2
            cell.selectionStyle = .none
            //            cell.descLbl.isHidden = true
            //                       cell.heightCons.constant = 0
            //            cell.label.text = ClassConstant.ratingArr[indexPath.row]
            cell.selectionStyle = .none
            cell.rating = Double(self.detailData.experienceRate)!
            //            cell.sRate = (detailData?.experienceRating)!expe
            
            //cell.switchIsOn = perfDetails?.shareWithFriends
            //  cell.label.numberOfLines = 2
            
            cell.switch.isHidden = true
            // cell.cosmosView.isHidden = false
            
            cell.shareFriends.isHidden = true
            cell.shreLblHeight.constant = 0
            cell.switchHeight.constant = 0
            cell.detailFunction()
            return cell
        }
        
    }
}
extension PerformanceDetailsViewController
{
    
    
    @objc func shareFriends()
    {
        //BASEURL/sharePost/performanceId
             
        let items = [URL(string: "\(Constant.basicApi)/sharePost/\(self.perfomanceIDStr!)")]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
             present(ac, animated: true)
      }
    
   
}
