//
//  WithViewController.swift
//  TrackApp
//
//  Created by saurav sinha on 05/11/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//
import UIKit

protocol WithViewControllerDelegate {
    
    func partnerObject(obj:[allPartnersModal])
}


class WithViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate,PartnerDelegate {
    
    //MARK:- OUTLETS
    @IBOutlet weak var pickerDone: UIButton!
    @IBOutlet weak var btmConstraint: NSLayoutConstraint!
    @IBOutlet weak var addWithDetails: UIButton!
    @IBOutlet weak var withTableView: UITableView!
    @IBOutlet weak var relationshipStatusPickerView: UIPickerView!
    
    //MARK:- VARIABLES
    var delegate:WithViewControllerDelegate?
    var partnerArr = [""]
    var partnerEmojiURL = [""]
    var relationArrApi = [RelationViewModal]()
    var relStatusArr = [""]
    var relStatusArrId = [""]
    var genderArr = [""]
    var partnerID = ["1"]
    var dataFromLocalDB = [allPartnersModal]()
    var relationNameApi:String = ""
    var addPartnerSection:Int = 1
    var onWhichCellActionPerform:Int = 0
    var maleGender:Bool = false
    var femaleGender:Bool = false
    
    //MARK:- view life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.okButtonWith(_:)), name: NSNotification.Name(rawValue:"OKButtonWithVC"), object: nil)
        self.navigationUI()
        self.commonNavigationBar(title: "WithKey".localized(), controller: AppUtils.Controllers.withVC, badgeCount: "0")
   //     self.view.backgroundColor = Constant.Color.backGroundColor
        
        self.pickerDone.setTitle("DoneKey".localized(), for: .normal)

