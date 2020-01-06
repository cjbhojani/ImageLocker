//
//  NBSServiceManager.swift
//  DemoBank
//
//  Created by Vikram on 11/26/16.
//  Copyright © 2016 SDL. All rights reserved.
//

import UIKit
import Alamofire
import Reachability
// swiftlint:disable all
enum API : String {
    static let BaseURL = "http://laundrypackz.com/api/"
    case login = "auth/login"
    case zipcodeList = "Zipcode/zipcodeList"
    case register = "auth/userRegistration"
    case changePassword = "auth/changePassword"
    case serviceList = "service/list"
    case profile = "user/profile"
    case schedule = "booking/request"
    case forgotPassword = "auth/forgotPassword"
    case providerOrderList = "provider/providerOrderList"
    case acceptDecline = "booking/acceptDecline"
    case bookingPaymentHistory = "payment/bookingPaymentHistory"
    
    // jobs
    var URL : String {
        get{
            return API.BaseURL + self.rawValue
        }
    }
}

class ServiceManager: NSObject {
    var headers: HTTPHeaders?
    
    static let sharedInstance : ServiceManager = {
        let instance = ServiceManager()
        return instance
    }()
    
    func postRequest(parameterDict: [String: Any], URL aUrl: String,
                     block: @escaping (NSDictionary?, NSError?) -> Void) {
        print("URL: \(aUrl)")
        print("Param: \(parameterDict)")
        
        
        
        
        if Reachability.Connection.self != .none {
//            LoadingView.startLoading()
            Alamofire.request(aUrl, method: .post, parameters: parameterDict, encoding: URLEncoding.default, headers: headers.self).responseJSON { response in
                switch response.result {
                case .success:
                    print("response: \(response)")
                    do {
//                        LoadingView.stopLoading()
                        if let result = response.result.value {
                            let JSON = result as? NSDictionary
                            if JSON != nil {
                                let status: String = JSON?.value(forKey: "status") as? String ?? "success"
                                if status == "success" {
                                    block(JSON,nil)
                                }
                                else {
                                    SnackBar.show(strMessage: JSON?.value(forKey: "message") as! String, type: .nagative)
                                }
                            }
                        } else {
//                            SnackBar.show(strMessage: ErrorMesssages.wrong, type: .nagative)
                        }
                    }
                    break
                case .failure(let error):
//                    LoadingView.stopLoading()
                    print(error)
                }
            }
        }
        else
        {
//            SnackBar.show(strMessage: ErrorMesssages.net, type: .nagative)
        }
    }
    
    func getRequest(parameterDict:[String : Any], URL aUrl: String, isLoader: Bool?, block: @escaping (NSDictionary?, NSError?) -> Void) {
        
        print("URL: \(aUrl)")
        print("Param: \(parameterDict)")
        
        if Connectivity.isConnectedToInternet {
            
            if isLoader! {
                
            }
            Alamofire.request(aUrl, method: HTTPMethod.get , parameters: parameterDict,encoding: URLEncoding.httpBody, headers: nil).responseJSON {
            response in
                
            if isLoader! {
                
            }
            switch response.result {
            case .success:
                do {
                    
                    print("response: \(response)")
                    if let result = response.result.value {
                        let JSON = result as? NSDictionary
                        if JSON != nil {
                            block(JSON,nil)
                        } else {
                            let arrData = result as? NSArray
                            let dicData = ["data":arrData]
                            block(dicData as NSDictionary,nil)
                        }
                    }
                }
                break
                case .failure(let error):
                    print(error)
                
//                    SnackBar.show(strMessage: ErrorMesssages.wrong, type: .nagative)
                }
            }
        }
        else{
//            LoadingView.stopLoading()
        }
    }
    
    
    func uplaodImagesWithParameter(URL: String, param: [String : Any], imageDataArray: UIImage, header : HTTPHeaders, block: @escaping (NSDictionary?, NSError?) -> Void){
        
        let imgData = imageDataArray.jpegData(compressionQuality: 0.5)
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData!, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
                for (key, value) in param {
                    multipartFormData.append(String("\(value)").data(using: String.Encoding.utf8)!, withName: key )
                    
                } //Optional for extra parameters
            },
            to: URL,method:HTTPMethod.post,
            headers:header, encodingCompletion: { encodingResult in
                
            switch encodingResult {
            case .success(let upload, _, _):
                upload
                    .validate()
                    .responseJSON { response in
                        switch response.result {
                        case .success:
                            do {
                                if let result = response.result.value {
                                    let JSON = result as! NSDictionary
                                    block(JSON,nil)
                                }
                            }
                        case .failure(let responseError):
                            print("responseError: \(responseError)")
                        }
                }
                case .failure(let encodingError):
                print("encodingError: \(encodingError)")
            }
        })
    }
}

extension URL {
    /// Creates an NSURL with url-encoded parameters.
    init?(string : String, parameters : [String : String]) {
        guard var components = URLComponents(string: string) else { return nil }
        components.queryItems = parameters.map { return URLQueryItem(name: $0, value: $1) }
        guard let url = components.url else { return nil }

        // Kinda redundant, but we need to call init.
        self.init(string: url.absoluteString)
    }
}

