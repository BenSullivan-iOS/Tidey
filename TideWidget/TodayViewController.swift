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
  
  @IBOutlet weak var mainTideImage: UIImageView!
  
  @IBOutlet weak var tideStatus: UILabel!
  @IBOutlet weak var tidePercentage: UILabel!
  @IBOutlet weak var highTideLabel: UILabel!
  @IBOutlet weak var lowTideLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    
    guard let userDefaults = UserDefaults(suiteName: "group.tideyDefaults") else { return }
    let savedLocation = userDefaults.value(forKey: "location") as AnyObject?
    
    var location = "Leigh-on-sea"
    
    if let savedLocation = savedLocation as? String {
      location = savedLocation
    } else {
      userDefaults.setValue("leigh-on-sea", forKey: "location")
    }
    
    model = TideModel()
    
    self.model.downloadData(location: location) { result in
      
      DispatchQueue.main.async {
        
        switch result {
        case .value(let properties):
          
          self.locationLabel.text = properties.location
          self.tideStatus.text = properties.statusSlice
          self.tidePercentage.text = properties.percentSlice
          self.highTideLabel.text = "High tide in " + properties.highTide
          self.lowTideLabel.text = "Low tide in " + properties.lowTide
          
          if properties.statusSlice.contains("falling") {
            self.mainTideImage.image = #imageLiteral(resourceName: "tidegoingdown")
          } else {
            self.mainTideImage.image = #imageLiteral(resourceName: "tidegoingup")
          }
          
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
