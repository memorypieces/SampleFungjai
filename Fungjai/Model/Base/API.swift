//
//  API.swift
//  AALib
//
//  Created by BSD_MAC_Pro2 on 15/1/18.
//  Copyright © 2018 BSD_MAC_Pro2. All rights reserved.
//

import Foundation

import Alamofire
import ObjectMapper
import Fabric
import Crashlytics
import SwiftyJSON
import PopupDialog

class API {
    
    typealias GetErrorClosure = ((_ rawResponse:Any) -> (Error?))
    typealias GetDataClosure = ((_ rawResponse:Any) -> Any?)
    typealias CustomJSONEncode = ((URLRequestConvertible, [String: Any]?) -> (URLRequest, Error?))
    
    static var configuration:URLSessionConfiguration{
        get {
            let c:URLSessionConfiguration = URLSessionConfiguration.default
            c.timeoutIntervalForRequest = 5.0 //Default timeout for request connection
            c.timeoutIntervalForResource = 5.0
            return c
        }
    }
    
    static let alamofireManager = Alamofire.SessionManager(configuration: API.configuration)
    
    static func request(
        functionName: StaticString = #function,
        file: String = #file, line: Int = #line,
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        retryCount:Int = 3,
        response:@escaping (DataResponse<Any>) -> Void) -> DataRequest //Default Retry Count
    {
        
        var dataRequest = alamofireManager.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: ModHeader(header: headers)
        )
        
