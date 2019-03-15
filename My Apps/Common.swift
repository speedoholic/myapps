//
//  Common.swift
//  My Apps
//
//  Created by Kushal Ashok on 3/16/19.
//  Copyright © 2019 my. All rights reserved.
//

import Foundation
import ObjectMapper

class Service: NSObject {
    static let shared = Service()
}


extension Service: Requestable {
    func getAppDetails<T: Mappable>(_ bundleId: String, mapType:T.Type, mappedObjectHandler: ((_ object: T) -> Void)?) {
        _ = setupNetworkComponentWith(netapi: NetworkAPI.appDetails(bundleId: bundleId), mapType: mapType, hideProgressHUD: false, mappedObjectHandle: mappedObjectHandler) { (message) in
            switch message {
            case .success:
                print("Success")
            case .fail(let errorString):
                print(errorString)
            }
        }
    }
}
