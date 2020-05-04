//
//  UserProfile.swift
//  GIFV Scroller
//
//  Created by Roman Kravtsov on 29.04.2020.
//  Copyright © 2020 Roman Kravtsov. All rights reserved.
//

import Foundation

struct UserProfile: Decodable {
    let name: String
    let descriprion: String
    let avatarURL: String
    let karma: Int
}
