//
//  PlacesViewController.swift
//  TrackApp
//
//  Created by saurav sinha on 04/11/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit


class PlacesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var placesTableView: UITableView!

    @IBOutlet weak var moreThnOneLbl: UILabel!
    

    var placeArrayApi = [PlacesViewModal]()
    var loc:[Double]?
    var selectdPlacesArray = [String]()
    var selectdPlacesIdArr = [String]()
    var locationName:String = ""
    var placeNameApi : String = ""
    
    //MARK:- view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonNavigationBar(title: "PlacesKey".localized(), controller: AppUtils.Controllers.placesVC, badgeCount: "0")
     //   self.view.backgroundColor = Constant.Color.backGroundColor

        moreThnOneLbl.text = "moreThnOneKey".localized()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(okButtonTapped(_:)), name: NSNotification.Name(rawValue:"OKButtonLoca"), object: nil)
        placesTableView.register(UINib(nibName : "PlacesTableViewCell", bundle: nil), forCellReuseIdentifier : "PlacesTableViewCell")
        self.placesTableView.delegate = self
        self.placesTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getPlacesApi()
    }
    
    //MARK:- table property
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.placeArrayApi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : PlacesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PlacesTableViewCell",for: indexPath) as! PlacesTableViewCell
        
        cell.placesTableViewCellLabel.text = self.placeArrayApi[indexPath.row].placeName!
        
        cell.selectionStyle = .none
        if selectdPlacesArray.contains(self.placeArrayApi[indexPath.row].placeName!)
        {
            cell.tickImage.isHidden = false
            
        }else
        {
            cell.tickImage.isHidden = true
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectdPlacesArray.contains(self.placeArrayApi[indexPath.row].placeName!)
        {
            let pos:Int =  selectdPlacesArray.firstIndex(of:self.placeArrayApi[indexPath.row].placeName!)!
            selectdPlacesArray.remove(at: pos)
            selectdPlacesIdArr.remove(at: pos)
        }else
        {
            selectdPlacesArray.append(self.placeArrayApi[indexPath.row].placeName!)
            selectdPlacesIdArr.append(self.placeArrayApi[indexPath.row].id!)
        }
        self.placesTableView.reloadData()
        
    }
    
    //MARK:- NSNotification functions
    
    @objc func okButtonTapped(_ notifi: NSNotification){
        
        self.createLocation()
    }
    
    //  MARK:- APi
    
    func getPlacesApi() {
        
        Utils.startLoading(self.view)
        let url:String = Constant.basicApi + "/getAllPlaces"
        
        Service.sharedInstance.getRequest(Url:url, modalName: GetAllPlacesModal.self , completion: { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1{
                    for item in response!.Places
                    {
                        let modal = PlacesViewModal(placeModal: item)
                        
                        
                        
                        
                        self.placeArrayApi.append(modal)
                    }
                    
                                       
                    for (index,item) in self.placeArrayApi.enumerated()
                                       {
                                           if item.placeName == "Other" || item.placeName == "other" || item.placeName == "Others" || item.placeName == "others" || item.placeName == "Andere" || item.placeName == "andere"
                                           {
                                               self.placeArrayApi.remove(at: index)
                                               self.placeArrayApi.append(item)
                                               break
                                           }
                                       }
                    
                    
                    
                    
                    
                    
                    self.placesTableView.reloadData()
                }
            }
        })
    }
    func createLocation() {
        
        if self.selectdPlacesArray.count == 0 {
            
            AppUtils.showToast(message: Constant.noPlacesSelectd)
            return
        }
        
        Utils.startLoading(self.view)
        
        let url:String = Constant.basicApi + "/createLocation"
        let request = ["location":["type":"Points","coordinates":self.loc!],"locationName":self.locationName,"place":self.selectdPlacesIdArr] as [String : Any]
        Service.sharedInstance.postRequest(Url:url, modalName:locationHelperModal.self, parameter: request , completion: { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1{
                    let object = ["places":  self.selectdPlacesArray ,"id": self.selectdPlacesIdArr,"location":response?.Location?._id,"placesName":self.locationName] as [String : Any]
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlaceName"), object: object)
                    
                    AppUtils.goToPreviousPage(navigation: self.navigationController, whichPage:AddYourPerformanceViewController.self)
                    
                }
            }
        })
    }
}