        self.pickerDone.isHidden = true
        self.localDB()
    }
    func localDB()
    {
        if self.dataFromLocalDB.count > 0 {
            self.addPartnerSection = self.dataFromLocalDB.count
            self.partnerArr.removeAll()
            self.partnerEmojiURL.removeAll()
            self.genderArr.removeAll()
            self.relStatusArrId.removeAll()
            self.relStatusArr.removeAll()
            self.partnerID.removeAll()
            
            for (i,item) in self.dataFromLocalDB.enumerated()
            {
                
                self.partnerArr.append(item.partnerEmoji!)
                self.partnerEmojiURL.append(item.name!)
                self.genderArr.append(String(describing: item.gender!))
                self.relStatusArrId.append(item.relationShipStaus!)
                // self.relStatusArr.append(item.relationShipStaus!)
                self.partnerID.append(item._id!)
            }
        }
        self.getRelationsApi()
        
    }
    
    func navigationUI() {
        
        withTableView.register(UINib(nibName: "WithTableViewCell", bundle: nil), forCellReuseIdentifier: "WithTableViewCell")
        withTableView.register(UINib(nibName: "BlankTableViewCell", bundle: nil), forCellReuseIdentifier: "BlankTableViewCell")
        // Do any additional setup after loading the view.
        
        self.btmConstraint.constant = (UIScreen.main.bounds.height - (0.99*UIScreen.main.bounds.height))
        
    }
    
    //MARK:- pickerview property
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.relationArrApi.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.relationArrApi[row].relationName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.relStatusArr[onWhichCellActionPerform] = self.relationArrApi[row].relationName!
        self.relStatusArrId[onWhichCellActionPerform] = self.relationArrApi[row].id!
        self.relationNameApi = self.relationArrApi[row].relationName!
        self.withTableView.reloadData()
        
    }
    
    //MARK:- NSNotification functions
    
    @objc func okButtonWith(_ notifi: NSNotification){
        
        if self.addPartnerSection == 0{
            
            self.delegate?.partnerObject(obj:[])
            AppUtils.showToast(message: Constant.noPartnerAdded)
            return
        }
        for i in 0...self.addPartnerSection - 1
        {
            if self.partnerArr[i] == "" || self.relStatusArr[i] == "" || self.genderArr[i] == ""
            {
                AppUtils.showToast(message: Constant.withValidation)
                return
            }
        }
        self.addUpdatePartnerApi()
    }
    
    //MARK:- table property
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.addPartnerSection + 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row < self.addPartnerSection {
            
            return 170
        }
        else {
            
            return UIScreen.main.bounds.height - 170
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row < self.addPartnerSection) {
            
            let cell : WithTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WithTableViewCell",for: indexPath) as! WithTableViewCell
            
            cell.selectionStyle = .none
            cell.delegate = self
            
            if self.genderArr[indexPath.row] == "1001"
            {
                
                cell.selectedMaleImg = true
                cell.selectedFemaleImg = false
            }
            else if self.genderArr[indexPath.row] == "1002"
            {
                
                cell.selectedMaleImg = false
                cell.selectedFemaleImg = true
            }
            else {
                
                cell.selectedMaleImg = false
                cell.selectedFemaleImg = false
            }
            cell.imageChangeShow()
            cell.cellTag = indexPath.row
            if self.partnerArr[indexPath.row] == ""
            {
                cell.emojiImgview.isHidden = true
                cell.partnerLabel.text = "AddPartnerKey".localized()
            }
            else
            {
                cell.emojiImgview.isHidden = false

//                cell.partnerLabel.text = self.partnerArr[indexPath.row]
                
                if let url = URL(string: partnerEmojiURL[indexPath.row])
                {
                cell.emojiImgview.sd_setImage(with:url, placeholderImage: UIImage(named: "user"))

                }
                cell.partnerLabel.text = ""
                
                cell.partnerImageView.isHidden = true
            }
            
            if self.relStatusArr[indexPath.row] == "" {
                
                cell.relatnshpLabel.text = "RelationshipStatusKey".localized()
                cell.relatnshpImageView.isHidden = false
                
            }
            else {
                
                cell.relatnshpLabel.text = self.relStatusArr[indexPath.row]
                cell.relatnshpImageView.isHidden = true
            }
            
            cell.selectionStyle = .none
            return cell
        }
            
        else{
            
            let cell : BlankTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BlankTableViewCell",for: indexPath) as! BlankTableViewCell
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1
        {
            
            self.relationshipStatusPickerView.isHidden = true
            self.pickerDone.isHidden = true
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            if partnerID[indexPath.row] == "1"
            {
                self.withTableView.beginUpdates()
                self.partnerID.remove(at: indexPath.row)
                self.relStatusArrId.remove(at: indexPath.row)
            
                self.genderArr.remove(at: indexPath.row)
                self.addPartnerSection -= 1
                self.partnerArr.remove(at: indexPath.row)
                self.partnerEmojiURL.remove(at: indexPath.row)
                self.withTableView.deleteRows(at: [indexPath], with: .left)
                self.withTableView.endUpdates()
                AppUtils.showToast(message: Constant.partnerDeletd)
                
            }else{
                
                self.deletePartnerApi(handler: {(res,Message) in
                    if res == true
                    {
                        self.withTableView.beginUpdates()
                        self.partnerID.remove(at: indexPath.row)
                        self.relStatusArrId.remove(at: indexPath.row)
                        self.genderArr.remove(at: indexPath.row)
                        self.addPartnerSection -= 1
                        self.partnerArr.remove(at: indexPath.row)
                        self.partnerEmojiURL.remove(at: indexPath.row)
                        self.withTableView.deleteRows(at: [indexPath], with: .left)
                        self.withTableView.endUpdates()
                        AppUtils.showToast(message: Message)
                        
                    }
                    else{
                        
                        AppUtils.showToast(message: Message)
                    }
                })
            }
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @IBAction func pickerOkButton(_ sender: Any) {
        
        relationshipStatusPickerView.isHidden = true
        self.pickerDone.isHidden = true
    }
    
    @IBAction func addMorePartner(_ sender: Any) {
        if self.addPartnerSection >= 5
        {
            AppUtils.showToast(message: Constant.addPartnerStatus)
            return
        }
        
        self.addPartnerSection = addPartnerSection + 1
        self.partnerArr.append("")
        self.partnerEmojiURL.append("")
        self.relStatusArr.append("")
        self.relStatusArrId.append("")
        self.genderArr.append("")
        self.partnerID.append("1")
        self.withTableView.reloadData()
        
    }
    
    //MARK : PartnerDelegate
    func emojiSelected(emoji : Emoji)
       {
           self.partnerArr[onWhichCellActionPerform] = emoji._id!
           self.partnerEmojiURL[onWhichCellActionPerform] = emoji.emojiUrl!
           
           self.withTableView.reloadData()
           
       }
    //MARK:- APi
    
    func addUpdatePartnerApi() {
        var arrAllPartnersModal:[[String:Any]] = [[String:Any]]()
        var updateDataPartner:[[String:Any]] = [[String:Any]]()
        var rel = self.dataFromLocalDB.map({$0._id})
        for i in 0..<self.partnerArr.count
        {
            if rel.contains(self.partnerID[i])
            {
                
                let dict:[String:Any] = ["gender":Int(self.genderArr[i])!,"name": self.partnerEmojiURL[i],"relationShipStaus": self.relStatusArrId[i],"_id":self.partnerID[i], "partnerEmoji":self.partnerArr[i]]
                updateDataPartner.append(dict)
                
            }else{
                
                let dict:[String:Any] = ["gender":Int(self.genderArr[i])!,"name": self.partnerEmojiURL[i],"relationShipStaus": self.relStatusArrId[i], "partnerEmoji":self.partnerArr[i]]
                arrAllPartnersModal.append(dict)
            }
        }
        
        Utils.startLoading(self.view)
        let url:String = Constant.basicApi + "/addPartner"
        let request:[String:Any] = ["newPartner":arrAllPartnersModal, "updated":updateDataPartner]
        Service.sharedInstance.postRequest(Url:url,modalName: AddUpdatePartnerModal.self , parameter: request as [String:Any]) { (response, error) in
            
            DispatchQueue.main.async {
                Utils.stopLoading()
                if let success = response?.Success{
                    if success == 1{
                        
                        self.delegate?.partnerObject(obj: (response?.AllPartners)!)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        
                        AppUtils.showToast(message: "noresponseKey".localized())
                    }
                }
                
            }
            
        }
        
    }
    
    func getRelationsApi() {
        
        Utils.startLoading(self.view)
        let url:String = Constant.basicApi + "/getAllRelations"
        
        Service.sharedInstance.getRequest(Url:url, modalName: GetAllRelationsModal.self , completion: { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1{
//                    var data:[String] = []
//                    var name:[String] = []
                    for (i,item) in response!.Relations.enumerated()
                    {
                        let modal = RelationViewModal(relationModal: item)
//                        data = response!.Relations.map({ $0._id!})
//                        name = response!.Relations.map({ $0.relationName!})
                        self.relationArrApi.append(modal)
                        
                        for item in self.relStatusArrId
                        {
                            if modal.id == item
                            {
                                self.relStatusArr.append(modal.relationName!)
                            }
                        }
                        
                        
                    }
                    
//                    for (i,item) in self.relationArrApi.enumerated(){
//
//                        if  data.contains(item){
//                            self.relStatusArr.append(name[i])
//                        }
//                    }
                    self.withTableView.delegate = self
                    self.withTableView.dataSource = self
                    self.withTableView.reloadData()
                }
                
            }
        })
        
    }
    
    func deletePartnerApi(handler:@escaping (Bool,String) -> ()) {
        
        Utils.startLoading(self.view)
        let url:String = Constant.basicApi + "/deletePartner/\(AppUtils.AppDelegate().userId)"
        
        Service.sharedInstance.getRequest(Url: url, modalName: DeletePartnerModal.self, completion: { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success ==  1{
                    handler(true,(response?.Message)!)
                    
                }
                else {
                    handler(false,"noresponseKey".localized())
                    
                }
            }
        })
    }
}

