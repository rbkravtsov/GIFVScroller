//
//  UserProfile.swift
//  GIFV Scroller
//
//  Created by Roman Kravtsov on 29.04.2020.
//  Copyright © 2020 Roman Kravtsov. All rights reserved.
//

import Foundation

struct UserProfileResponse: Decodable {
    let result: UserProfile
}

struct UserProfile: Decodable {
    
    let name: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case avatarURL = "avatar_url"
    }
    
    
}
