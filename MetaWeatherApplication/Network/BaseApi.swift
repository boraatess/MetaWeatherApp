//
//  BaseApi.swift
//  MetaWeatherApplication
//
//  Created by bora on 15.09.2021.
//

import Alamofire
import PromiseKit

class BaseApi {
    
    private var baseApiUrl = Bundle.main.object(forInfoDictionaryKey: "ApiUrl") as! String
    private var endPoint: String = ""
    
    private let sessionManager: Session?
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        sessionManager = Alamofire.Session(configuration: configuration)
    }
    
    @discardableResult
    public func request<T:Decodable>(fullUrl url: String,method: HTTPMethod, parameters: Parameters?) -> Promise<T> {
        
        let finalUrl = replaceUrlPathsWithMatchingParameters(parameters, URL(string: url)!)
        
        var encodinga: ParameterEncoding? = nil
        if(method != .get) {
            encodinga = JSONEncoding.default
        } else {
            encodinga = URLEncoding.queryString
        }
        
        return Promise<T> { seal in
            sessionManager!.request(finalUrl, method: method, parameters: parameters, encoding: encodinga!, headers: nil)
                .validate(statusCode: 200..<300)
                .responseDecodable { (response: DataResponse<T, AFError>) in
                    if response.data != nil {
                        switch response.result {
                        case .success(let value):
                            seal.fulfill(value)
                        case .failure(let error):
                            guard let data = response.data else {
                                seal.reject(error)
                                return
                            }
                            
                            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else{
                                seal.reject(error)
                                return
                            }
                            
                            print(json)
                            if let code = response.response?.statusCode {
                                switch code {
                                case 400..<599, 0:
                                    if let code = json["errorCode"] as? Int{
                                        print(code)
                                    }
                                    if let title = json["message"] as? String{
                                        print(title)
                                    }
                                default:
                                    print("Unexpected status")
                                }
                            }
                            seal.reject(error)
                        }
                    } else {
                        print("response nil non value \(String(describing: response.error?.localizedDescription))")
                        seal.reject(response.error!)
                    }
                }
        }
    }
    
    func getPagination<T:Decodable>(url: String, page: Int = 0, size: Int = 20) -> Promise<T> {
        endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint, method: .get, parameters: ["page":page, "size": size])
    }
    
    func get<T: Decodable>(url: String, parameters : [String:Any]? = nil) -> Promise<T> {
        endPoint = baseApiUrl+url
        print("Request url: \(endPoint)")
        return self.request(fullUrl: endPoint , method: HTTPMethod.get , parameters : parameters)
    }
    
    func post<T: Decodable>(url: String, parameters: Parameters?) -> Promise<T>  {
        endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint , method: HTTPMethod.post , parameters : parameters)
    }
    
    func put<T: Decodable>(url: String, parameters: Parameters) -> Promise<T> {
        endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint , method: HTTPMethod.put , parameters : parameters)
    }
    
    func patch<T: Decodable>(url: String, parameters: Parameters) -> Promise<T> {
        endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint , method: HTTPMethod.patch , parameters : parameters)
    }
    
    func delete<T: Decodable>(url: String, parameters: Parameters? = nil) -> Promise<T> {
        endPoint = baseApiUrl+url
        return self.request(fullUrl: endPoint , method: HTTPMethod.delete , parameters : parameters)
    }
    
    private func replaceUrlPathsWithMatchingParameters(_ parameters: Parameters?, _ url: URL) -> URL {
        var finalURL = url
        if let parameters = parameters {
            for key in parameters.keys {
                var finalValue: String?
                if let value = parameters[key] as? String {
                    finalValue = value
                } else if let value = parameters[key] as? Int {
                    finalValue = "\(value)"
                } else if let value = parameters[key] as? Double {
                    finalValue = "\(value)"
                }
                if finalURL.absoluteString.contains(key), let finalValue = finalValue {
                    let latestURLString = finalURL.absoluteString
                    let latestURLStringModified = latestURLString.replacingOccurrences(of: key, with: finalValue)
                    if let newURL = URL(string: latestURLStringModified) {
                        finalURL = newURL
                        print(finalURL)
                    }
                }
            }
        }
        return finalURL
    }
    
}


