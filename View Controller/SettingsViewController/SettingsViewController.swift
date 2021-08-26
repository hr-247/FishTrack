//
//  SettingsViewController.swift
//  TrackApp
//
//  Created by sanganan on 12/13/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import AWSS3
import AVFoundation
import AWSCore
import Mantis

class SettingsViewController: UIViewController,UINavigationControllerDelegate {
    private var imagePicker = UIImagePickerController()
    
    var title1 : String = String()
    var message  : String = String()
    var ImageChoosen = UIImage()
    var image = UIImage()
    var s3URL = String()
    
    //Outlets
    @IBOutlet weak var topCons: NSLayoutConstraint!
    @IBOutlet weak var profileImg: UIImageView!
    // @IBOutlet weak var subsLblCons: NSLayoutConstraint!
    @IBOutlet weak var subscriptionStatusLbl: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var updatePass: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var zoomDP: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updatePass.setTitle("UpdatepasswordKey".localized(), for: .normal)
        self.logOutBtn.setTitle("LogoutKey".localized(), for: .normal)
        self.deleteBtn.setTitle("DeleteKey".localized(), for: .normal)
        self.emailTextField.placeholder = "EMAILKey".localized()
        self.userNameTextField.placeholder = "USERNAMEKey".localized()
        profileBtn.contentEdgeInsets = UIEdgeInsets(top: -5, left: -5, bottom: 0, right: 0)
        imagePicker.delegate = self
        //     imagePicker.allowsEditing = true
        if AppUtils.getStringForKey(key: Constant.userImage) != nil{
            profileImg.sd_setImage(with: URL(string: AppUtils.getStringForKey(key: Constant.userImage)!), completed: nil)
        }else{
            profileImg.image = UIImage(named: "avatar1")
        }
        if AppUtils.getStringForKey(key: Constant.isPaid) == "1"
        {
            self.subscriptionStatusLbl.isHidden = false
            self.subscriptionStatusLbl.text = "YouarePremiumUsernowYourSubscriptionwillexpireonKey".localized() + "\(AppUtils.getStringForKey(key: Constant.subscriptionENd)!)"
        }else{
            self.subscriptionStatusLbl.isHidden = true
        }
        self.commonNavigationBar(title: "ProfileSettingsKey".localized(), controller: AppUtils.Controllers.settingsVC, badgeCount: "0")
        //  self.view.backgroundColor = Constant.Color.backGroundColor
        self.updatePass.backgroundColor = Constant.Color.navColor
        self.logOutBtn.backgroundColor = Constant.Color.navColor
        self.deleteBtn.backgroundColor = Constant.Color.navColor
        self.emailTextField.text = AppUtils.getStringForKey(key: Constant.email)
        self.userNameTextField.text = AppUtils.getStringForKey(key: Constant.username)
        //  imagePicker.delegate = self
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                self.topCons.constant = (UIScreen.main.bounds.height - (0.98*UIScreen.main.bounds.height))
                //                        self.subsLblCons.constant = (subsLblCons.constant - (0.5*subsLblCons.constant))
                return
            case 1334:
                self.topCons.constant = (UIScreen.main.bounds.height - (0.98*UIScreen.main.bounds.height))
                //                        self.subsLblCons.constant = (subsLblCons.constant - (0.3*subsLblCons.constant))
                return
            default:
                return
            }
        }
    }
    
    @IBAction func deleteAccntActn(_ sender: Any) {
        
        let alertController = UIAlertController(title: "DeleteKey".localized(), message: "deleteAccountKey".localized(), preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "YesKey".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.deleteAccApi()
        }
        
        let cancelAction = UIAlertAction(title: "NoKey".localized(), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancelled")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    
    
    @IBAction func profilPicOptn(_ sender: Any) {
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
        self.imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        //self.checkLibraryCalling()
    }
    
    
    @IBAction func logoutActn(_ sender: Any) {
        let alertController = UIAlertController(title: "LogoutKey".localized(), message: "AreyousureyouwanttoLogoutKey".localized(), preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OKKey".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.logOut()
        }
        
        let cancelAction = UIAlertAction(title: "CancelKey".localized(), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancelled")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func logOut() {
        let url  = "\(Constant.basicApi)/updateMyToken"
        Service.sharedInstance.postRequest(Url: url, modalName: TokenModal.self, parameter: ["deviceId":"","userId":AppUtils.AppDelegate().userId]) { (res, error) in
            //  print(res?.Success)
            if res?.Success == nil{
                DispatchQueue.main.async{
                    AppUtils.AppDelegate().userId = ""
                    AppUtils.AppDelegate().PerformanceModal = PerformanceHelperModal.init()
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    
                    let d = UserDefaults.standard
                    d.set("First", forKey: Constant.walkthrough)
                    d.synchronize()
                    let vc = AppUtils.Controllers.loginVC.get() as! LoginViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    //                    var count = (self.navigationController?.viewControllers.count)! - 1
                    self.removeVCFromStack(numberOFStack: 1)
                }
            }
        }
    }
    
    @IBAction func updatePassActn(_ sender: UIButton) {
        let vc = UpdatePasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func updateEmailActn(_ sender: UIButton) {
        
        self.title1 = "UpdateEmailKey".localized()
        self.message = ""
        self.alert(title : title1,message: message,tag: "Email", completion: {[weak self]
            (res) in
            //    print(res)
            self!.updateEmailApi(str: res)
        })
    }
    
    @IBAction func updateUserNameActn(_ sender: UIButton) {
        
        self.title1 = "UpdateUsernameKey".localized()
        self.message = ""
        self.alert(title : title1,message: message,tag : "User", completion: { [weak self](res) in
            self!.updateUserNApi(str: res)
            
        })
        
    }
    
    
    @IBAction func zoomDPActn(_ sender: Any) {
  
        
        if AppUtils.getStringForKey(key: Constant.userImage) != nil{
        if let img = AppUtils.getStringForKey(key: Constant.userImage)
        {
            let images : [URL] = [URL(string: img)!]
            
               Utils.imageTapped(index: 0, imageUrls: images, con: self)
            
        }
        
        }
        
    }
   
    
    //MARK:- UPDATE PASSWORD POST API
    func updatePassApi(str:String)
    {
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/updateUserPassword"
        let dict:[String:Any] = ["password": "maroon1996","userId":AppUtils.AppDelegate().userId]
        
        Service.sharedInstance.postRequest(Url:url,modalName: updateUserPasswordModal.self , parameter: dict as [String:Any]) { (response, error) in
            //  print("response", response as Any)
            DispatchQueue.main.async {
                Utils.stopLoading()
                if let res = response?.Success
                {
                    if res == 1{
                        
                        
                        AppUtils.showToast(message: "PasswordhasbeenupdatedKey".localized())
                    }else{
                        AppUtils.showToast(message: (response?.Message)!)
                    }
                }
            }
        }
    }
    //MARK:- UPDATE EMAIL API
    func updateEmailApi(str:String)
    {

        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/updateUserEmail"
        let dict:[String:Any] = ["email": str,"userId":AppUtils.AppDelegate().userId]
        
        Service.sharedInstance.postRequest(Url:url,modalName: UpdateUserEmailModal.self , parameter: dict as [String:Any]) { (response, error) in
            //  print("response", response as Any)
            DispatchQueue.main.async {
                Utils.stopLoading()
                if let res = response?.Success
                {
                    if res == 1{
                        self.emailTextField.text = str
                        AppUtils.setStringForKey(key: Constant.email, val: str)
                        AppUtils.showToast(message: "UseremailhasbeenupdatedKey".localized())
                    }else{
                        AppUtils.showToast(message: (response?.Message)!)
                    }
                }
            }
        }
    }
    //MARK:- UPDATE USER NAME API
    func updateUserNApi(str:String)
    {
        let nme = isValidUsrName(testStr: str.trimmingCharacters(in: .whitespacesAndNewlines))
        if nme == false{
            AppUtils.showToast(message: "InvalidUsnmeKey".localized())
            return
        }
        
        else if str.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            AppUtils.showToast(message: "UsernameNotBlnkKey".localized())
            return
        }
        
        else{
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/updateUserUsername"
        let dict:[String:Any] = ["username": str.trimmingCharacters(in: .whitespacesAndNewlines),"userId":AppUtils.AppDelegate().userId]
        
        Service.sharedInstance.postRequest(Url:url,modalName: updateUserUsernameModal.self , parameter: dict as [String:Any]) { (response, error) in
            //  print("response", response as Any)
            DispatchQueue.main.async {
                Utils.stopLoading()
                if let res = response?.Success
                {
                    if res == 1{
                        self.userNameTextField.text = str
                        AppUtils.setStringForKey(key: Constant.username, val: str)
                        AppUtils.showToast(message: "UsernamehasbeenupdatedKey".localized())
                    }else{
                        AppUtils.showToast(message: (response?.Message)!)
                    }
                }
            }
        }
    }
}
}
extension SettingsViewController : UIImagePickerControllerDelegate
{
    // PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let capturedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            picker.dismiss(animated: true, completion: nil)
            ImageChoosen  = capturedImage
//            awsUpload(image:ImageChoosen)
          
             self.cropping(capturedImage: ImageChoosen)
            
             self.profileImg.image = ImageChoosen
        }
        
        
    }
    
 
func cropping(capturedImage : UIImage)
{
    let cropViewController = Mantis.cropViewController(image: capturedImage)
    cropViewController.delegate = self
    cropViewController.modalPresentationStyle = .fullScreen
    self.present(cropViewController, animated: false)
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
    
    self.uploadImageToAWS(self.image)
    
    
    //       else if self.image.size.height > 2436
    //       {
    //           let factor = self.image.size.height / 2436
    //           self.image =  self.image.scaleImageToSize(newSize: CGSize(width: self.image.size.width/factor, height: 2436))
    //       }


}

func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
{
    self.dismiss(animated: true, completion: nil)
    print("picker cancel.")
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
                    self.uploadImage()
                    
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


// MARK:checkinPhotosAcess
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




func uploadImage(){
    struct res:Decodable{
        var Success:Int
        var Message:String
        var ProfileUrl : String
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
                        
                        let image = response?.ProfileUrl
                        
                        AppUtils.setStringForKey(key: Constant.userImage, val: image!)
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

// MARK: -  checkingCameraAccess
func callCamera(){
    let myPickerController = UIImagePickerController()
    myPickerController.delegate = self;
    myPickerController.sourceType = UIImagePickerController.SourceType.camera
    myPickerController.allowsEditing = true
    self.present(myPickerController, animated: true, completion: nil)
    NSLog("Camera");
}
func checkCamera() {
    let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    switch authStatus {
    case .authorized: callCamera() // Do your stuff here i.e. callCameraMethod()
    case .denied: alertToEncourageCameraAccessInitially()
    //  case .notDetermined: alertToEncourageCameraAccessInitially()
    default: callCamera()
    }
}

func alertToEncourageCameraAccessInitially() {
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



}
//MARK:- Compress Image
extension UIImage {
    
    func scaleImageToSize(newSize: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth = newSize.width/size.width
        let aspectheight = newSize.height/size.height
        
        let aspectRatio = max(aspectWidth, aspectheight)
        
        scaledImageRect.size.width = size.width * aspectRatio;
        scaledImageRect.size.height = size.height * aspectRatio;
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
extension SettingsViewController
{
    //MARK:- Delete account get API
    func deleteAccApi() {
        Utils.startLoading(self.view)
        let url : String = "\(Constant.basicApi)/deleteUser/\(AppUtils.AppDelegate().userId)"
        Service.sharedInstance.getRequest(Url:url,modalName:RejectRequestModal.self,completion: { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1
                {
                    let vc = AppUtils.Controllers.loginVC.get() as! LoginViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    AppUtils.showToast(message: "deleteAccKey".localized())
                }
            }
        })
    }
}
extension SettingsViewController : CropViewControllerDelegate
{
    public func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        
        //self.uploadImageToAWS(cropped)
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
