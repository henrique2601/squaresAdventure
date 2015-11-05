//
//  IAPHelper.swift
//  Squares Adventure
//
//  Created by Pablo Henrique on 14/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import StoreKit

class IAPHelper: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static var sharedInstance = IAPHelper()
    
    let productIdentifiers = Set<String>(arrayLiteral:
        "diamondPackage1",
        "diamondPackage2",
        "diamondPackage3",
        "coinsPackage1",
        "coinsPackage2",
        "coinsPackage3"
    )
    
    override init() {
        super.init()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    func requestProducts(){
        let productsRequest = SKProductsRequest(productIdentifiers: self.productIdentifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("productsRequest")
        print(request.description)
        print("didReceiveResponse")
        print(response.description)
        
        print("response.invalidProductIdentifiers")
        print(response.invalidProductIdentifiers.description)
        
        print(response.products.count)
        for skProduct in response.products {
            print(skProduct.productIdentifier)
            print(skProduct.localizedTitle)
            print(skProduct.price.floatValue)
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("queue")
        print(queue.description)
        print("removedTransactions")
        print(transactions.description)
    }
    
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError) {
        print("queue")
        print(queue.description)
        print("restoreCompletedTransactionsFailedWithError")
        print(error.description)
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        print("queue")
        print(queue.description)
        print("updatedDownloads")
        print(downloads.description)
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("queue")
        print(queue.description)
        print("updatedTransactions")
        print(transactions.description)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("paymentQueueRestoreCompletedTransactionsFinished")
        print(queue.description)
    }
}






