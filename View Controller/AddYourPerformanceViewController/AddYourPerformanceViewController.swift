//
//  AddYourPerformanceViewController.swift
//  TrackApp
//
//  Created by sanganan on 11/6/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//
import UIKit
import BSImagePicker
import Photos
import AWSS3
import AVFoundation
import AWSCore
import Mantis

class AddYourPerformanceViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,AddYourPerformanceTableViewCellDelegate,WithViewControllerDelegate,AddYourPerformancePostCellDelegate {
   
    
    private var imagePicker = UIImagePickerController()
    
    //MARK:- SELECT PARTNER
    func partnerObject(obj: [allPartnersModal]) {
        //  self.perfrData?.partnerData = obj
        self.perfTableView.reloadData()
        // self.newPartnerName =  obj.map({$0.name!})
    }
    //MARK:- PREMIUM PAGE
    func permiumBtnActn() {
        Utils.startLoading(self.view)
        let vc:PremiumViewController = PremiumViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.navigationController?.present(vc, animated: true, completion: nil)
        Utils.stopLoading()
    }
    
    func topBtnAction(celltag : Int)
    {
        self.tableAction(cellTag: celltag)
    }
    
    
    
    //MARK:- OUTLETS
    @IBOutlet weak var doneActn: UIButton!
    @IBOutlet weak var durDone: UIButton!
    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var pickerBg: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var perfTableView: UITableView!
    
    //MARK:- VARIABLE DECLARATION
    var perfrData:PerformanceHelperModal?
    var placesID: [String] = [String]()
    var newPlaceName: String = ""
    //   var newPlaceName = [placesModal]
    var locName:String = ""
    var loca : String = ""
    var paidValue : String = String()
    var selectedFishIds : [String] = [String]()
    var selectedFishNames : [String] = [String]()
    var ImageChoosen = UIImage()
    var image = UIImage()
    var s3URL = String()
    
    
    //MARK:- PICKER ENUM
    enum whichPicker:String {
        case BaithPicker
        case FishWgtPicker
        case FishLngthPicker
        case RodPicker
        case WaterDepPicker
        case DurPicker
        case LicensePicker
    }
    var whichPickerTapped : whichPicker = whichPicker.BaithPicker
    
    //MARK:- ARRAY DECLARATION
    var baitsArr = [BaitModal]()
    var rodArr = [RodModal]()
    var fishWgtArr = [FishWeightModal]()
    var fishLengthArr  = [FishLengthModal]()
    var waterDepArr  = [WaterDepthModal]()
    
