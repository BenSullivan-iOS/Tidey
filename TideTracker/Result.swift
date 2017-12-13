//
//  Result.swift
//  TideTracker
//
//  Created by Ben Sullivan on 13/12/2017.
//  Copyright © 2017 Sullivan Applications. All rights reserved.
//

typealias ResultBlock<T> = (Result<T>) -> ()

enum Result<T> {
  case value(T)
  case error(_: String)
}
