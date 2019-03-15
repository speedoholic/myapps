//
//  Networkable.swift
//  My Apps
//
//  Created by Kushal Ashok on 3/15/19.
//  Copyright © 2019 my. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import PKHUD
import Reachability

let DEFAULTERROR = "Something went wrong"

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

protocol NetworkTargetType {
    var baseURL: String { get }
    var urlPath: String { get }
    var method: Alamofire.HTTPMethod { get }
    var parameters: [String: AnyObject]? { get }
}

enum NetworkAPI {
    case appDetails(bundleId: String)
}

enum CSMessage {
    case success(String)
    case fail(String)
}


extension NetworkAPI: NetworkTargetType {
    
    /// Base URL string
    var baseURL: String {
        return "http://itunes.apple.com/"
    }
    
    /// Request URL
    var urlPath: String {
        switch self {
        case .appDetails(let bundleId):
            return baseURL + "lookup?bundleId=\(bundleId)"
        }
    }
    
    /// Request method
    var method: Alamofire.HTTPMethod {
        switch self {
        case .appDetails:
            return .get
        }
    }
    
    /// parameters
    var parameters: [String: AnyObject]? {
        switch self {
        case .appDetails:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .appDetails:
            return ["Content-Type":"application/json"]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .appDetails:
            return URLEncoding.default
        }
    }
    
    var errorMessage: String {
        switch self {
        default:
            return "Something went wrong"
        }
    }
    
    /// Should print request or not
    var isPrintRequest: Bool {
        return true
    }
    
    
}

protocol Requestable: class {
    func setupNetworkComponentWith<T: Mappable>(netapi: NetworkAPI, mapType: T.Type, hideProgressHUD:Bool, mappedObjectHandle: ((_ object: T) -> Void)?, moreInfo: ((_ message: CSMessage) -> Void)?) -> Request
}

extension Requestable where Self: NSObject {
    /// NetworkComponent init
    func setupNetworkComponentWith<T: Mappable>(netapi: NetworkAPI, mapType: T.Type, hideProgressHUD:Bool, mappedObjectHandle: ((_ object: T) -> Void )?, moreInfo: ((_ message: CSMessage) -> Void )?) -> Request {
        
        //Show a loading indicator
        if hideProgressHUD {
            print("No HUD")
        } else if (UIApplication.shared.keyWindow != nil) {
            HUD.show(HUDContentType.progress)
        }
        
        // start request address
        let request = Alamofire.request(netapi.urlPath, method: netapi.method, parameters: netapi.parameters, encoding: netapi.encoding, headers:netapi.headers ).responseJSON { (response) in
            if hideProgressHUD {
                print("No HUD to hide")
            }
            else {
                HUD.hide()
            }
            switch response.result {
            case .success(let value):
                guard let responseJSON = value as? [String: Any] else {
                    //We should be able to read the response as JSON
                    moreInfo?(CSMessage.fail(DEFAULTERROR))
                    return
                }
                if let mapObject = Mapper<T>().map(JSON: responseJSON) {
                    mappedObjectHandle?(mapObject)
                    moreInfo?(CSMessage.success("Mapped Successfully"))
                } else {
                    moreInfo?(CSMessage.fail("Object mapping failed"))
                }
            case .failure(let error):
                print("failure:" + error.localizedDescription)
                moreInfo?(CSMessage.fail(error.localizedDescription))
            }
        }
        if netapi.isPrintRequest { request.debugPringRequest() }
        return request
    }
    
}

extension Request {
    /// print request parameters
    func debugPringRequest() {
        print("-----------------------------------------------------------------------")
        guard let httpBodyData = self.request?.httpBody else { print("request: \( self)"); return }
        guard let parameterString = String(data: httpBodyData, encoding:String.Encoding.utf8) else { print("request: \(self)"); return }
        print("request: \(self)")
        print("parameters: \(parameterString)")
        print("-----------------------------------------------------------------------")
    }
    /// get Request parameters
    func getUniqueRequestString() -> String? {
        guard let urlString = self.request?.url?.relativePath else { return nil }
        guard let httpBodyData = self.request?.httpBody else { return urlString }
        guard let parameterString = String(data: httpBodyData, encoding:String.Encoding.utf8) else { return urlString }
        return "\(urlString)?\(parameterString)"
    }
}