    //MARK:- DATE PICKER DONE BUTTON
    @IBAction func doneBtnActn(_ sender: UIButton) {
        self.perfrData!.time = AppUtils.getParticularTimeFormat(format: "d MMM yy hh:mm a EEEE", date: datePicker.date)
        self.perfrData!.dateTimeStamp = String(AppUtils.particularTimeInMiliseconds(Date: datePicker.date))
        
        self.perfTableView.reloadData()
        self.datePicker.isHidden = true
        self.pickerBg.isHidden = true
        self.doneActn.isHidden = true
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        //    imagePicker.allowsEditing = true
        // self.view.backgroundColor = Constant.Color.backGroundColor
        
        self.doneActn.setTitle("DoneKey".localized(), for: .normal)
        self.durDone.setTitle("DoneKey".localized(), for: .normal)
        
        self.commonNavigationBar(title: "AddYourPerformanceKey".localized(), controller: AppUtils.Controllers.addYourPerfrmnceVC, badgeCount: "0")
        //    self.perfTableView.backgroundColor = Constant.Color.backGroundColor
        
        if let data = AppUtils.AppDelegate().PerformanceModal
        {
            self.perfrData = data
            self.loca = data.loca
            self.locName = data.locName
            self.newPlaceName = data.newPlaceName
            
        }else
        {
            self.perfrData = PerformanceHelperModal.init()
        }
        
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.backButtonadd(_:)), name: NSNotification.Name(rawValue:"BackButton"), object: nil)
        // NotificationCenter.default.addObserver(self, selector: #selector(addButtonTapped(_:)), name: NSNotification.Name(rawValue:"AddButton"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(placeChanged(_:)), name: NSNotification.Name(rawValue:"PlaceName"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(paymentDone(_:)), name: NSNotification.Name(rawValue:"PaymentDone"), object: nil)
        self.doneActn.layer.cornerRadius = 5;
        self.durDone.layer.cornerRadius = 5;
        self.cellRegister()
        pickerBg.isHidden =  true
        datePicker.isHidden = true
        durationPicker.dataSource = self
        durationPicker.delegate = self
        self.getFishDataApi()
    }
    
    override func addTapped() {
        //     print("add tapped")
        addButtonTapped()
    }
    
    func cellRegister()
    {
        perfTableView.register(UINib(nibName: "AddYourPerformanceTableViewCell", bundle: nil), forCellReuseIdentifier: "AddYourPerformanceTableViewCell")
        perfTableView.register(UINib(nibName: "AddYourPerformanceTableViewCell2", bundle: nil), forCellReuseIdentifier: "AddYourPerformanceTableViewCell2")
        perfTableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let paymentStatus = AppUtils.getStringForKey(key: Constant.isPaymentDone)
        if paymentStatus != "" || paymentStatus != nil{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PAYMENTCOMPLETED"), object: ["Status":4402,"json":paymentStatus])
        }
        if let iPaid = AppUtils.getStringForKey(key: Constant.isPaid)
        {
            self.paidValue = iPaid
            // self.perfTableView.reloadData()
        }
        else{
            self.paidValue =  "0"

        }
    }
    
    //MARK:- PLACE CHANGED FUNCTION
    @objc func placeChanged(_ sender: NSNotification) {
        self.newPlaceName =  ((((sender.object) as! NSDictionary).value(forKey:"places")) as! [String]).joined(separator: ",")
        self.placesID = ((sender.object) as! NSDictionary).value(forKey:"id") as! [String]
        self.loca  = ((sender.object) as! NSDictionary).value(forKey:"location") as! String
        self.locName = ((sender.object) as! NSDictionary).value(forKey:"placesName") as! String
        
        perfrData?.newPlaceName = self.newPlaceName
        perfrData?.locName = self.locName
        perfrData?.loca = self.loca
        
        
        //self.perfrData.place =
        self.perfTableView.reloadData()
    }
    //MARK:- Payment Done
    @objc func paymentDone(_ sender: NSNotification) {
        if  AppUtils.getStringForKey(key: Constant.isPaid) == "1"
        {
            self.paidValue = "1"
            self.perfTableView.reloadData()
        }else{
            self.paidValue =  "0"
        }
    }
    
    //MARK:- PICKER VIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch self.whichPickerTapped {
        case .BaithPicker:
            return baitsArr.count
        case .FishWgtPicker:
            return fishWgtArr.count
        case .FishLngthPicker:
            return fishLengthArr.count
        case .RodPicker:
            return rodArr.count
        case .WaterDepPicker:
            return waterDepArr.count
        case .DurPicker:
            return ClassConstant.picker.count
        case .LicensePicker:
            return ClassConstant.licesne.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch self.whichPickerTapped {
            
        case .BaithPicker:
            return String(describing:baitsArr[row].baitName!)
            
        case .FishWgtPicker:
            return String(describing:fishWgtArr[row].fishWeight!)
            
        case .FishLngthPicker:
            return fishLengthArr[row].fishLength!
            
        case .RodPicker:
            if let sas = rodArr[row].rodName
            {
                return "\( sas)"
            }else{
                return "N/A"
            }
            
        case .WaterDepPicker:
            return waterDepArr[row].waterDepth!
            
        case .LicensePicker:
            return ClassConstant.licesne[row]
            
        case .DurPicker:
            if row == 0
            {
                return (ClassConstant.picker[row])
            }
            else if row == 1
            {
                return (ClassConstant.picker[row]+"MinKey".localized())
            }
            return (ClassConstant.picker[row]+"MinsKey".localized())
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // print(row)
        self.perfTableView.reloadData()
        switch self.whichPickerTapped {
        case .BaithPicker:
            self.perfrData!.baitId = self.baitsArr[row]._id!
            self.perfrData!.baitName = self.baitsArr[row].baitName!
            return
            
        case .FishWgtPicker:
            self.perfrData!.wgtID = self.fishWgtArr[row]._id!
            self.perfrData!.wgtName = self.fishWgtArr[row].fishWeight!
            return
            
            
        case .FishLngthPicker :
            self.perfrData!.lengthID = self.fishLengthArr[row]._id!
            self.perfrData!.lengthName = self.fishLengthArr[row].fishLength!
            return
            
        case .RodPicker :
            self.perfrData!.rodId = self.rodArr[row]._id!
            self.perfrData!.rodName = self.rodArr[row].rodName!
            return
            
        case .WaterDepPicker :
            self.perfrData!.waterDepID = self.waterDepArr[row]._id!
            self.perfrData!.waterDepName = self.waterDepArr[row].waterDepth!
            return
            
            //                case .ExtraPicker:
            //                    self.perfrData!.extraID = self.extraArr[row].extra_id!
            //                    return self.perfrData!.extra = self.extraArr[row].extraName!
            //                case .SatisfactionPicker:
            //                    self.perfrData!.satisID = self.satisfyArr[row].satisfy_id!
            //                    if let satisfy = self.satisfyArr[row].satisfactionName
            //                    {
            //                        return  self.perfrData!.satisfaction = String(describing:satisfy)
            //                    }else
            //                    {
            //                        return  self.perfrData!.satisfaction = "N/A"
        //                    }
        case .LicensePicker:
            self.perfrData!.licenseName = ClassConstant.licesne[row]
            self.perfrData!.licenseID = ClassConstant.licesneIds[row]
            
            return
        case .DurPicker:
            self.perfrData!.duration = ClassConstant.picker[row]
            return
        }
        
    }
    //MARK:- PICKER DONE BUTTON
    @IBAction func durationDone(_ sender: Any) {
        //  print(self.whichPickerTapped,"hui")
        var title = ""
        var toast = ""
        
        switch self.whichPickerTapped {
        case .DurPicker:
            if self.perfrData?.duration == "Handmatig invoeren"
            {
                title = "AddMinsKey".localized()
                toast = "DuratnGrtrThanZeroKey".localized()
                let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OKKey".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Added")
                  //  alertController.textFields![0].keyboardType = .numberPad
                    let whiteSpace = ((alertController.textFields![0].text!) ).trimmingCharacters(in: .whitespaces)
                    if whiteSpace.count != 0 {
                       
                         if Int(whiteSpace) == 0
                        {
                            AppUtils.showToast(message: toast)
                            
                        }else{
                            self.perfrData?.duration = whiteSpace
                            self.perfTableView.reloadData()
                        }
                    }
                }
            
            let cancelAction = UIAlertAction(title: "CancelKey".localized(), style: UIAlertAction.Style.cancel) {
                     UIAlertAction in
                     NSLog("Cancelled")
                
                     
                 }
                 
                 alertController.addTextField { (textField:UITextField) -> Void in
                     textField.keyboardType = .numberPad
                 }
                 
                 alertController.addAction(okAction)
                 alertController.addAction(cancelAction)
                 self.present(alertController, animated: true, completion: nil)
             }
        case .FishWgtPicker:
            if (self.perfrData!.wgtName == "Other" || self.perfrData!.wgtName == "Handmatig invoeren")
            {
                title = "AddFishWeightKey".localized()
                toast = "DuratnGrtrThanZeroKey".localized()
                let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
               let  okAction = UIAlertAction(title: "OKKey".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Added")
             //   alertController.textFields![0].keyboardType = .numberPad
                    let whiteSpace = ((alertController.textFields![0].text!) ).trimmingCharacters(in: .whitespaces)
                    if whiteSpace.count != 0 {
                        if Int(whiteSpace) == 0
                        {
                            AppUtils.showToast(message: toast)
                            
                        }else{
                            self.perfrData!.wgtName = whiteSpace + " g"
                            self.perfTableView.reloadData()
                        }
                    }
                }
            
            let cancelAction = UIAlertAction(title: "CancelKey".localized(), style: UIAlertAction.Style.cancel) {
                     UIAlertAction in
                     NSLog("Cancelled")
                     
                 }
                 
                 alertController.addTextField { (textField:UITextField) -> Void in
                     textField.keyboardType = .numberPad
                 }
                 
                 alertController.addAction(okAction)
                 alertController.addAction(cancelAction)
                 self.present(alertController, animated: true, completion: nil)
             }
       
        case .FishLngthPicker:
            if (self.perfrData!.lengthName == "Other" || self.perfrData!.lengthName == "Handmatig invoeren")
            {
                title = "AddFishLngthKey".localized()
                toast = "DuratnGrtrThanZeroKey".localized()
                let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
               let  okAction = UIAlertAction(title: "OKKey".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Added")
          //      alertController.textFields![0].keyboardType = .numberPad
                    let whiteSpace = ((alertController.textFields![0].text!) ).trimmingCharacters(in: .whitespaces)
                    if whiteSpace.count != 0 {
                        if Int(whiteSpace) == 0
                        {
                            AppUtils.showToast(message: toast)
                            
                        }else{
                            self.perfrData!.lengthName = whiteSpace + " cm"
                            self.perfTableView.reloadData()
                        }
                    }
                }
            
            let cancelAction = UIAlertAction(title: "CancelKey".localized(), style: UIAlertAction.Style.cancel) {
                     UIAlertAction in
                     NSLog("Cancelled")
                     
                 }
                 
                 alertController.addTextField { (textField:UITextField) -> Void in
                     textField.keyboardType = .numberPad
                 }
                 
                 alertController.addAction(okAction)
                 alertController.addAction(cancelAction)
                 self.present(alertController, animated: true, completion: nil)
             }
            
        case .WaterDepPicker:
            if (self.perfrData!.waterDepName == "Other" || self.perfrData!.waterDepName == "Handmatig invoeren")
            {
                title = "AddWatrDepth".localized()
                toast = "DuratnGrtrThanZeroKey".localized()
                let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
               let  okAction = UIAlertAction(title: "OKKey".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Added")
           //     alertController.textFields![0].keyboardType = .numberPad
                    let whiteSpace = ((alertController.textFields![0].text!) ).trimmingCharacters(in: .whitespaces)
                    if whiteSpace.count != 0 {
                        if Int(whiteSpace) == 0
                        {
                            AppUtils.showToast(message: toast)
                            
                        }else{
                            self.perfrData!.waterDepName = whiteSpace + " m"
                            self.perfTableView.reloadData()
                        }
                    }
                }
            
            let cancelAction = UIAlertAction(title: "CancelKey".localized(), style: UIAlertAction.Style.cancel) {
                     UIAlertAction in
                     NSLog("Cancelled")
                     
                 }
                 
                 alertController.addTextField { (textField:UITextField) -> Void in
                     textField.keyboardType = .numberPad
                 }
                 
                 alertController.addAction(okAction)
                 alertController.addAction(cancelAction)
                 self.present(alertController, animated: true, completion: nil)
             }
        default:
            break
        }
    
        
