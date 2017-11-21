//
//  StringExtensions.swift
//  TideTracker
//
//  Created by Ben Sullivan on 20/11/2017.
//  Copyright © 2017 Sullivan Applications. All rights reserved.
//

extension String {
  
  func slice(from: String, to: String) -> String? {
    
    return (range(of: from)?.upperBound).flatMap { substringFrom in
      (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
        String(self[substringFrom..<substringTo])
      }
    }
  }
}
