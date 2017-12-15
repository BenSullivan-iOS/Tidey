//
//  TodayViewController.swift
//  TideWidget
//
//  Created by Ben Sullivan on 15/12/2017.
//  Copyright © 2017 Sullivan Applications. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
  
  var model: TideModelType!
  
  @IBOutlet weak var locationLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    
    model = TideModel()
    
    self.model.downloadData(location: "leigh-on-sea") { result in
      
      DispatchQueue.main.async {
        
        switch result {
        case .value(let properties):
          
//          self.locationLabel.text = "Leigh-on-sea"
          print("go")
//          self.success(properties: properties)
        case .error(_):
//          self.setErrorLabels()
          print("bro")
        }
        
      }

    }
  }
  
  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
    
  }
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    completionHandler(NCUpdateResult.newData)
  }
  
}