//        if (self.perfrData?.duration == "More" || self.perfrData?.duration == "Meer dan 60") && self.whichPickerTapped == .DurPicker
//        {
//            let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
//
//            // Create the actions
//            let okAction = UIAlertAction(title: "OKKey".localized(), style: UIAlertAction.Style.default) {
//                UIAlertAction in
//                NSLog("Added")
//                let whiteSpace = ((alertController.textFields![0].text!) ).trimmingCharacters(in: .whitespaces)
//                if whiteSpace.count != 0 {
//                    if whiteSpace == "0"
//                    {
//                        AppUtils.showToast(message: toast)
//
//                    }else{
//                        self.perfrData?.duration = whiteSpace
//                        self.perfTableView.reloadData()
//                    }
//                }
//            }
            
//            let cancelAction = UIAlertAction(title: "CancelKey".localized(), style: UIAlertAction.Style.cancel) {
//                UIAlertAction in
//                NSLog("Cancelled")
//
//            }
//
//            alertController.addTextField { (textField:UITextField) -> Void in
//                textField.keyboardType = .numberPad
//            }
//
//            alertController.addAction(okAction)
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true, completion: nil)
       // }
        
        self.durationPicker.isHidden = true
        self.durDone.isHidden = true
    }
    //MARK:- BACK BUTTON
    @objc func backButtonadd( _ notifi: NSNotification)
    {
        AppUtils.AppDelegate().PerformanceModal = self.perfrData
     //   print(self.perfrData, "location")
        //self.navigationController?.popViewController(animated: true)
    }
    //MARK:- ALL DATA SAVE BUTTON
    
    func addButtonTapped()
    {
        self.view.endEditing(true)
        let data = self.perfrData
        
        //        if (data?.duration == "Duration" || self.loca == "" || data?.time == "" || data?.licenseID == ""){
        //            AppUtils.showToast(message: Constant.addAllDetails)
        //            return
        //        }else{
        //            self.performanceApi()
        //        }
        
        
        //        if (data?.duration == "Duration" || data?.time == ""){
        //                   AppUtils.showToast(message: Constant.addAllDetails)
        //                   return
        //               }else{
        //                   self.performanceApi()
        //               }
        
//        if (data?.time == "" || data?.duration == "" || self.loca == "" || data?.licenseID == ""){
        if (data?.time == "" || data?.duration == "" || self.loca == ""){

            AppUtils.showToast(message: Constant.mandatoryDetailsKey)
            return
        }
        else if data?.duration == "Handmatig invoeren"
        {
         AppUtils.showToast(message: "DuratnGrtrThanZeroKey".localized())
            return
        }
        else if data?.lengthName == "Handmatig invoeren"{
         AppUtils.showToast(message: "AddFishLngthMsgKey".localized())
            return
        }
        else if data?.wgtName == "Handmatig invoeren"{
         AppUtils.showToast(message: "AddFishWeightMsgKey".localized())
            return
        }
        else if data?.waterDepName == "Handmatig invoeren"{
         AppUtils.showToast(message: "AddWatrDepthMsgKey".localized())
            return
        }
        
        else{
            self.performanceApi()
        }
        
        
    }
    
    //MARK:- TABLE VIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 110
        }else{
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1
        {
            return ClassConstant.perfarr.count
        }else
        {
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
        //     footerView.backgroundColor = Constant.Color.backGroundColor
        return footerView
    }
    
    
    //MARK:- CELL FOR ROWAT
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //SECTION 0
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
            cell.selectionStyle = .none
            cell.postDelegate = self
            if let str =  self.perfrData?.statusImage{
                cell.cameraImgView.sd_setImage(with:URL(string:str), placeholderImage: UIImage(named: "campost"))
            }
            cell.postTxtView.text = self.perfrData?.status
            cell.postTxtView.delegate = self
            
            return cell
        }
        
        // SECTION 1
        if indexPath.section == 1
        {
            let cell : AddYourPerformanceTableViewCell = perfTableView.dequeueReusableCell(withIdentifier: "AddYourPerformanceTableViewCell", for: indexPath) as! AddYourPerformanceTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.tag = indexPath.row
            cell.performanceLabel.text = ClassConstant.perfarr[indexPath.row]
            cell.collectionView.isHidden = true
            cell.performanceLabel.isHidden = false
            if indexPath.row == 0
            {
                cell.performanceLabel.text = self.perfrData?.time
            }
            if indexPath.row <= 9
            {
                cell.apImage.image = UIImage(named: "nextArrowBtn.png")
                
                if  indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8
                {
                    if self.paidValue == "0"{
                        cell.apImage.image = UIImage(named: "paid_feature.png")
                    }
                }
            }
            if self.perfrData!.duration != "" && indexPath.row == 1
            {
                if self.perfrData!.duration == "Handmatig invoeren"
                {
                cell.performanceLabel.text = self.perfrData!.duration
                }
                else if self.perfrData!.duration == "1"
                {
                    cell.performanceLabel.text = self.perfrData!.duration + "MinKey".localized()
                }else{
                    cell.performanceLabel.text = self.perfrData!.duration + "MinsKey".localized()
                }
            }
            if self.perfrData?.fishIDs.count != 0 && indexPath.row == 2
            {
                
                cell.collectionView.isHidden = true
                cell.performanceLabel.text = self.perfrData?.fishNames.joined(separator:",")
                //                cell.emojiArray = self.newPartnerName
                //                cell.collectionView.isHidden = false
                //                cell.performanceLabel.isHidden = true
                //                cell.reloadCollection()
                
            }
            if self.newPlaceName != "" && indexPath.row == 3
            {
                cell.performanceLabel.numberOfLines = 0
                cell.performanceLabel.text = self.locName + "\n" + self.newPlaceName
                //   cell.performanceLabel.font = UIFont(name: "Calibri", size: 6)
            }
            if indexPath.row == 4 && self.perfrData!.lengthName != ""
            {
                //cell.posImageUI(modal: self.perfrData!.positionData)
                //   cell.performanceLabel.font = UIFont(name: "Calibri", size: 6)
                cell.performanceLabel.text = self.perfrData!.lengthName
            }
            if self.perfrData!.wgtName != "" && indexPath.row == 5
            {
                cell.performanceLabel.text = self.perfrData!.wgtName
            }
            if self.perfrData!.baitName != "" && indexPath.row == 6
            {
                cell.performanceLabel.text = self.perfrData!.baitName
            }
            if self.perfrData!.rodName != "" && indexPath.row == 7
            {
                cell.performanceLabel.text = self.perfrData!.rodName
            }
            if self.perfrData!.waterDepName != "" && indexPath.row == 8
            {
                cell.performanceLabel.text = self.perfrData!.waterDepName
            }
            if self.perfrData!.licenseID != "" && indexPath.row == 9
            {
                cell.performanceLabel.text = self.perfrData!.licenseName
            }
            return cell
        }
        else         //SECTION 2
        {
            let cell : AddYourPerformanceTableViewCell2 = perfTableView.dequeueReusableCell(withIdentifier: "AddYourPerformanceTableViewCell2", for: indexPath) as! AddYourPerformanceTableViewCell2
            
            cell.selectionStyle = .none
            cell.delegate = self
            cell.selectionStyle = .none
            
            if indexPath.row == 0
            {
                cell.rating = Double(self.perfrData!.experienceRate)!
                cell.cellTag = 0
            }
            return cell
        }
    }
    //MARK:- TABLEVIEW DIDSELECT ROWAT
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        if indexPath.section == 1
        {
            tableAction(cellTag: indexPath.row)
        }
    }
    
    func tableAction(cellTag : Int)
    {
        durationPicker.selectRow(0, inComponent: 0, animated: true)
        if cellTag == 0
        {
            datePicker.isHidden = false
            pickerBg.isHidden = false
            doneActn.isHidden = false
            self.datePicker.maximumDate = NSDate() as Date
            self.datePicker.datePickerMode = .dateAndTime
            
        }
        else   if cellTag == 1
        {
            durationPicker.isHidden = false
            durDone.isHidden = false
            self.whichPickerTapped = whichPicker.DurPicker
            self.durationPicker.reloadAllComponents()
            (self.perfrData!.duration = ClassConstant.picker[0])
            self.perfTableView.reloadData()
            
        }
        else    if cellTag == 2
        {
            //            if paidValue == "0"
            //            {
            //                self.permiumBtnActn()
            //            }
            //            else
            //            {
            let vc = AppUtils.Controllers.fishType.get() as! FishTypeViewController
            vc.delegate = self
            //vc.dataFromLocalDB = self.perfrData!.partnerData
            vc.selectedFishIds = self.perfrData!.fishIDs
            vc.selectedFishNames = self.perfrData!.fishNames
            self.navigationController?.pushViewController(vc, animated: true)
            return
            //           }
        }
        else if cellTag == 3
        {
            let vc = AppUtils.Controllers.locationVC.get() as! LocationViewController
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        else   if cellTag == 4
        {
            //            let vc = AppUtils.Controllers.positionsVC.get() as! PositionsViewController
            //            vc.delegate = self
            //            vc.posModal = self.perfrData!.positionData
            //            self.navigationController?.pushViewController(vc, animated: true)
            if paidValue == "0"
            {
                self.permiumBtnActn()
            }
            else
            {
                durationPicker.isHidden = false
                durDone.isHidden = false
                self.whichPickerTapped = whichPicker.FishLngthPicker
                self.durationPicker.reloadAllComponents()
                self.perfrData!.lengthID = self.fishLengthArr[0]._id!
                self.perfrData!.lengthName = self.fishLengthArr[0].fishLength!
                self.perfTableView.reloadData()
                
                
            }
            
            return
        }
        else  if cellTag == 5
        {
            if paidValue == "0"
            {
                self.permiumBtnActn()
            }
            else
            {
                durationPicker.isHidden = false
                durDone.isHidden = false
                self.whichPickerTapped = whichPicker.FishWgtPicker
                self.durationPicker.reloadAllComponents()
                self.perfrData!.wgtID = self.fishWgtArr[0]._id!
                self.perfrData!.wgtName = self.fishWgtArr[0].fishWeight!
                self.perfTableView.reloadData()
            }
        }
        else   if cellTag == 6
        {
            if paidValue == "0"
            {
                self.permiumBtnActn()
            }
            else
            {
                durationPicker.isHidden = false
                durDone.isHidden = false
                self.whichPickerTapped = whichPicker.BaithPicker
                self.durationPicker.reloadAllComponents()
                self.perfrData!.baitId = self.baitsArr[0]._id!
                self.perfrData!.baitName = self.baitsArr[0].baitName!
                self.perfTableView.reloadData()
            }
        }
        else   if cellTag == 7
        {
            if paidValue == "0"
            {
                self.permiumBtnActn()
            }
            else
            {
                durationPicker.isHidden = false
                durDone.isHidden = false
                self.whichPickerTapped = whichPicker.RodPicker
                self.durationPicker.reloadAllComponents()
                self.perfrData!.rodId = self.rodArr[0]._id!
                self.perfrData!.rodName = self.rodArr[0].rodName!
                self.perfTableView.reloadData()
            }
        }
        else   if cellTag == 8
        {
            if paidValue == "0"
            {
                self.permiumBtnActn()
            }
            else
            {
                durationPicker.isHidden = false
                durDone.isHidden = false
                self.whichPickerTapped = whichPicker.WaterDepPicker
                self.durationPicker.reloadAllComponents()
                self.perfrData!.waterDepID = self.waterDepArr[0]._id!
                self.perfrData!.waterDepName = self.waterDepArr[0].waterDepth!
                self.perfTableView.reloadData()
            }
        }else   if cellTag == 9
        {
            durationPicker.isHidden = false
            durDone.isHidden = false
            self.whichPickerTapped = whichPicker.LicensePicker
            self.durationPicker.reloadAllComponents()
            self.perfrData!.licenseName = ClassConstant.licesne[0]
            self.perfrData!.licenseID = ClassConstant.licesneIds[0]
            self.perfTableView.reloadData()
            
        }
    }
    
    //
    //    {
    //        "userId":"5e4b89fb8dff6424f42fd9a1",
    //        "statusDescription":"This is my 4nd performance",
    //        "performanceImage":"https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
    //        "dateTime":"1578400611",
    //        "duration":"150",
    //        "fishName":["5e4b979310ddb907f85b8ceb","5e4b979310ddb907f85b8cea","5e4b979310ddb907f85b8ce9"],
    //        "location":"5e4b9acdf1acd22614b23d38",
    //        "fishLength":"5e4a86f4eb6a3331386d8e16",
    //        "fishWeight":"5e4a870e95317610e49df335",
    //        "baitName":"5e4a67be17619608a42c16b2",
    //        "rodName":"5e4a789c8416034310414709",
    //        "waterDepth":"5e4a7b6f65187c1a78012631",
    //        "fishingLicence":4002,
    //        "experienceRating":5,
    //        "shareWithFriends" :1
    //    }
    //
    
    
    
    //MARK:- PERFORMANCE POST API
    
    func performanceApi()
    {
        var data = self.perfrData
        //       let partID = self.perfrData!.partnerData.map({$0._id!})
        //   let  posArr = self.perfrData!.positionData.map({$0._id!})
        //
        //        if (data!.positionData.count == 0  || data?.duration == "Duration" || self.loca == ""){
        //            AppUtils.showToast(message: Constant.addAllDetails)
        //            return
        //        }
        
        //        {
        //            "userId":"5e4b89fb8dff6424f42fd9a1",
        //            "statusDescription":"This is my 4nd performance",
        //            "performanceImage":"https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
        //            "dateTime":"1578400611",
        //            "duration":"150",
        //            "fishName":["5e4b979310ddb907f85b8ceb","5e4b979310ddb907f85b8cea","5e4b979310ddb907f85b8ce9"],
        //            "location":"5e4b9acdf1acd22614b23d38",
        //            "fishLength":"5e4a86f4eb6a3331386d8e16",
        //            "fishWeight":"5e4a870e95317610e49df335",
        //            "baitName":"5e4a67be17619608a42c16b2",
        //            "rodName":"5e4a789c8416034310414709",
        //            "waterDepth":"5e4a7b6f65187c1a78012631",
        //            "fishingLicence":4002,
        //            "experienceRating":5,
        //            "shareWithFriends" :1
        //        }
        
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/createPerformance"
        
        
        
        var dict:[String:Any] = ["userId": AppUtils.AppDelegate().userId,
                                 "duration":self.perfrData!.duration,
                                 "dateTime":self.perfrData!.dateTimeStamp!,
                                 "statusDescription":self.perfrData!.status,
                                 "location":self.loca,
                                 "performanceImage":self.perfrData!.statusImage,
                                 "fishName": self.perfrData!.fishIDs,
                                 "fishLength": self.perfrData!.lengthID,
                                 "fishWeight": self.self.perfrData!.wgtID,
                                 "baitName": self.perfrData!.baitId,
                                 "rodName":self.perfrData!.rodId,
                                 "waterDepth":self.perfrData!.waterDepID,
                                 "depthInString":self.perfrData!.waterDepName,
                                 "lengthInString":self.perfrData!.lengthName,
                                 "weightInString":self.perfrData!.wgtName,
                                 "fishingLicence":self.perfrData!.licenseID,
                                 "experienceRating":self.perfrData!.experienceRate,
                                 "shareWithFriends":self.perfrData!.shareFriend
            
        ]
        
        let keysToRemove = dict.keys.filter { (str) -> Bool in
            if let value = dict[str] as? String
            {
                return value.count == 0
            }
            if let value = dict[str] as? Array<Any>
            {
                return value.count == 0
            }
            if let value = dict[str] as? [String:Any]
            {
                return value.count == 0
            }
            return false
        }
        
        for key in keysToRemove {
            dict.removeValue(forKey: key)
        }
        
        //        print("timeStamp", self.perfrData!.dateTimeStamp)
        //
        //        print(datePicker.date,"time")
        // now dict will have only valid values i.e. non blank
        
        //        for key in dict.keys
        //        {
        //            if let str = dict[key] as? String
        //            {
        //                if str.count == 0
        //                {
        //                    dict[key] ==
        //                }
        //            }
        //        }
        
        
        Service.sharedInstance.postRequest(Url:url,modalName: performanceResultModal.self , parameter: dict as [String:Any]) { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if let res = response?.performanceCreated.Success
                {
                    if res == 1{
                        AppUtils.showToast(message: Constant.succesAddPerfrmnce)
                        AppUtils.AppDelegate().PerformanceModal = PerformanceHelperModal()
                        self.perfrData = PerformanceHelperModal()
                        
                        self.newPlaceName =  ""
                        self.placesID = []
                        self.locName = ""
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        AppUtils.showToast(message: Constant.failAddPerfrmnce)
                    }
                    
                }
            }
        }
        
    }
    
    //MARK:- PERFORMANCE GET API
    func getFishDataApi()
    {
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/getPerformanceData"
        Service.sharedInstance.getRequest(Url:url,modalName:getPerformanceModal.self,completion: { (response, error) in
            // print(response)
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1
                {
                    //                    self.rateArr = response!.Baits.map({BaitModal(BaitModal: $0)})
                    //                    self.asanaArr = response!.Asanas.map({AsanasViewModal(asanaModal: $0)})
                    //                    self.extraArr = response!.Extras.map({ExtraViewModal(extraModal: $0)})
                    //                    self.satisfyArr = response!.Satisfaction.map({SatisfactionViewModal(satisfactionModal: $0)})
                    self.baitsArr = (response?.Baits)!
                    
                    for (index,item) in (response?.Baits)!.enumerated()
                    {
                        if item.baitName == "Other" || item.baitName == "other" || item.baitName == "Others" || item.baitName == "others" || item.baitName == "Andere" || item.baitName == "andere"
                        {
                            self.baitsArr.remove(at: index)
                            self.baitsArr.append(item)
                            break
                        }
                    }
                    
                    
                    
                    
                    self.fishWgtArr = (response?.FishWeights)!
                    let othrWeight = FishWeightModal(_id: "", fishWeight: "Handmatig invoeren")
                    self.fishWgtArr.insert(othrWeight, at: 0)
                    
                    self.fishLengthArr = (response?.FishLengths)!
                    let othrLength = FishLengthModal(_id: "", fishLength: "Handmatig invoeren")
                    self.fishLengthArr.insert(othrLength, at: 0)
                    
                    self.rodArr = (response?.Rods)!
                    
                    for (index,item) in (response?.Rods)!.enumerated()
                    {
                        if item.rodName == "Other" || item.rodName == "other" || item.rodName == "Others" || item.rodName == "others" || item.rodName == "Andere" || item.rodName == "andere"
                        {
                            self.rodArr.remove(at: index)
                            self.rodArr.append(item)
                            break
                        }
                    }
          
                    self.waterDepArr = (response?.WaterDepths)!
                    let othrDepth = WaterDepthModal(_id: "", waterDepth: "Handmatig invoeren")
                    self.waterDepArr.insert(othrDepth, at: 0)
                    
                    self.perfTableView.dataSource = self
                    self.perfTableView.delegate = self
                    self.perfTableView.reloadData()
                    
                    
                    
                }
            }
        })
    }
}

