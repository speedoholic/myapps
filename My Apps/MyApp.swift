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
    @objc dynamic var trackName = ""
    @objc dynamic var trackViewUrl = ""
    @objc dynamic var releaseNotes = ""
    @objc dynamic var appDescription = ""
    @objc dynamic var primaryGenreName = ""
    @objc dynamic var releaseDate = ""
    @objc dynamic var artworkUrl512 = ""
    
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
        trackName <- map["trackName"]
        trackViewUrl <- map["trackViewUrl"]
        releaseNotes <- map["releaseNotes"]
        appDescription <- map["description"]
        primaryGenreName <- map["primaryGenreName"]
        releaseDate <- map["releaseDate"]
        artworkUrl512 <- map["artworkUrl512"]
        self.update()
    }
    
    
}


