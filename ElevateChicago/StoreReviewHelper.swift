//
//  StoreReviewHelper.swift
//  ElevateChicago
//
//  Created by Sam Siner on 7/28/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import Foundation
import StoreKit

struct StoreReviewHelper {
    static func incrementAppOpenedCount() { // called from appdelegate didfinishLaunchingWithOptions:
        guard var appOpenCount = UserDefaults.standard.value(forKey: "APP_OPENED_COUNT") as? Int else {
            UserDefaults.standard.set(1, forKey: "APP_OPENED_COUNT")
            return
        }
        appOpenCount += 1
        UserDefaults.standard.set(appOpenCount, forKey: "APP_OPENED_COUNT")
    }
    static func checkAndAskForReview() { // call this whenever appropriate
        // this will not be shown everytime. Apple has some internal logic on how to show this.
        guard let appOpenCount = UserDefaults.standard.value(forKey: "APP_OPENED_COUNT") as? Int else {
            UserDefaults.standard.set(1, forKey: "APP_OPENED_COUNT")
            return
        }
        print("App run count is : \(appOpenCount)")

        switch appOpenCount {
        case 10,50:
            StoreReviewHelper().requestReview()
        case _ where appOpenCount%100 == 0 :
            StoreReviewHelper().requestReview()
        default:
            break;
        }
        
    }
    fileprivate func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
}