extension AddYourPerformanceViewController : AddYourPerformanceTableViewCell2Delegate {
    func starRating(cell: Int, rating: Double) {
        //        if cell == 0{
        //
        //        }
        self.perfrData!.experienceRate = String(describing: rating)
        print(cell,rating,"rating")
    }
    func switchRating(switchRate: Int) {
        self.perfrData!.shareFriend = String(describing:switchRate)
        
    }
}



extension AddYourPerformanceViewController :PositionsViewControllerDelegate{
    
    func selectPosApi(imageObj: [positionsModal]) {
        // self.positionObj = imageObj
        // self.perfrData!.positionData = imageObj
        self.perfTableView.reloadData()
    }
}

extension AddYourPerformanceViewController : FishTypeDelegate {
    
    func fishesSelected(fishesIds : [String], fishesName :[String])
    {
        self.perfrData?.fishIDs = fishesIds
        self.self.perfrData?.fishNames = fishesName
        
        self.perfTableView.reloadData()
    }
    
}
extension AddYourPerformanceViewController :
    UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    // PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let capturedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            picker.dismiss(animated: true, completion: nil)
            ImageChoosen  = capturedImage
            //            awsUpload(image:ImageChoosen)
            
            self.cropping(capturedImage: ImageChoosen)
            
            
            //     awsUpload(image:ImageChoosen)
            //   self.uploadImageToAWS(pickedImage)
        }
        
        //self.profileImg.image = info
        
    }
    func cropping(capturedImage : UIImage)
    {
        let cropViewController = Mantis.cropViewController(image: capturedImage)
        cropViewController.delegate = self
        cropViewController.modalPresentationStyle = .fullScreen
        self.present(cropViewController, animated: false)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
        print("picker cancel.")
    }
    
        func awsUpload(image:UIImage)
        {
            let croppedImage : UIImage = image
            self.image = croppedImage
            if self.image.size.width > 750 || self.image.size.height > 750
            {
                let factor = self.image.size.width / 750
                self.image =  self.image.scaleImageToSize(newSize: CGSize(width: 750, height: self.image.size.height/factor))
            }
            //       else if self.image.size.height > 2436
            //       {
            //           let factor = self.image.size.height / 2436
            //           self.image =  self.image.scaleImageToSize(newSize: CGSize(width: self.image.size.width/factor, height: 2436))
            //       }
            self.uploadImageToAWS(self.image)
        }
    
    
    func uploadImageToAWS(_ img:UIImage)
    {
        // getting local path
        Utils.startLoading(self.view)
        var imageURL = NSURL()
        let imageName:String! = "trackApp";
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
        let localPath = (documentDirectory as NSString).appendingPathComponent(imageName!)
        let data = img.jpegData(compressionQuality: 0.1)
        do {
            try     data!.write(to: URL(fileURLWithPath: localPath), options: .atomic)
            
        } catch
        {
            print(error)
        }
        imageURL = NSURL(fileURLWithPath: localPath)
        let S3BucketName: String = Constant.bucketName;
        var _: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.uploadProgress = {(bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                //Update progress
                // AppUtils.stopLoading();
            })
        }
        let key : String = NSString(format: "my_profile/%@/%@.png", AppUtils.AppDelegate().userId,(String(round(NSDate().timeIntervalSince1970) * 1000).replacingOccurrences(of: ".", with: ""))) as String
        print(key)
        uploadRequest?.body = imageURL as URL
        uploadRequest?.key = key
        uploadRequest?.bucket = S3BucketName
        uploadRequest?.contentType = "image/" + ".png"
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest!).continueWith { (task) -> AnyObject? in
            DispatchQueue.main.async {
                Utils.stopLoading()
            }
            
            if let error = task.error
            {
                AppUtils.showToast(message: "errorfoundinuploadingKey".localized())
            }
            else
            {
                if task.result != nil
                {
                    DispatchQueue.main.async {
                        self.s3URL  = "http://s3.amazonaws.com/\(S3BucketName)/\(key)";
                        print("Uploaded to:\n\(self.s3URL)")
                        //  self.uploadImage()
                        self.perfrData?.statusImage = self.s3URL
                        self.perfTableView.reloadData()
                        
                    }
                }
                else
                {
                    AppUtils.showToast(message: "errorfoundinuploadingKey".localized())
                }
            }
            return nil
        }
    }
    func cameraPost()
    {
        let alert:UIAlertController=UIAlertController(title: "ChooseImageKey".localized(), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "ChooseexistingphotoKey".localized(), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.checkLibraryCalling()
        }
        let gallaryAction = UIAlertAction(title: "TakenewphotoKey".localized(), style: UIAlertAction.Style.default )             {
            UIAlertAction in
            self.checkCamera()
        }
        let cancelAction = UIAlertAction(title: "CancelKey".localized(), style: UIAlertAction.Style.default)       {
            UIAlertAction in
        }
        
        // Add the actions
        //  self.imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        //self.checkLibraryCalling()
    }
    func checkLibraryCalling()
    {
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            print("Access has been granted.")
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
            
        else if (status == PHAuthorizationStatus.denied) {
            print("Access has been denied..")
            let alert = UIAlertController(
                title: "IMPORTANTKey".localized(),
                message: "LibraryaccessrequiredforpickingupphotosKey".localized(),
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "CancelKey".localized(), style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "AllowLibraryKey".localized(), style: .cancel, handler: { (alert) -> Void in
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }))
            present(alert, animated: true, completion: nil)
            
        }
            
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            print("Access has been detemined.")
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        }
            
            
            
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
            let alert = UIAlertController(
                title: "IMPORTANTKey".localized(),
                message: "LibraryaccessrequiredforpickingupphotosKey".localized(),
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "CancelKey".localized(), style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "AllowLibraryKey".localized(), style: .cancel, handler: { (alert) -> Void in
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func checkCamera(){
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: callCamera() // Do your stuff here i.e. callCameraMethod()
        case .denied: alertToEncourageCameraAccessInitially()
        //  case .notDetermined: alertToEncourageCameraAccessInitially()
        default: callCamera()
        }
    }
    func callCamera()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = true
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.camera
        
        self.present(myPickerController, animated: true, completion: nil)
        NSLog("Camera");
    }
    func alertToEncourageCameraAccessInitially()
    {
        let alert = UIAlertController(
            title: "IMPORTANTKey".localized(),
            message: "CameraaccessrequiredforcapturingphotosKey".localized(),
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "CancelKey".localized(), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "AllowLibraryKey".localized(), style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }))
        present(alert, animated: true, completion: nil)
    }
    func uploadImage(){
        struct res:Decodable{
            var Success:Int
            var Message:String
        }
        DispatchQueue.main.async {
            
            //}
            Utils.startLoading(self.view)
            let url = "\(Constant.basicApi)/updateProfilePic"
            let dict:[String:Any] = ["userId":AppUtils.AppDelegate().userId,"imageUrl":self.s3URL]
            
            Service.sharedInstance.postRequest(Url:url,modalName: res.self , parameter: dict as [String:Any]) { (response, error) in
                DispatchQueue.main.async {
                    Utils.stopLoading()
                    
                    if let res = response?.Success
                    {
                        if res == 1{
                            AppUtils.showToast(message: (response?.Message)!)
                        }else{
                            AppUtils.showToast(message: (response?.Message)!)
                        }
                    }else{
                        // do in case of error
                    }
                }
            }
        }
    }
}

extension AddYourPerformanceViewController : UITextViewDelegate
{
    func textViewDidEndEditing(_ textView: UITextView)
    {
        self.perfrData?.status = textView.text
    }
}
extension AddYourPerformanceViewController : CropViewControllerDelegate
{
    public func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        
       // self.uploadImageToAWS(cropped)
        self.awsUpload(image: cropped)
        cropViewController .dismiss(animated: true, completion: nil)
    }
    
    public func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
        //  croppingHandler(nil,nil)
        cropViewController .dismiss(animated: true, completion: nil)
    }
    
    public func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage){
        //   croppingHandler(nil,nil)
        cropViewController .dismiss(animated: true, completion: nil)
    }
    
    
    
    public func cropViewControllerWillDismiss(_ cropViewController: CropViewController) {
        
    }
}
