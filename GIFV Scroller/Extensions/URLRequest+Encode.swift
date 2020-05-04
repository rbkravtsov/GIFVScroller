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
    func encode(with parameters: Parameters?) -> URLRequest {
        
        let request = self.addHeaders()
        
        guard let parameters = parameters else {
            return request
        }
        
        var encodeURLRequest = request
        
        if let url = self.url,
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            !parameters.isEmpty {
            var newURLComponents = urlComponents
            let queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            newURLComponents.queryItems = queryItems
            encodeURLRequest.url = newURLComponents.url
            return encodeURLRequest
        } else {
            return request
        }
    }
    
    private func addHeaders() -> URLRequest {
        var requestWithHeaders = self
        requestWithHeaders.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
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
}
