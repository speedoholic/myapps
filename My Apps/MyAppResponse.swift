//
//  MyAppResponse.swift
//  My Apps
//
//  Created by Kushal Ashok on 3/15/19.
//  Copyright © 2019 my. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class MyAppResponse: Object, Mappable, RealmObject {
    
    @objc dynamic var resultCount = 0
    var results = List<MyApp>()
    
    required convenience init?( map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        resultCount <- map["count"]
        results <- (map["results"], ListTransform<MyApp>())
    }
}
