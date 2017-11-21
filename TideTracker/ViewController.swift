//
//  ViewController.swift
//  TideTracker
//
//  Created by Ben Sullivan on 05/11/2017.
//  Copyright © 2017 Sullivan Applications. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var percentLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  
  var timer: Timer?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    startTimer(withInterval: 60)
  }
  
  func startTimer(withInterval interval: TimeInterval) {
    
    if timer != nil {
      if timer!.isValid {
        timer!.invalidate()
      }
    }
    
    timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
      self.downloadData()
    }
    
    timer!.fire()
  }
  
  func downloadData() {

    let leighUrl = URL(string: "https://www.tidetime.org/europe/united-kingdom/leigh-on-sea.htm")
    
    guard let url = leighUrl else {
      setErrorLabels()
      return
    }
    let request = URLRequest(
      url: url,
      cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData,
      timeoutInterval: 8.0
    )
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      guard let data = data else {
        self.setErrorLabels()
        return
        
      }
      
      let responseData = String(data: data, encoding: String.Encoding.utf8)
      let str = "<h3 id=\"title\">Current tide status</h3>"
      let firstSlice = responseData?.slice(from: str, to: "</p>")
      
      guard
        let statusSlice = firstSlice?.slice(from: "strong>", to: "</strong>"),
        let percentSlice = firstSlice?.slice(from: "(", to: ")")
        
        else {
          
          self.setErrorLabels()
          return
      }
      
      DispatchQueue.main.async {

        self.statusLabel.text = statusSlice
        self.percentLabel.text = percentSlice

      }
      
    }
    
    task.resume()
  }
  
  func setErrorLabels() {
    DispatchQueue.main.async {
      self.statusLabel.text = "Error"
      self.percentLabel.text = "data unavailable"
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

