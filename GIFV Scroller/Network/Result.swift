//
//  Result.swift
//  GIFV Scroller
//
//  Created by Roman Kravtsov on 01.05.2020.
//  Copyright © 2020 Roman Kravtsov. All rights reserved.
//

import Foundation

enum Result<T, U: Error> {
  case success(T)
  case failure(U)
}
