//
//  HTTPURLResponse+hasSuccessCode.swift
//  GIFV Scroller
//
//  Created by Roman Kravtsov on 01.05.2020.
//  Copyright © 2020 Roman Kravtsov. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
  var hasSuccessCode: Bool {
    return 200...299 ~= statusCode
  }
}
