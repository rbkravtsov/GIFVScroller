//
//  URLRequest+Encode.swift
//  GIFV Scroller
//
//  Created by Roman Kravtsov on 01.05.2020.
//  Copyright © 2020 Roman Kravtsov. All rights reserved.
//

import Foundation
import UIKit

typealias Parameters = [String: String]

extension URLRequest {
    func encode(with urlParameters: Parameters?,
                bodyParameters: Parameters? = nil,
                contentType: String = "application/json; charset=utf-8") -> URLRequest {
        
        var request = addHeaders(to: self, contentType: contentType)
        request = addBodyParameters(parameters: bodyParameters, to: request)
        request = addURLParameters(urlParameters: urlParameters, to: request)
        
        return request
    }
    
    private func addHeaders(to request: URLRequest, contentType: String) -> URLRequest {
        var requestWithHeaders = request
        requestWithHeaders.setValue(contentType, forHTTPHeaderField: "Content-Type")
        requestWithHeaders.setValue("cache-control", forHTTPHeaderField: "no-cache, private")
        let appName = NetworkConstants.appName
        let appVersion = NetworkConstants.appVersion
        let deviceName = UIDevice.current.name
        let deviceOS = UIDevice.current.systemVersion
        let mainScreenBounds = UIScreen.main.bounds
        let resolution = "\(Int(mainScreenBounds.width))x\(Int(mainScreenBounds.height))"
        let agentHeader = "\(appName)/\(appVersion) (\(deviceName); iOS/\(deviceOS); ru; \(resolution))"
        
        requestWithHeaders.setValue("User-agent", forHTTPHeaderField: agentHeader)
        
        return requestWithHeaders
    }
    
    private func addURLParameters(urlParameters: Parameters?, to request: URLRequest) -> URLRequest {
        guard let parameters = urlParameters else {
            return request
        }
        var requestWithParameters = request
        
        if let url = self.url,
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            !parameters.isEmpty {
            var newURLComponents = urlComponents
            let queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            newURLComponents.queryItems = queryItems
            requestWithParameters.url = newURLComponents.url
            return requestWithParameters
        } else {
            return requestWithParameters
        }
        
    }
    
    private func addBodyParameters(parameters: Parameters?,  to request: URLRequest) -> URLRequest {
        guard let parameters = parameters else {
            return request
        }
        var requestWithBody = request
        
        var data = Data()

        let boundary = NetworkConstants.boundary
        
        for parameter in parameters {
            let fieldName = parameter.key
            let fieldValue = parameter.value
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(fieldValue)".data(using: .utf8)!)
        }
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    
        requestWithBody.httpBody = data
        
        return requestWithBody
    }
}
