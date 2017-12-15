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
  
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var locationLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    
    model = TideModel()
    
    self.model.downloadData(location: "leigh-on-sea") { result in
      
      DispatchQueue.main.async {
        
        switch result {
        case .value(let properties):
          
          print("go")
        case .error(_):
          print("bro")
        }
        
      }

    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    stackView.subviews[1].isHidden = true
  }
  
  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
  
    stackView.subviews[1].isHidden = !stackView.subviews[1].isHidden
    
    view.layoutSubviews()
    
  }
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    
    completionHandler(NCUpdateResult.newData)
  }
  
}
