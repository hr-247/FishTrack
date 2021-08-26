//
//  InAppServiceService.swift
//  TrackApp
//
//  Created by shubham tyagi on 02/01/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import UIKit
import StoreKit


final class InAppServiceService: NSObject {
    static let shared           = InAppServiceService()
    private var products        = [SKProduct]()
    private let paymentQueue    = SKPaymentQueue.default()
    private override init() {
        super .init()
    }
    
    public func getProduct(){
        let products1:Set = [AppUtils.purchase.basic_monthly.rawValue, AppUtils.purchase.basic_yearly.rawValue, AppUtils.purchase.premium_monthly.rawValue,AppUtils.purchase.premium_yearly.rawValue]
        let request      = SKProductsRequest(productIdentifiers: products1)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    public func purchase(product: AppUtils.purchase){
        
        guard let productToPurchase = products.filter({$0.productIdentifier == product.rawValue}).first  else {
            return
        }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    func restorePurchase(){
        print("restoring purchaing")
        paymentQueue.restoreCompletedTransactions()
    }
}


extension InAppServiceService: SKProductsRequestDelegate{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response.products)
        if !response.invalidProductIdentifiers.isEmpty {
            print("Invalid products identifiers received")
        }
        self.products = response.products
        //self.request = nil
        for product in response.products{
            print(product.localizedTitle)
        }
    }
    func request(_ request: SKRequest, didFailWithError error:Error) {
        print("Product request failed: \(error.localizedDescription)")
    }
}


extension InAppServiceService : SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for item in transactions
        {
            switch item.transactionState{
            case .purchasing:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PAYMENTINITIATE"), object: nil)
                break
            case .purchased:
                self.receiptValidation()
                queue.finishTransaction(item)
                break
            case .failed :
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PAYMENTCOMPLETED"), object: ["Status":4401])
                queue.finishTransaction(item)
            default:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PAYMENTCOMPLETED"), object: ["Status":4400])
                queue.finishTransaction(item)
            }
        }
    }
    
    func receiptValidation() {
        
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        AppUtils.setStringForKey(key: Constant.isPaymentDone, val: recieptString!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PAYMENTCOMPLETED"), object: ["Status":4402,"json":recieptString])
        
        
//        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject, "password" : "ee70188badc24b1fa8c78f1ddb4cbb3a" as AnyObject]
        
//        do {
//            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
//            let storeURL = URL(string: Constant.sandboxUrl)!
//            var storeRequest = URLRequest(url: storeURL)
//            storeRequest.httpMethod = "POST"
//            storeRequest.httpBody = requestData
//
//            let session = URLSession(configuration: URLSessionConfiguration.default)
//            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
//
//                DispatchQueue.main.async {
//
//                do {
//                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
//                    print("=======>",jsonResponse)
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PAYMENTCOMPLETED"), object: ["Status":4402,"json":jsonResponse])
//                    if let date = self?.getExpirationDateFromResponse(jsonResponse as! NSDictionary) {
//                        print(date)
//                    }
//                } catch let parseError {
//                    print(parseError)
//                }
//                }
//            })
//            task.resume()
//        } catch let parseError {
//            print(parseError)
//        }
        
    }
    func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
        
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
            
            let lastReceipt = receiptInfo.lastObject as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            if let expiresDate = lastReceipt["expires_date"] as? String {
                return formatter.date(from: expiresDate)
            }
            
            return nil
        }
        else {
            return nil
        }
    }
}

extension SKPaymentTransactionState{
    fileprivate func status() -> String{
        switch self{
        case .deferred    : return("deferred")
        case .failed      : return("failed")
        case .purchased   : return("purchased")
        case .purchasing  : return("purchasing")
        case .restored    : return("restored")
        @unknown default:
            return("")
        }
    }
}
