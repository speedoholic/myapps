//
//  RealmHelper.swift
//  My Apps
//
//  Created by Kushal Ashok on 3/15/19.
//  Copyright © 2019 my. All rights reserved.
//

import Foundation
import RealmSwift

let realmHelper = RealmHelper.shared

protocol RealmObject {
    func save()
    func update()
}
extension RealmObject {
    func save() {
        if let object = self as? Object {
            realmHelper.writeToRealm {realmHelper.realm().add(object)}
        }
    }
    func update() {
        if let object = self as? Object {
            realmHelper.writeToRealm {realmHelper.realm().add(object, update: true)}
        }
    }
}

class RealmHelper: NSObject {
    static let shared: RealmHelper = RealmHelper()
    
    // path for realm file
    lazy private var realmURL: URL = {
        let documentUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = documentUrl.appendingPathComponent("default.realm")
        print("\n\nRealm file is located at: \n\(url)\n")
        return url
    }()
    lazy private var config:Realm.Configuration = {
        return Realm.Configuration(
            fileURL: self.realmURL,
            inMemoryIdentifier: nil,
            encryptionKey:nil, //"my65bitkey".data(using: String.Encoding.utf8),
            readOnly: false,
            schemaVersion: 1,
            migrationBlock: nil,
            deleteRealmIfMigrationNeeded: false,
            objectTypes: nil)
    }()
    
    
    /// Method used to remove the Realm database files when there are any configuration changes
    func clearRealmFiles() {
        let documentUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = documentUrl.appendingPathComponent("default.realm")
        let lockFile = documentUrl.appendingPathComponent("default.realm.lock")
        let managerFolder = documentUrl.appendingPathComponent("default.realm.management")
        do {
            try FileManager.default.removeItem(at: url)
            try FileManager.default.removeItem(at: lockFile)
            try FileManager.default.removeItem(at: managerFolder)
        }
        catch{
            print(error)
        }
    }
    
    func inMemoryRealm() -> Realm? {
        do {
            let realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))
            return realm
        } catch {
            do {
                let realm = try Realm(configuration: config)
                return realm
            }catch{
                print(error)
            }
            print(error)
        }
        return try! Realm()
    }
    
    func realm() -> Realm {
        do {
            // Get the default Realm
            let realm = try Realm(configuration: config)
            return realm
        } catch {
            self.clearRealmFiles()
            do {
                let realm = try Realm(configuration: config)
                return realm
            }catch{
                print(error)
            }
            print(error)
        }
        return try! Realm()
    }
    func writeToRealm(_ closure: () -> Void) {
        do {
            try realm().write {
                closure()
            }
        } catch {
            print(error)
        }
    }
    func getObjects<T: Object>(_ type: T.Type, filterString: String?) -> Results<T>? {
        if let filter = filterString {
            return realm().objects(type).filter(filter)
        } else {
            return realm().objects(type)
        }
    }
    func getObjects<T: Object>(_ type: T.Type, valueForKey key: String?) -> Any? {
        if let keyString = key {
            return realm().objects(type).value(forKey: keyString)
        } else {
            return realm().objects(type)
        }
    }
    func deleteObjects<T: Object>(_ type: T.Type, filterString: String?) {
        var objects: Results<T>?
        if let filter = filterString {
            objects  = realm().objects(type).filter(filter)
        } else {
            objects  = realm().objects(type)
        }
        guard let objectsToBeDeleted = objects else {return}
        writeToRealm {realm().delete(objectsToBeDeleted)}
    }
    func deleteAll() {
        writeToRealm {realm().deleteAll()}
    }
}

extension Object {
    func toDictionary() -> NSDictionary {
        let properties = self.objectSchema.properties.map { $0.name }
        let dictionary = self.dictionaryWithValues(forKeys: properties)
        let mutabledic = NSMutableDictionary()
        mutabledic.setValuesForKeys(dictionary)
        
        for prop in self.objectSchema.properties {
            // Find lists
            if let nestedObject = self[prop.name] as? Object {
                mutabledic.setValue(nestedObject.toDictionary(), forKey: prop.name)
            } else if let nestedListObject = self[prop.name] as? ListBase {
                var objects = [AnyObject]()
                for index in 0..<nestedListObject._rlmArray.count  {
                    //Find list of Objects
                    if let object = nestedListObject._rlmArray[index] as? Object {
                        objects.append(object.toDictionary())
                    }
                        //Find list of Strings
                    else if let object = nestedListObject._rlmArray[index] as? String {
                        objects.append(object as AnyObject)
                    }
                }
                mutabledic.setObject(objects, forKey: prop.name as NSCopying)
            }
        }
        return mutabledic
    }
}

