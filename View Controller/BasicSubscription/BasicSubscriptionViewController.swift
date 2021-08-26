//
//  BasicSubscriptionViewController.swift
//  TrackApp
//
//  Created by Ankit  Jain on 18/07/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import UIKit

class BasicSubscriptionViewController: UIViewController {

    @IBOutlet weak var yearBtn: UIButton!
    @IBOutlet weak var monthBtn: UIButton!
    @IBOutlet weak var txtLbl: UILabel!
    fileprivate lazy var paymentID:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtLbl.text = "Track_013".localized()
        self.monthBtn.setTitle("Track_014".localized(), for: .normal)
        self.monthBtn.titleLabel?.numberOfLines = 0
        
        self.yearBtn.setTitle("Track_015".localized(), for: .normal)
        self.yearBtn.titleLabel?.numberOfLines = 0
        InAppServiceService.shared.getProduct()

        NotificationCenter.default.addObserver(self, selector: #selector(paymentInitiate1), name: NSNotification.Name(rawValue: "PAYMENTINITIATE"), object: nil)
               NotificationCenter.default.addObserver(self, selector: #selector(paymentCompleted1), name: NSNotification.Name(rawValue: "PAYMENTCOMPLETED"), object: nil)
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func monthlyBtnTapped(_ sender: Any) {
        
        AppUtils.AppDelegate().monthly = 1

        InAppServiceService.shared.purchase(product: .basic_monthly)
    }
    
    @IBAction func yearlyBtnTapped(_ sender: Any) {
        AppUtils.AppDelegate().monthly = 0

        InAppServiceService.shared.purchase(product: .basic_yearly)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BasicSubscriptionViewController {
    
    @objc func paymentInitiate1(){
        Utils.startLoading(self.view)
        let request:[String:Any] = ["userId":AppUtils.AppDelegate().userId]
        let url:String           = "\(Constant.basicApi)/initiatePayment"
        
        Service.sharedInstance.postRequest(Url: url, modalName: InitiatePaymentModal.self, parameter: request) { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
              //  print(response)
                if response?.Success == 1{
                    self.paymentID = (response?.paymentCraeted?._id)!
                }
            }
            
        }
    }
    @objc func paymentCompleted1(_ noti:Notification){
        Utils.startLoading(self.view)
        let data = ((noti.object)as! NSDictionary).value(forKey: "Status") as! Int
        let jsonData = ((noti.object)as! NSDictionary).value(forKey: "json") as! Any
        var request:[String:Any] = [String:Any]()
//        "monthly" : 1,
//
        
        if data == 4402{
            request = ["paymentId":self.paymentID,"paymentStatus":data,"userId":AppUtils.AppDelegate().userId,"paymentGateWayResp":jsonData,"purhaseType": 3500, "monthly" : AppUtils.AppDelegate().monthly]
        }else{
            request = ["paymentId":self.paymentID,"paymentStatus":data,"userId":AppUtils.AppDelegate().userId,"paymentGateWayResp":"","purhaseType": 3500, "monthly" : AppUtils.AppDelegate().monthly]
        }
        let url:String           = "\(Constant.basicApi)/updatePaymentStatus"
        
        Service.sharedInstance.postRequest(Url: url, modalName: UpdatePaymentStatusModal.self, parameter: request) { (response, error) in
            DispatchQueue.main.async {
                Utils.stopLoading()
                if response?.Success == 1 {
                    if data == 4402
                    {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    AppUtils.showToast(message: (response?.Message)!)
                }
            }
            
        }
    }
}
