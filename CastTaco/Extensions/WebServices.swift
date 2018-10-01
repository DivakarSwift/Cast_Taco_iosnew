//
//  WebServices.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 04/09/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit
import Alamofire


struct AppMimeType {
    static let image = "image/jpg"
    static let video = "video/mp4"
}

enum AppError: Error {
    
    case userAlreadyRegistered
    case operationCancelled
    
    case unknownError
    case connectionError
    case invalidCredentials
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case timeOut
    case unsuppotedURL
}

class WebServices: NSObject {

    static var shared : WebServices = {
        return WebServices()
    }()
    
    
    func response(parameters:Parameters,apiname: String, firstResponse: @escaping()->(), success: @escaping(NSDictionary)->(), error:@escaping(AppError)->()) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },to:apiname, method: .post, encodingCompletion:{ (result) in
            firstResponse()
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    print(response)
                    DispatchQueue.main.async {
                        if let json2 = response.result.value as? NSDictionary {
                            success(json2)
                        }
                    
                        guard case let .failure(error) = response.result else { return }
                        self.errorHandler(error: error)
                    }
                }
                
                
            case .failure(let encodingError):
                DispatchQueue.main.async {
                    self.errorHandler(error: encodingError)
                }
                
//             if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
//                   error(AppError.connectionError)
//                 Singleton.shared.showAlert(title: "No internet available", message: "The Internet connection appears to be offline. Please try again.")
//             } else {
//                error(AppError.unknownError)
//                Singleton.shared.showAlert(title: "Alert", message: (encodingError.localizedDescription))
//             }
            }
        })
    }
    
    private func errorHandler(error: Error?) {
        if let error = error as? AFError {
            
            switch error {
            case .invalidURL(let url):
                print("Invalid URL: \(url) - \(error.localizedDescription)")
            case .parameterEncodingFailed(let reason):
                print("Parameter encoding failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            case .multipartEncodingFailed(let reason):
                print("Multipart encoding failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            case .responseValidationFailed(let reason):
                print("Response validation failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
                
                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    print("Downloaded file could not be read")
                case .missingContentType(let acceptableContentTypes):
                    print("Content Type Missing: \(acceptableContentTypes)")
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                case .unacceptableStatusCode(let code):
                    print("Response status code was unacceptable: \(code)")
                }
                
            case .responseSerializationFailed(let reason):
                print("Response serialization failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
            }
            
            print("Underlying error: \(error.underlyingError)")
            Singleton.shared.showAlert(title: "Error", message: error.underlyingError?.localizedDescription ?? "Unable to process requests. Please try again.")
            
        } else if let error = error as? URLError {
            if error.code == .notConnectedToInternet {
                Singleton.shared.showAlert(title: "No internet available", message: "The Internet connection appears to be offline. Please try again.")
            } else {
                Singleton.shared.showAlert(title: "Error", message: error.localizedDescription)
            }
            print("URLError occurred: \(error)")
        } else {
            print("Unknown error: \(error)")
        }
        
    }
    
    
    func multipartResponse(parameters:Parameters,apiname: String, multipartData: Data?, key:String, filename:String, mimeType:String, firstResponse: @escaping()->(), success:@escaping(NSDictionary)->(), error:@escaping(Error)->()) {
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            if multipartData != nil{
                multipartFormData.append(multipartData!, withName: key, fileName: filename, mimeType: mimeType)
            }
            
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        },to:apiname, method: .post, encodingCompletion:{ (result) in
            firstResponse()
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    print(response)
                    if let json2 = response.result.value as? NSDictionary {
                        DispatchQueue.main.async {
                            success(json2)
                        }
                    }

                    guard case let .failure(error) = response.result else { return }
                    self.errorHandler(error: error)
                }
                
            case .failure(let encodingError):
                self.errorHandler(error: encodingError)
//                if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
//                    Singleton.shared.showAlert(title: "No internet available", message: "The Internet connection appears to be offline. Please try again.")
//                } else {
//                    Singleton.shared.showAlert(title: "Alert", message: (encodingError.localizedDescription))
//                }
            }
        })
    }
    
}
