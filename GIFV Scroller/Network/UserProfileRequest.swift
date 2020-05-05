//
//  UserProfileRequest.swift
//  GIFV Scroller
//
//  Created by Roman Kravtsov on 05.05.2020.
//  Copyright © 2020 Roman Kravtsov. All rights reserved.
//

import Foundation

struct UserProfileRequest {
    let path = "auth/qr"
    
    let parameters: Parameters
    
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension UserProfileRequest {
    static func getRequest() -> UserProfileRequest {
        let parameters: Parameters = [:]
        return UserProfileRequest(parameters: parameters)
    }
}
