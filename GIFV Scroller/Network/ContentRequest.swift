//
//  ContentRequest.swift
//  GIFV Scroller
//
//  Created by Roman Kravtsov on 01.05.2020.
//  Copyright © 2020 Roman Kravtsov. All rights reserved.
//

import Foundation

struct ContentRequest {
    func path(subsiteID: String, sorting: SortingType) -> String {
        "subsite/\(subsiteID)/timeline/\(sorting.rawValue)"
    }
    
    let parameters: Parameters
    
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension ContentRequest {
    static func getRequest() -> ContentRequest {
        let parameters: Parameters = [:]
        return ContentRequest(parameters: parameters)
    }
}
