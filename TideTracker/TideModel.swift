//
//  TideModel.swift
//  TideTracker
//
//  Created by Ben Sullivan on 12/12/2017.
//  Copyright © 2017 Sullivan Applications. All rights reserved.
//

import Foundation

typealias TideProperties = (highTide: String, lowTide: String, statusSlice: String, percentSlice: String)

typealias ResultBlock<T> = (Result<T>) -> ()

enum Result<T> {
  case value(T)
  case error(_: String)
}


protocol TideModelType {
  func downloadData(location: String, completion: @escaping ResultBlock<TideProperties>)
}

struct TideModel: TideModelType {
  
  func downloadData(location: String, completion: @escaping ResultBlock<TideProperties>) -> () {
    
    var location = location == "" ? "leigh-on-sea" : location.lowercased()
    
    location = location.replacingOccurrences(of: " ", with: "-")
    
    let leighUrl = URL(string: "https://www.tidetime.org/europe/united-kingdom/" + location + ".htm")
    
    guard let url = leighUrl else {
      //      setErrorLabels()
      completion(Result.error(""))
      return
    }
    
    let request = URLRequest(
      url: url,
      cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData,
      timeoutInterval: 8.0
    )
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      guard let data = data else {
        //        self.setErrorLabels()
        completion(Result.error(""))
        return
      }
      
      let responseData = String(data: data, encoding: String.Encoding.utf8)
      
      //high tide
      
      let highTideSlice = responseData?.slice(from: "</h4>\n\t\t", to: "\n\t\t\t</div>")
      let lowTideSlice = responseData?.slice(from: "Next low tide:</h4>\n\t\t", to: "\n\t\t\t</div>")
      
      let str = "\n\t\t</div>\n\t\t<p><strong"
      let firstSlice = responseData?.slice(from: str, to: "</p>\n\t")
      
      guard
        let highTide = highTideSlice,
        let lowTide = lowTideSlice,
        let statusSlice = firstSlice?.slice(from: ">", to: "</strong> ("),
        let percentSlice = firstSlice?.slice(from: "</strong> (", to: ")")
        
        else {
          
          //          self.setErrorLabels()
          completion(Result.error(""))
          
          return
      }
      let properties = (highTide: highTide, lowTide: lowTide, statusSlice: statusSlice, percentSlice: percentSlice)
      completion(Result.value(properties))
      
    }
    
    task.resume()
  }
}
