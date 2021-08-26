//
//  PurchaseService.swift
//  TrackApp
//
//  Created by shubham tyagi on 31/12/19.
//  Copyright © 2019 Sanganan. All rights reserved.
//

import UIKit
import StoreKit

@available(iOS 13.0, *)
class PurchaseService: NSObject {
    private override init() {}
    static let shared = PurchaseService()
    var products = [SKProduct]()
    let paymenyQueue = SKPaymentQueue.default()
    
    func getProduct(){
        let purchaseType:Set<String> = [AppUtils.purchase.autorenewable.rawValue]
        let request = SKProductsRequest(productIdentifiers: purchaseType)
        request.delegate = self
        request.start()
        paymenyQueue.add(self)
        
    }
    func purchase(product:AppUtils.purchase){
        guard let productToPurchase = self.products.filter({$0.productIdentifier == product.rawValue}).first else {return}
        let payment = SKPayment(product: productToPurchase)
        paymenyQueue.add(payment)
    }
    func restorePurchase(){
        paymenyQueue.restoreCompletedTransactions()
    }
}
@available(iOS 13.0, *)
extension PurchaseService: SKProductsRequestDelegate
{
func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    self.products = response.products
    for product in response.products
    {
        print(product.localizedTitle)
    }
}
}

@available(iOS 13.0, *)
extension PurchaseService:SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for item in transactions{
            print(item.transactionState.status())
            switch item.transactionState {
            case .purchasing:
                break
            default:
                queue.finishTransaction(item)
            }
        }
    }
    
    
}

extension SKPaymentTransactionState{
    func status() -> String {
        switch self {
        case .deferred:   return("deferred")
        case .failed:     return("failed")
        case .purchased:  return("purchased")
        case .purchasing: return("purchasing")
        case .restored:   return("restored")
        }
}
}