        dataRequest.responseJSON() { (res) in
            switch res.result {
            case .failure(_):
                let retry = retryCount - 1
                
                if retry < 0
                {
                    
                    print("\n!!!-----API-Error------!!!\n\n   file : \(file)\n   line : \(line)\n   functionName : \(functionName)  \n url : \(String(describing: dataRequest.request?.url?.absoluteString))\n\n!!!---------------------!!!\n")
                    
                    let  message = "ไม่สามารถเชื่อมต่อได้"
                    let title = "การเชื่อมต่อขัดข้อง"
                    
                    let popup = PopupDialog(title: title, message: message, image: nil)
                    
                    let buttonOne = CancelButton(title: "ปิด") {
                        response(res)
                        return
                    }
                    
                    let buttonTwo = DefaultButton(title: "ลองอีกครั้ง") {
                        print("Retry count :\(retry)")
                        dataRequest = request(functionName:functionName,file:file, line:line,url, method: method, parameters: parameters, encoding: encoding, headers: headers, retryCount: 2, response: response)
                    }
                    
                    popup.addButtons([buttonOne, buttonTwo])
                    Utilities.topMostControllerIgnorePopupDialog?.present(popup, animated: true, completion: nil)
                }
                else{
                    print("Retry count :\(retry)")
                    dataRequest = request(functionName:functionName,file:file, line:line,url, method: method, parameters: parameters, encoding: encoding, headers: headers, retryCount: retry, response: response)
                }
                
                //                if retry < 0 {
                //                    response(res)
                //                    return
                //                }
                //                print("Retry count :\(retry)")
                //                dataRequest = request(functionName:functionName,url, method: method, parameters: parameters, encoding: encoding, headers: headers, retryCount: retry, response: response)
                break
            case .success(_):
                let json = JSON(res.data ?? Data())
                
                guard let status = json["status_code"].int else {
                    response(res)
                    return
                }
                
                if status == 209 // Token Expired
                {
                    let retry = retryCount - 1
                    
                    if retry < 0 {
                        response(res)
                        return
                    }
                    
                    return
                }
                else
                {
                    response(res)
                }
                break
            }
        }
        return dataRequest
    }
    
    static func ModHeader(header:HTTPHeaders?) -> HTTPHeaders? {
        
        if let mHeader = header {
            return mHeader
        }else{
            let theHeader = [String:String]()
            return theHeader
        }
        
    }
    
    static func requestWithBody(
        functionName: StaticString = #function,
        file: String = #file, line: Int = #line,
        url : URLRequestConvertible,
        retryCount:Int = 3,
        response:@escaping (DataResponse<Any>) -> Void) -> DataRequest //Default Retry Count
    {
        
        var dataRequest = Alamofire.request(url)
        dataRequest.responseJSON() { (res) in
            switch res.result {
            case .failure(_):
                let retry = retryCount - 1
                
                if retry < 0
                {
                    print("\n!!!-----API-Error------!!!\n\n   file : \(file)\n   line : \(line)\n   functionName : \(functionName)  \n url : \(String(describing: dataRequest.request?.url?.absoluteString))\n\n!!!---------------------!!!\n")
                    
                    let  message = "ไม่สามารถเชื่อมต่อได้"
                    let title = "การเชื่อมต่อขัดข้อง"
                    
                    let popup = PopupDialog(title: title, message: message, image: nil)
                    
                    let buttonOne = CancelButton(title: "ปิด") {
                        response(res)
                        return
                    }
                    
                    let buttonTwo = DefaultButton(title: "ลองอีกครั้ง") {
                        print("Retry count :\(retry)")
                        dataRequest = requestWithBody(functionName:functionName,file:file, line:line,url: url,retryCount: 2, response: response)
                    }
                    
                    popup.addButtons([buttonOne, buttonTwo])
                    Utilities.topMostControllerIgnorePopupDialog?.present(popup, animated: true, completion: nil)
                }
                else{
                    print("Retry count :\(retry)")
                    dataRequest = requestWithBody(functionName:functionName,file:file, line:line,url: url,retryCount: retry, response: response)
                }
                
                //                if retry < 0 {
                //                    response(res)
                //                    return
                //                }
                //                print("Retry count :\(retry)")
                //                dataRequest = requestTest(functionName:functionName,url, method: method, parameters: parameters, encoding: encoding, headers: headers, retryCount: retry, response: response)
                break
            case .success(_):
                let json = JSON(res.data ?? Data())
                
                guard let status = json["status_code"].int else {
                    response(res)
                    return
                }
                
                if status == 209 // Token Expired
                {
                    let retry = retryCount - 1
                    
                    if retry < 0 {
                        response(res)
                        return
                    }
                    
                    return
                }
                else
                {
                    response(res)
                }
                break
            }
        }
        return dataRequest
    }
    
    static func sendError(functionName: StaticString,file: String, line: Int, error:NSError ,subpress:Bool ,callback:@escaping ((Bool) -> Void)) {
        
        Crashlytics.sharedInstance().recordError(error)
        
        var title = error.userInfo["error_message"] as? String ?? error.domain
        var message = error.localizedDescription
        
        print("\n!!!-----API-Error------!!!\n\n   file : \(file)\n   line : \(line)\n   functionName : \(functionName)  \n\n!!!---------------------!!!\n")
        
        guard subpress == false else {
            //print("\(title):\(message)")
            callback(true)
            return
        }
        
        if //error.code == -1009 || //"The Internet connection appears to be offline."
            error.code == 256 //"The file “tvg_fairplay.cer” couldn’t be opened."
        {
            callback(true)
            return
        }
        
        if error.code == -1009 {
            title = "Network Error"
            message = "Failed to connect to TrueTV. Please check your device's network connection."
        }
        
        
        //-----ย้ายไปอยู่ในส่วน request แทน----//
        if message.lowercased() != "cancelled" {
            
            //Default Message
            message = "ไม่สามารถเชื่อมต่อได้"
            title = "การเชื่อมต่อขัดข้อง"
            
            let popup = PopupDialog(title: title, message: message, image: nil)
            
            let buttonTwo = DefaultButton(title: "ปิด App") {
                exit(0)
                //callback(true)
            }
            popup.addButtons([buttonTwo])
            Utilities.topMostControllerIgnorePopupDialog?.present(popup, animated: true, completion: nil)
        }
    }
    
    static func performCallback(
        functionName: StaticString = #function,
        file: String = #file, line: Int = #line,
        alamoResult:Result<Any>,
        getErrorClosure:GetErrorClosure,
        getDataClosure:GetDataClosure,
        subpressError:Bool = false,
        callback:@escaping((_ data:Any?, _ error:Error?) -> Void)) {
        self.performCallback(functionName: functionName,
                             file: file, line: line,
                             rawResponse: alamoResult.value,
                             clientError: alamoResult.error,
                             getErrorClosure: getErrorClosure,
                             getDataClosure: getDataClosure,
                             subpressError: subpressError,
                             callback: callback)
    }
    
    static func performCallback(
        functionName: StaticString = #function,
        file: String = #file, line: Int = #line,
        alamoResult:Result<String>,
        getErrorClosure:GetErrorClosure,
        getDataClosure:GetDataClosure,
        subpressError:Bool = false,
        callback:@escaping((_ data:Any?, _ error:Error?) -> Void)) {
        self.performCallback(functionName: functionName,
                             file: file, line: line,
                             rawResponse: alamoResult.value,
                             clientError: alamoResult.error,
                             getErrorClosure: getErrorClosure,
                             getDataClosure: getDataClosure,
                             subpressError: subpressError,
                             callback: callback)
    }
    
    
    
    static func performCallback<T: Mappable>(
        functionName: StaticString = #function,
        file: String = #file, line: Int = #line,
        alamoResult:Result<Any>,
        getErrorClosure:GetErrorClosure,
        getDataClosure:GetDataClosure,
        subpressError:Bool = false,
        callback:@escaping ((_ data:T?, _ error:Error?) -> Void)) {
        self.performCallback(functionName: functionName,
                             file: file, line: line,
                             rawResponse: alamoResult.value,
                             clientError: alamoResult.error,
                             getErrorClosure: getErrorClosure,
                             getDataClosure: getDataClosure,
                             subpressError: subpressError,
                             callback: callback)
    }
    
    static func performCallback<T: Mappable>(
        functionName: StaticString = #function,
        file: String = #file, line: Int = #line,
        alamoResult:Result<Any>,
        getErrorClosure:GetErrorClosure,
        getDataClosure:GetDataClosure,
        subpressError:Bool = false,
        callback:@escaping ((_ data:[T]?, _ error:Error?) -> Void)) {
        self.performCallback(functionName: functionName,
                             file: file, line: line,
                             rawResponse: alamoResult.value,
                             clientError: alamoResult.error,
                             getErrorClosure: getErrorClosure,
                             getDataClosure: getDataClosure,
                             subpressError: subpressError,
                             callback: callback)
    }
    
    static func performCallback(
        functionName: StaticString = #function,
        file: String = #file, line: Int = #line,
        rawResponse:Any?,
        clientError:Error?,
        getErrorClosure:GetErrorClosure,
        getDataClosure:GetDataClosure,
        subpressError:Bool,
        callback:@escaping ((_ data:Any?, _ error:Error?) -> Void)) {
        //NetworkObserver.sendUpdateNetworkStatusNotification()
        if let error = clientError {
            sendError(functionName: functionName,file: file, line: line,error: error as NSError, subpress: subpressError, callback: {_ in
                callback(nil, error)
            })
            
        } else if let response = rawResponse{
            if let responseError = getErrorClosure(response) {
                sendError(functionName: functionName,file: file, line: line, error: responseError as NSError, subpress: subpressError,callback: {_ in
                    callback(nil, responseError)
                })
            } else {
                if let apiError = API.getAPIError(rawResponse: rawResponse){
                    sendError(functionName: functionName,file: file, line: line,error: apiError as NSError, subpress: subpressError, callback: { _ in
                        callback(nil, apiError)
                    })
                }else if let rawData: Any = getDataClosure(response) {
                    callback(rawData, nil)
                } else {
                    sendError(functionName: functionName,file: file, line: line,error: APIError.type.emptyData, subpress: subpressError, callback: {_ in
                        callback(nil, APIError.type.emptyData)
                    })
                }
            }
        } else {
            sendError(functionName: functionName,file: file, line: line,error: APIError.type.emptyResponse, subpress: subpressError, callback: {_ in
                callback(nil, APIError.type.emptyResponse)
            })
        }
    }
    
    static func performCallback<T: Mappable>(
        functionName: StaticString = #function,
        file: String = #file, line: Int = #line,
        rawResponse:Any?,
        clientError:Error?,
        getErrorClosure:GetErrorClosure,
        getDataClosure:GetDataClosure,
        subpressError:Bool,
        callback:@escaping ((_ data:T?, _ error:Error?) -> Void)) {
        //NetworkObserver.sendpdateNetworkStatusNotification()
        if let error = clientError {
            sendError(functionName: functionName,file: file, line: line,error: error as NSError, subpress: subpressError, callback: {_ in
                callback(nil, error)
            })
        }
        else if let response = rawResponse{
            if let responseError = getErrorClosure(response) {
                sendError(functionName: functionName,file: file, line: line,error: responseError as NSError, subpress: subpressError, callback: {_ in
                    callback(nil, responseError)
                })
                
            } else if let rawData: Any = getDataClosure(response) {
                if let apiError = API.getAPIError(rawResponse: rawResponse){
                    sendError(functionName: functionName,file: file, line: line,error: apiError as NSError, subpress: subpressError, callback: { _ in
                        callback(nil, apiError)
                    })
                }else if let mappedData = Mapper<T>().map(JSONObject: rawData){
                    callback(mappedData, nil)
                }else
                {
                    let json = JSON(response)
                    guard let status = json["status_code"].int else {
                        sendError(functionName: functionName,file: file, line: line,error: APIError.type.invalidFormat, subpress: subpressError, callback: {_ in
                            callback(nil, APIError.type.invalidFormat)
                        })
                        return
                    }
                    if status != 200 {
                        sendError(functionName: functionName,file: file, line: line,error: APIError.type.invalidFormat, subpress: subpressError, callback: {_ in
                            callback(nil, APIError.type.invalidFormat)
                        })
                    }
                    else
                    {
                        callback(nil, APIError.type.emptyData)
                    }
                }
            } else {
                sendError(functionName: functionName,file: file, line: line,error: APIError.type.emptyData, subpress: subpressError, callback: {_ in
                    callback(nil, APIError.type.emptyData)
                })
            }
        } else {
            sendError(functionName: functionName,file: file, line: line,error: APIError.type.emptyResponse, subpress: subpressError, callback: {_ in
                callback(nil, APIError.type.emptyResponse)
            })
        }
    }
    
    static func performCallback<T: Mappable>(
        functionName: StaticString = #function,
        file: String = #file, line: Int = #line,
        rawResponse:Any?,
        clientError:Error?,
        getErrorClosure:GetErrorClosure,
        getDataClosure:GetDataClosure,
        subpressError:Bool,
        callback:@escaping ((_ data:[T]?, _ error:Error?) -> Void)) {
        //NetworkObserver.sendpdateNetworkStatusNotification()
        if let error = clientError {
            sendError(functionName: functionName,file: file, line: line,error: error as NSError, subpress: subpressError, callback: {_ in
                callback(nil, error)
            })
        }
        else if let response = rawResponse{
            if let responseError = getErrorClosure(response) {
                sendError(functionName: functionName,file: file, line: line,error: responseError as NSError, subpress: subpressError, callback: {_ in
                    callback(nil, responseError)
                })
                
            } else if let rawData: Any = getDataClosure(response) {
                if let apiError = API.getAPIError(rawResponse: rawResponse){
                    sendError(functionName: functionName,file: file, line: line,error: apiError as NSError, subpress: subpressError, callback: { _ in
                        callback(nil, apiError)
                    })
                }else if let mappedData = Mapper<T>().mapArray(JSONObject: rawData){
                    callback(mappedData, nil)
                }else{
                    let json = JSON(response)
                    guard let status = json["status_code"].int else {
                        sendError(functionName: functionName,file: file, line: line,error: APIError.type.invalidFormat, subpress: subpressError, callback: {_ in
                            callback(nil, APIError.type.invalidFormat)
                        })
                        return
                    }
                    if status != 200 {
                        sendError(functionName: functionName,file: file, line: line,error: APIError.type.invalidFormat, subpress: subpressError, callback: {_ in
                            callback(nil, APIError.type.invalidFormat)
                        })
                    }
                    else
                    {
                        callback(nil, APIError.type.emptyData)
                    }
                }
            } else {
                sendError(functionName: functionName,file: file, line: line,error: APIError.type.emptyData, subpress: subpressError, callback: {_ in
                    callback(nil, APIError.type.emptyData)
                })
            }
        } else {
            sendError(functionName: functionName,file: file, line: line,error: APIError.type.emptyResponse, subpress: subpressError, callback: {_ in
                callback(nil, APIError.type.emptyResponse)
            })
        }
    }
    
    static func getAPIError(rawResponse:Any?)->Error?{
        
        return nil
    }
    
    static func syncRequest(urlRequest:URLRequestConvertible) -> DataResponse<Any>?{
        var outResponse: DataResponse<Any>?
        let semaphore : DispatchSemaphore = DispatchSemaphore(value: 0)
        alamofireManager.request(urlRequest).responseJSON { (dataResponse: DataResponse<Any>) in
            outResponse = dataResponse
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return outResponse
    }
}
