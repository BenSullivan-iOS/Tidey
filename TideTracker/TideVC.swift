//
//  ViewController.swift
//  TideTracker
//
//  Created by Ben Sullivan on 05/11/2017.
//  Copyright © 2017 Sullivan Applications. All rights reserved.
//

import UIKit

class TideVC: UIViewController {

  @IBOutlet weak var percentLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var highTideLabel: UILabel!
  @IBOutlet weak var lowTideLabel: UILabel!
  
  @IBOutlet weak var locationTF: UITextField!
  @IBOutlet weak var bgImage: UIImageView!
  
  @IBOutlet weak var launchImage: UIImageView!
  
  @IBOutlet weak var searchButton: UIImageView!
  @IBOutlet weak var backgroundButton: UIButton!
  
  fileprivate var model: TideModelType!
  fileprivate var timer: Timer?
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  //MARK: - VC Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.model = TideModel()
    activityIndicator.hidesWhenStopped = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    configureTextfield()
    startTimer(withInterval: 60)
    addSearchGestureRecogniser()
  }
  
  @IBAction func backgroundButtonTapped(_ sender: UIButton) {
    searchTapped()
  }
  
  //MARK: - Data capture operations
  
  fileprivate func startTimer(withInterval interval: TimeInterval) {
    
    if timer != nil {
      if timer!.isValid {
        timer!.invalidate()
      }
    }
    
    timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
      self.activityIndicator.startAnimating()
      self.model.downloadData(location: self.locationTF.text!) { result in
        
        switch result {
        case .value(let properties):
          self.success(properties: properties)
        case .error(_):
          self.setErrorLabels()
        }
      }
    }
    
    timer!.fire()
  }
  
  fileprivate func success(properties: TideProperties) {
    
    DispatchQueue.main.async {
      self.activityIndicator.stopAnimating()
      self.launchImage.alpha = 0

      let location = self.locationTF.text!.isEmpty ? "Leigh-on-Sea" : self.locationTF.text!
      self.statusLabel.text = location
      self.statusLabel.alpha = 0
      self.percentLabel.text = properties.percentSlice
      self.percentLabel.alpha = 0

      UIView.animate(withDuration: 0.8, animations: {
        self.statusLabel.alpha = 1

      }, completion: { finished in
        
        if finished {
          
          UIView.animate(withDuration: 0.8, animations: {
            self.statusLabel.alpha = 0
            
          }, completion: { finished in
            
            UIView.animate(withDuration: 0.8, animations: {
              self.statusLabel.alpha = 1
              self.percentLabel.alpha = 1

              self.statusLabel.text = properties.statusSlice
            })
          })
        }
      })
      
      self.highTideLabel.text = "High tide in " + properties.highTide
      self.lowTideLabel.text = "Low tide in " + properties.lowTide
      
      UIView.animate(withDuration: 0.3, animations: {
        self.locationTF.alpha = 0
      })
      self.view.endEditing(true)
      
      guard
        let percentStr = properties.percentSlice.split(separator: "%").first,
        let percent = Int(percentStr)
        
        else {
          
          self.bgImage.image = #imageLiteral(resourceName: "leigh")
          return
      }
      
      if percent < 50 {
        self.bgImage.image = #imageLiteral(resourceName: "leigh")
      } else if percent < 65 {
        self.bgImage.image = #imageLiteral(resourceName: "seventynine")
      } else if percent < 80 {
        self.bgImage.image = #imageLiteral(resourceName: "eightynine")
      } else if percent > 80 {
        self.bgImage.image = #imageLiteral(resourceName: "ninetyeight")
      }
    }
  }
  
  fileprivate func setErrorLabels() {
    
    DispatchQueue.main.async {
      self.activityIndicator.stopAnimating()

      self.statusLabel.text = "💩"
      self.percentLabel.text = "No connection? Can't spell?"
      self.locationTF.becomeFirstResponder()
      if self.bgImage.image == nil {
        self.bgImage.image = #imageLiteral(resourceName: "leigh")
        self.launchImage.alpha = 0
      }
      UIView.animate(withDuration: 0.5, animations: {
        self.locationTF.alpha = 1
      })
    }
  }
  
  
  //MARK: - Style & setup
  
  fileprivate func configureTextfield() {
    locationTF.delegate = self
    locationTF.returnKeyType = .search
    locationTF.alpha = 0
  }
  
  fileprivate func addSearchGestureRecogniser() {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(searchTapped))
    searchButton.addGestureRecognizer(gesture)
  }
  
  @objc fileprivate func searchTapped() {
    
    UIView.animate(withDuration: 0.5) {
      self.locationTF.alpha = 1
    }
    self.locationTF.becomeFirstResponder()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

extension TideVC: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    startTimer(withInterval: 60)
    self.view.endEditing(true)
    return true
  }
  
}
