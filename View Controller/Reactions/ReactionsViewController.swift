//
//  ReactionsViewController.swift
//  TrackApp
//
//  Created by sanganan on 3/17/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl

class ReactionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var scrollV: ScrollableSegmentedControl!
    @IBOutlet weak var reactTV: UITableView!
    
    var perfId : String = String()
    var allLykArr = [allLykData]()
    var tempLykArr = [allLykData]()
    var allCount : Int = 0
    var musCount : Int =  Int()
    var okCount : Int =  Int()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonNavigationBar(title: "ReactionsKey".localized() , controller:AppUtils.Controllers.reactType,badgeCount : "0")
//        reactTV.backgroundColor = Constant.Color.backGroundColor
       scrollV.backgroundColor = Constant.Color.navColor

        reactApi()
        tvReg()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLykArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReactionsTableViewCell", for: indexPath) as! ReactionsTableViewCell
        cell.nameLbl.text = allLykArr[indexPath.row].username!
        cell.profilePic.sd_setImage(with: URL(string: allLykArr[indexPath.row].userImage!), placeholderImage: UIImage(named: "avatar1"))
        if allLykArr[indexPath.row].likeType == 8001
        {
            cell.reactTyp.image = #imageLiteral(resourceName: "mussels")

        }else{
        cell.reactTyp.image = #imageLiteral(resourceName: "like")
        }
        
        return cell
    }
    //MARK:- Reactions POST API
    func reactApi()
    {
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/viewLikesList"
        let dict:[String:Any] = ["performanceId":self.perfId]
        
        Service.sharedInstance.postRequest(Url:url,modalName: ReactionsModal.self , parameter: dict as [String:Any]) { (response, error) in
             print("response", response as Any)
            DispatchQueue.main.async {
                Utils.stopLoading()
                if let res = response?.Success
                {
                    if res == 1{
                        if let all = response?.AllLikes
                        {
                            self.allLykArr = all
                            self.tempLykArr = all
                            self.allCount = self.allLykArr.count
                        }
                        if let mus = response?.MuscleLikes?.count
                        {
                        self.musCount = mus
                        }
                        if let ok = response?.ThumbLikes?.count
                        {
                        self.okCount = ok
                        }
                        self.segf()
                        self.reactTV.reloadData()
                    }else{
                        AppUtils.showToast(message: (response?.Message)!)
                    }
                }
            }
        }
    }
}

extension ReactionsViewController
{
    private func segf()
    {
      let textAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.white]
        
            scrollV.setTitleTextAttributes(textAttributes as [NSAttributedString.Key : Any], for: .normal)
        
        scrollV.segmentStyle = .imageOnLeft
        
        scrollV.insertSegment(withTitle: "AllKey".localized() + String(describing : self.allCount), image: UIImage(named: ""), at: 0)
        scrollV.insertSegment(withTitle: "\(self.musCount)", image: UIImage(named: "mussels"), at: 1)
        scrollV.insertSegment(withTitle: "\(self.okCount)", image: UIImage(named: "like"), at: 2)
        scrollV.underlineSelected = true
        scrollV.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        scrollV.selectedSegmentIndex = 0
        scrollV.segmentContentColor = UIColor.white
        scrollV.selectedSegmentContentColor = UIColor.white
        scrollV.backgroundColor = Constant.Color.navColor
        scrollV.fixedSegmentWidth = false
    }
    
    @objc private func segmentSelected(sender:ScrollableSegmentedControl) {
       if sender.selectedSegmentIndex == 0
       {
        self.allLykArr = tempLykArr
       }
        else if sender.selectedSegmentIndex == 1
       {
        self.allLykArr = tempLykArr.filter({ (data) -> Bool in
            return data.likeType == 8001
        })
        }
        else if sender.selectedSegmentIndex == 2
       {
            self.allLykArr = tempLykArr.filter({ (data) -> Bool in
                      return data.likeType == 8002
                  })
        }
        self.reactTV.reloadData()
    }
    private func tvReg()
    {
        reactTV.register(UINib(nibName: "ReactionsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReactionsTableViewCell")
        reactTV.delegate = self
        reactTV.dataSource = self
    }
    
}

