//
//  DataResponseError.swift
//  GIFV Scroller
//
//  Created by Roman Kravtsov on 01.05.2020.
//  Copyright © 2020 Roman Kravtsov. All rights reserved.
//

import Foundation

enum DataResponseError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching data"
        case .decoding:
            return "An error occurred while decoding data"
        }
    }
}
