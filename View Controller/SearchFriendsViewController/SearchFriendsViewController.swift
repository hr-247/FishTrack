//
//  SearchFriendsViewController.swift
//  TrackApp
//
//  Created by saurav sinha on 07/11/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit


class SearchFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,SearchFriendsTableViewCellDelegate {
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var searchView: UIView!
    private var search : String = ""
    private var SearchList: [FriendsDataModal] =  [FriendsDataModal]()
    @IBOutlet weak var SearchTextField: UITextField!
    //  @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchFriendsTableView: UITableView!
    
    @IBOutlet weak var messageLblOutlet: UILabel!
    var systemVersion = UIDevice.current.systemVersion
    var searchFriends = [FriendsDataModal]()
    var getallFrendsApi = [friendModal]()
    
    //MARK:- view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.startLoading(self.view)
        self.getAllFrendsApi()
        self.SearchTextField.delegate = self
        self.commonNavigationBar(title: "SearchFriendsKey".localized(), controller: AppUtils.Controllers.searchFriendsVC, badgeCount: "0")
    //    self.view.backgroundColor = Constant.Color.navColor
         self.searchView.backgroundColor = Constant.Color.navColor
        //   self.bgView.backgroundColor = Constant.Color.backGroundColor;
        //    self.searchFriendsTableView.backgroundColor = Constant.Color.backGroundColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onReceiveData(_:)), name: NSNotification.Name(rawValue: "unfriend"), object: nil)
        searchFriendsTableView.register(UINib(nibName: "SearchFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchFriendsTableViewCell")
        self.searchFriendsTableView.estimatedRowHeight = 65
        
        self.SearchTextField.placeholder = "SearchKey".localized()
        self.SearchTextField.placeHolderColor = UIColor.white
        //   self.SearchTextField.layer.cornerRadius = 20
        let viw = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 35))
        self.SearchTextField.leftViewMode = .always
        self.SearchTextField.leftView = viw
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    @objc func onReceiveData(_ notification:Notification) {
        self.searchFriendsTableView.delegate = self
        self.searchFriendsTableView.dataSource = self
        self.view.endEditing(true)
        self.SearchTextField.text = ""
        self.search = ""
        self.searchFriends.removeAll()
        self.getAllFrendsApi()
    }
    
    //MARK:- table property
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  self.search.count == 0{
            return self.getallFrendsApi.count
        }
        else  if self.searchFriends.count > 0 && self.search.count > 0
        {
            return self.searchFriends.count
        }
        else
        {
            AppUtils.showToast(message: "NoSearchFriendsKey".localized())
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SearchFriendsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchFriendsTableViewCell",for: indexPath) as! SearchFriendsTableViewCell
        cell.delegate = self
        cell.celltag = indexPath.row
        if self.search.count > 0
        {
            cell.searchFriendsVCUI(modal: self.searchFriends[indexPath.row])
        }
        else{
            cell.allFriendsVCUI(modal: getallFrendsApi[indexPath.row])
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.searchFriendsTableView.estimatedRowHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.search.count > 0
        {
            
            let modal = self.searchFriends[indexPath.row]
            if let friendModal = modal.isFriend
            {
                let vc = AppUtils.Controllers.statsVC.get() as! StatsViewController
                vc.fromFriendPage = true
                
                vc.userId = self.searchFriends[indexPath.row]._id as! NSString
                vc.userName = self.searchFriends[indexPath.row].username as! NSString
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else
        {
            let vc = AppUtils.Controllers.statsVC.get() as! StatsViewController
            vc.fromFriendPage = true
            
            vc.userId = self.getallFrendsApi[indexPath.row]._id as! NSString
            vc.userName = self.getallFrendsApi[indexPath.row].username as! NSString
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
    //MARK:- SEARCH FRIEND POST API
    
    func searchFriendsApi() {
        // Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/searchUser"
        let dict:[String:Any] = ["userWhoIsChecking": AppUtils.AppDelegate().userId,
                                 "string": self.search]
        Service.sharedInstance.postRequestForSearch(Url:url,modalName: SearchFriendModal.self , parameter: dict as [String:Any]) { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1{
                    self.searchFriends = (response!.Result) as! [FriendsDataModal]
                    self.searchFriendsTableView.reloadData()
                }
            }
        }
    }
    //MARK:- CREATE FRIEND REQUEST
    func addFriendReqApi(friendID: String, cellTag: Int)
    {
        self.view.endEditing(true)
        //searchFriends
        //   print(friendID,"controller check for userid")
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/createFriendRequest"
        let dict:[String:Any] = ["userWhoSentRequest": AppUtils.AppDelegate().userId,"userId": friendID]
        
        Service.sharedInstance.postRequest(Url:url,modalName: CreateResponseResult.self , parameter: dict as [String:Any]) { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if let res = response?.friendReqCreated.Success
                {
                    if res == 1
                    {
                        
                        self.searchFriendsApi()
                        AppUtils.showToast(message: "FriendRequestSentKey".localized())
                    }
                }
            }
        }
    }
    //MARK:- GET ALL FRIENDS API
    func getAllFrendsApi() {
        
        let url:String = Constant.basicApi + "/getAllFriends/\(AppUtils.AppDelegate().userId)"
        
        Service.sharedInstance.getRequest(Url:url, modalName: GetAllFriendsModal.self , completion: { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1{
                    self.getallFrendsApi.removeAll()
                    if response?.All_Friends.count == 0{
                        AppUtils.showToast(message: "NofriendstoshowKey".localized())
                        self.searchFriendsTableView.delegate = self
                        self.searchFriendsTableView.dataSource = self
                        self.searchFriendsTableView.reloadData()
                        return
                    }
                    for item in response!.All_Friends
                    {
                        let modal = friendModal(_id: item.friend._id, username: item.friend.username, userImage: item.friend.userImage,email: item.friend.email)
                        self.getallFrendsApi.append(modal)
                    }
                    self.searchFriendsTableView.delegate = self
                    self.searchFriendsTableView.dataSource = self
                    self.searchFriendsTableView.reloadData()
                }
            }
        })
    }
}

extension SearchFriendsViewController :  UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    //MARK:- TEXT FIELD DELEGATE METHOD
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            self.search = updatedText.trimmingCharacters(in: .whitespacesAndNewlines)
            if self.search != ""
            {
                self.searchFriendsApi()
            }else{
                self.getAllFrendsApi()
            }
            
        }else
        {
            self.getAllFrendsApi()
        }
        
        
        //        if let text = self.SearchTextField.text{
        //            self.search = text.trimmingCharacters(in: .whitespacesAndNewlines)
        //           if self.search != ""
        //                             {
        //                                 self.searchFriendsApi()
        //                             }else{
        //                                 self.getAllFrendsApi()
        //                             }
        //        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    //MARK:- APPROVE FRIEND REQUEST API
    func approveReqApi(req: String, cellTag: Int) {
        Utils.startLoading(self.view)
        let url:String = "\(Constant.basicApi)/approveFreindReq"
        //   var reqId : String = String()
        let dict:[String:Any] = ["reqId" : req]
        
        Service.sharedInstance.postRequest(Url:url,modalName: ApproveFriendRequestModal.self , parameter: dict as [String:Any]) { (response, error) in
            
            DispatchQueue.main.async {
                Utils.stopLoading()
                
                if let res = response?.Success
                {
                    if res == 1{
                        self.searchFriendsApi()
                        AppUtils.showToast(message: "FriendRequestAcceptedKey".localized())
                        
                    }
                }
            }
        }
    }
    //MARK:- REJECT FRIEND REQUEST API
    func rejectReqApi(req: String, cellTag: Int) {
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/rejectFreindReq/\(req)"
        Service.sharedInstance.getRequest(Url:url,modalName:RejectRequestModal.self,completion: { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1
                {
                    self.searchFriendsApi()
                    AppUtils.showToast(message: "FriendRequestRejectedKey".localized())
                }
            }
        })
    }
}
  
