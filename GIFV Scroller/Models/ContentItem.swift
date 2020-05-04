//
//  ContentItem.swift
//  GIFV Scroller
//
//  Created by Roman Kravtsov on 29.04.2020.
//  Copyright © 2020 Roman Kravtsov. All rights reserved.
//

import Foundation

struct ContentItem: Decodable {
    let intro: String
    let cover: Cover
}

struct Cover: Decodable {
    let additionalData: AdditionalData
    let url: String
}

struct AdditionalData: Decodable {
    let type: DataType
}

enum DataType: String, Decodable {
    case image = "jpg"
    case video = "gif"
}
