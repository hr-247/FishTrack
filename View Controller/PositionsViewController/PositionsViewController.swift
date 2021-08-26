//
//  PositionsViewController.swift
//  TrackApp
//
//  Created by saurav sinha on 06/11/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit
import SDWebImage

protocol PositionsViewControllerDelegate {
    
    func selectPosApi(imageObj:[positionsModal])
}


class PositionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var pickMoreThanLbl: UILabel!
    @IBOutlet weak var positionsCollectionView: UICollectionView!
    
    var delegate: PositionsViewControllerDelegate?
    var selectdPosArrApi = [PositionsViewModal]()
    var posModal = [positionsModal]()
    var abc = [String]()
    var selectPosApi: String = ""
    
    //MARK:- view life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.doneButton(_:)), name: NSNotification.Name(rawValue:"DoneButtonPosVC"), object: nil)
        self.navigationUI()
        self.commonNavigationBar(title: "PositionsKey".localized(), controller: AppUtils.Controllers.positionsVC, badgeCount: "0")
        
        self.pickMoreThanLbl.text = "YoucanpickmorethanoneKey".localized()
        
     //   self.view.backgroundColor = Constant.Color.backGroundColor

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getAllPositionsApi()
        
    }
    
    func navigationUI() {
        
        positionsCollectionView.register(UINib(nibName:"PositionsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PositionsCollectionViewCell")
        positionsCollectionView.delegate = self
        positionsCollectionView.dataSource = self
    }
    
    //MARK:- collection property
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.selectdPosArrApi.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : PositionsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PositionsCollectionViewCell",for: indexPath) as! PositionsCollectionViewCell
        let post = self.selectdPosArrApi[indexPath.row]
        cell.positionsImageView.sd_setImage(with: URL(string: selectdPosArrApi[indexPath.item].posImage!), placeholderImage: UIImage(named: "1"))
        cell.deSelectView.layer.cornerRadius = cell.deSelectView.frame.height/2
        cell.deSelectView.clipsToBounds = true
        
        for (i,item) in  self.posModal.enumerated(){
            if  item._id == post.id
            {
                cell.deSelectView.isHidden = false
                cell.selecte0 = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell:PositionsCollectionViewCell = (collectionView.cellForItem(at: indexPath) as? PositionsCollectionViewCell)!
        
        if cell.selecte0 == false
        {   let post = self.selectdPosArrApi[indexPath.row]
            let data = positionsModal(id: post.id! , posname: post.posName!, posimage: post.posImage!)
            self.posModal.append(data)
            cell.deSelectView.isHidden = false
            cell.selecte0 = true
        }
        else {
            for (i,item) in  self.posModal.enumerated(){
                if  item._id == self.selectdPosArrApi[indexPath.row].id
                {
                    self.posModal.remove(at: i)
                }
            }
            cell.deSelectView.isHidden = true
            cell.selecte0 = false
        }
        
    }
    
    //MARK:- NSNotification functions
    
    @objc func doneButton(_ notifi: NSNotification) {
        self.delegate?.selectPosApi(imageObj: self.posModal)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //  MARK:- APi
    
    func getAllPositionsApi() {
        
        Utils.startLoading(self.view)
        let url:String = Constant.basicApi + "/getAllPositions"
        
        Service.sharedInstance.getRequest(Url:url, modalName: GetAllPositionsModal.self , completion: { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1{
                    for item in response!.Positions
                    {
                        let modal = PositionsViewModal(positionModal: item)
                        self.selectdPosArrApi.append(modal)
                        
                    }
                    self.positionsCollectionView.reloadData()
                }
            }
        })
    }
    
}