//MARK:- WithTableViewCellDelegate

extension WithViewController: WithTableViewCellDelegate{
    func selectdPartner(cell: Int) {
        self.onWhichCellActionPerform = cell
//        let alertController = UIAlertController(title: "Partner Name", message: "", preferredStyle: .alert)
//
//        // Create the actions
//        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
//            UIAlertAction in
//            NSLog("Added")
//            let whiteSpace = ((alertController.textFields![0].text!) ).trimmingCharacters(in: .whitespaces)
//            if whiteSpace.count != 0 {
//                self.partnerArr[cell] = whiteSpace
//                self.withTableView.reloadData()
//            }
//
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
//            UIAlertAction in
//            NSLog("Cancelled")
//
//        }
//
//        alertController.addTextField { (textField:UITextField) -> Void in
//
//            textField.keyboardType = .alphabet
//        }
//
//        alertController.addAction(okAction)
//        alertController.view.tintColor = .black
//        alertController.addAction(cancelAction)
//        let subview = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
//        subview.layer.cornerRadius = 1
//        subview.backgroundColor = UIColor(red: (191/255.0), green: (153/255.0), blue: (70/255.0), alpha: 1.0)
//
//
//        self.present(alertController, animated: true, completion: nil)
        
        let partner = AppUtils.Controllers.partnerVC.get() as! PartnerViewController
        partner.delegate = self
        partner.selectedEmojiArr = self.partnerArr
        self.navigationController?.pushViewController(partner, animated: true)
        
        
    }
    
    func selectdStatus(cell: Int) {
        self.onWhichCellActionPerform = cell
        self.pickerDone.isHidden = false
        self.relationshipStatusPickerView.isHidden = false
        relationshipStatusPickerView?.delegate = self
        relationshipStatusPickerView?.dataSource = self
        
    }
    func seletedGender(maleG: Bool, femaleG: Bool, cell: Int) {
        self.onWhichCellActionPerform = cell
        let str =  (maleG == true) ? "1001":"1002"
        self.genderArr[cell] = (str)
        self.maleGender = maleG
        self.femaleGender = femaleG
    }
    
}



