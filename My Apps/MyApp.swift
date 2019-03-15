//
//  MyApp.swift
//  My Apps
//
//  Created by Kushal Ashok on 3/15/19.
//  Copyright © 2019 my. All rights reserved.
//
import UIKit
import RealmSwift
import ObjectMapper

public class MyApp: Object, Mappable, RealmObject {
    
    @objc dynamic var uuid = UUID.init().uuidString
    @objc dynamic var bundleId = ""
    @objc dynamic var sellerName = ""
    @objc dynamic var version = ""
    @objc dynamic var name = ""
    @objc dynamic var itunesUrlString = ""
    @objc dynamic var releaseNotes = ""
    @objc dynamic var appdDescription = ""
    @objc dynamic var genre = ""
    @objc dynamic var releaseDateString = ""
    
    required convenience public init?( map: Map) {
        self.init()
    }
    
    override public class func primaryKey() -> String {
        return "bundleId"
    }
    
    public func mapping(map: Map) {
        bundleId <- map["bundleId"]
        sellerName <- map["sellerName"]
        version <- map["version"]
        name <- map["name"]
        itunesUrlString <- map["itunesUrlString"]
        releaseNotes <- map["releaseNotes"]
        appdDescription <- map["description"]
        genre <- map["genre"]
        releaseDateString <- map["releaseDateString"]
        self.update()
    }
    
    
}


