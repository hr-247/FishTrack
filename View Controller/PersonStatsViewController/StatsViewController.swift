//
//  StatsViewController.swift
//  TrackApp
//
//  Created by saurav sinha on 08/11/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit
import SDWebImage

class StatsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var msgLblOutlet: UILabel!
    @IBOutlet weak var statsTableView: UITableView!
    
    //MARK:- Variables
    var statsModaal:GetUserStatsViewModal?
    var statstiimeModal:GetUserStatsViewModal1?
    var moredata:Bool = true
    var page:Int = 0
    var perfomanceArray:[performancelistModal] =  [performancelistModal]()
    var strArray:[String] = [String]()
    var strDurationArray:[String] = [String]()
    var fromFriendPage:Bool = false
    var userId:NSString = NSString()
    var userName:NSString = NSString()
    
    //MARK:- view life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.msgLblOutlet.text = "NoperformancedatatoshowKey".localized()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPage), name: NSNotification.Name(rawValue:"refreshpage"), object: nil)
        
        
        if fromFriendPage == false{
            
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
            
            self.userId = AppUtils.AppDelegate().userId as NSString
            self.userName = AppUtils.getStringForKey(key: Constant.username)! as NSString
        }
        
        navBar(userNme: self.userName as String)
        //   self.commonNavigationBar(title: self.userName as String, controller: AppUtils.Controllers.statsVC, badgeCount: "0")
        //    self.view.backgroundColor = Constant.Color.backGroundColor
        //    self.statsTableView.backgroundColor = Constant.Color.backGroundColor
        
        statsTableView.separatorStyle = .none
        
        self.navigationUI()
        self.getUserStatsApi()
    }
    func navigationUI() {
        
        self.statsTableView.estimatedRowHeight = 100; // set to whatever your "average" cell height is
        statsTableView.register(UINib(nibName: "BarChartTableViewCell", bundle: nil), forCellReuseIdentifier: "BarChartTableViewCell")
        statsTableView.register(UINib(nibName: "BlankTableViewCell", bundle: nil), forCellReuseIdentifier: "BlankTableViewCell")
        statsTableView.register(UINib(nibName: "AverageViewsTableViewCell", bundle: nil), forCellReuseIdentifier: "AverageViewsTableViewCell")
        statsTableView.register(UINib(nibName: "StatsTableViewCell", bundle: nil), forCellReuseIdentifier: "StatsTableViewCell")
        statsTableView.register(UINib(nibName: "DateWiseTableViewCell", bundle: nil), forCellReuseIdentifier: "DateWiseTableViewCell")
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.statsTableView.reloadData()
    }
    
    //MARK:- table property
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.moredata == true{
            return (3 + (self.perfomanceArray.count))
        }else{
            return (2 + (self.perfomanceArray.count))
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 0) {
            
            return 230
        }
        else if (indexPath.row == 1) {
            
            return 250
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 1) {
            
            let cell : BarChartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BarChartTableViewCell",for:
                indexPath) as! BarChartTableViewCell
            
            cell.selectionStyle = .none
            cell.modal  =  self.statsModaal
            cell.generateRandomDataEntries()
            return cell
            
        }
            
            
        else if (indexPath.row == 0) {
            
            let cell : StatsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StatsTableViewCell",for: indexPath) as! StatsTableViewCell
            
            cell.statsModaal = self.statsModaal
            
            var total = 0
            if let monthwise = self.statsModaal?.mnthperformance
            {
                total = total + monthwise.Jan! + monthwise.Feb! + monthwise.Mar! + monthwise.Apr! + monthwise.May!
                total = total +  monthwise.Jun! + monthwise.Jul! + monthwise.Aug!
                total = total + monthwise.Sep! +  monthwise.Oct! + monthwise.Nov! + monthwise.Dec!
            }
            
           
            print ("total performance", total)
 
            cell.minsOnAvgLbl.text = "minsonaverageKey".localized()
            cell.timesPerMnthLbl.text = "timespermonthKey".localized()
            
            if let avg = self.statsModaal?.avgduration{
                cell.statsMinsLabel.text = String(describing:avg)
                
                if avg >= 2
                {
                    cell.minsOnAvgLbl.text = "minsonaverageKeys".localized()
                }
                
            }
            else{
                cell.statsMinsLabel.text = "0"
            }
            
            if let avg = self.statsModaal?.AverageMonth(){
                cell.statsTimesLabel.text = avg
                if Int(avg)! >= 2
                {
                    cell.timesPerMnthLbl.text = "timespermonthKeys".localized()
                }
                
            }else{
                cell.statsTimesLabel.text = "0"
            }
            
            
            cell.statsTimesLabel.text = "\(total)"
            
            
            cell.showPositions()
            cell.cosmo = self.statsModaal?.avgexperience
            
            cell.showCosmos()
            
            return cell
        }
            
        else if indexPath.row < (2 + (self.perfomanceArray.count)){
            
            let cell : DateWiseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DateWiseTableViewCell",for: indexPath) as! DateWiseTableViewCell
            
            
            cell.dateCellLabel.text = self.strArray[indexPath.row - 2]
            
            if self.strDurationArray[indexPath.row - 2] == "0" || self.strDurationArray[indexPath.row - 2] == "" {
                cell.MinsCellLbl.text = ""
            }else
            {
                if self.strDurationArray[indexPath.row - 2] == "1"
                {
                    cell.MinsCellLbl.text = self.strDurationArray[indexPath.row - 2] + "minKey".localized()
                }else{
                    
                    cell.MinsCellLbl.text = self.strDurationArray[indexPath.row - 2] + "minsKey".localized()
                }
            }
            
            //            for item in self.perfomanceArray[indexPath.row - 2].userPartner!
            //                     {
            //                         cell.partName.text = item.name
            //                     }
            cell.mapPin.isHidden = true
            //  cell.dateTop.constant = 25;
            cell.plceNme.text = ""
            if let place = self.perfomanceArray[indexPath.row - 2].userLocation?.locationName
            {
                if place.count > 0
                {
                    cell.mapPin.isHidden = false
                    // cell.dateTop.constant = 10;
                    cell.plceNme.text = place
                }
            }
            
            //            if self.perfomanceArray[indexPath.row - 2].userPartner!.count != 0{
            //                if   self.perfomanceArray[indexPath.row - 2].userPartner!.count > 1{
            //                    cell.partName.text = self.perfomanceArray[indexPath.row - 2].userPartner![0].name! + " & more"
            //                }else{
            //                    cell.partName.text = self.perfomanceArray[indexPath.row - 2].userPartner![0].name
            //                }
            //            }else{
            //                cell.partName.text = "No Partner"
            //            }
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell : BlankTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BlankTableViewCell", for: indexPath) as! BlankTableViewCell
            cell.tag = 999999
            for viw in cell.subviews
            {
                if viw is UIActivityIndicatorView
                {
                    let indicatr = viw as! UIActivityIndicatorView
                    indicatr.removeFromSuperview()
                    break
                }
            }
            
            let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
            myActivityIndicator.frame = CGRect(x: (UIScreen.main.bounds.size.width-20)/2, y: 20, width: 20, height: 20)
            myActivityIndicator.hidesWhenStopped = false
            myActivityIndicator.style = .white
            myActivityIndicator.startAnimating()
            myActivityIndicator.color = UIColor.white;
            cell.addSubview(myActivityIndicator)
            cell.backgroundColor = UIColor.clear;
            cell.contentView.backgroundColor = UIColor.clear;
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.tag == 999999
        {
            self.page += 1
            self.perfmnceListApi()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= 2{
            //            let vc = AppUtils.Controllers.performanceDetailsVC.get() as! PerformanceDetailsViewController
            //            vc.perfDetails = perfomanceArray[indexPath.row - 2]
            //            vc.perfomanceIDStr = perfomanceArray[indexPath.row - 2]._id
            //            vc.userIdStr = self.userId as String
            
            let vc = AppUtils.Controllers.comment.get() as! AddCommentViewController
            vc.performanceId = self.perfomanceArray[indexPath.row - 2]._id
            vc.isFrmNotification = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        if section == 0 && section == 1
    //        {return 20}
    //        else{
    //            return 20
    //        }
    //    }
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //         let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
    //               footerView.backgroundColor = Constant.Color.backGroundColor
    //               return footerView
    //    }
    
    
    @objc func refreshPage()
    {
        self.page = 0
        self.moredata = false
        self.getUserStatsApi()
        
    }
    
    
    
    //  MARK:- APi
    
    func getUserStatsApi() {
        
        Utils.startLoading(self.view)
        let url:String = Constant.basicApi + "/getUserStats/\(self.userId)"
        Service.sharedInstance.getRequest(Url:url, modalName: User_StatsModal.self , completion: { (response, error) in
            
            DispatchQueue.main.async {
                // Utils.stopLoading()
                
                if let success = response?.Success
                {
                    if  success == "1"
                    {
                        self.msgLblOutlet.isHidden = true
                        self.statsModaal = GetUserStatsViewModal(statsmodal: (response?.User_Stats!)!)
                        
                        self.perfmnceListApi()
                        
                    }else{
                        Utils.stopLoading()
                    }
                }
                
            }
        })
    }
    
    func perfmnceListApi() {
        
        let url:String = Constant.basicApi + "/performanceList/\(self.userId)/\(self.page)"
        Service.sharedInstance.getRequest(Url:url, modalName: dateWisePerfrmnceModal.self , completion: { (response, error) in
            
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1
                {
                    self.statstiimeModal = GetUserStatsViewModal1(perfrmncelistmodal: response!)
                    if (self.statstiimeModal?.perfrmncelist.count)! == 0 && self.page == 0
                    {
                        self.msgLblOutlet.isHidden = false
                        return
                    }else{
                        self.msgLblOutlet.isHidden = true
                    }
                    
                    if self.page == 0
                    {
                        
                        self.strArray.removeAll()
                        self.strDurationArray.removeAll()
                        self.perfomanceArray.removeAll()
                    }
                    
                    
                    
                    for item in self.statstiimeModal!.cretdtime{self.strArray.append(item)}
                    for item in self.statstiimeModal!.dur{self.strDurationArray.append(item)}
                    for item in self.statstiimeModal!.perfrmncelist{
                        self.perfomanceArray.append(item)
                    }
                    if (self.statstiimeModal?.perfrmncelist.count)! < 10
                    {
                        self.moredata = false
                    }else
                    {
                        self.moredata = true
                    }
                    if self.page == 0{
                        self.statsTableView.delegate = self
                        self.statsTableView.dataSource = self
                    }else{
                        self.statsTableView.reloadData()
                    }
                }
            }
        })
    }
}
extension StatsViewController
{
    
    
    //MARK:- UNFRIEND API
    @objc func unfriendAlert() {
        let alertController = UIAlertController(title: "UnfriendKey".localized(), message: "unfrndAlrtMsgKey".localized(), preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OKKey".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.unfriendApi()
        }
        
        let cancelAction = UIAlertAction(title: "CancelKey".localized(), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancelled")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    //MARK:- UNFRIEND API
    func unfriendApi() {
        
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/unfriend"
        let id = AppUtils.AppDelegate().userId
        let dict:[String:Any] = ["userId" : id,
                                 "friendId" : self.userId ]
        
        Service.sharedInstance.postRequest(Url:url,modalName: RejectRequestModal.self , parameter: dict as [String:Any]) { (response, error) in
            
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unfriend"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                    
                    AppUtils.showToast(message: "UnfriendDoneKey".localized())
                }
                
                
            }
        }
    }
    
}

extension StatsViewController
{
    func navBar(userNme : String)
    {
        self.title = userNme
        navigationController?.navigationBar.barTintColor = Constant.Color.navColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 25)!]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let button1 = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(backActn))
        self.navigationItem.leftBarButtonItem  = button1
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        if fromFriendPage == true
        {
            let button2 = UIBarButtonItem(image: UIImage(named: "unfrnd"), style: .plain, target: self, action: #selector(unfriendAlert))
            
            self.navigationItem.rightBarButtonItem = button2
            navigationItem.rightBarButtonItem?.tintColor = .white
        }
        
    }
    
    @objc private func backActn()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}


