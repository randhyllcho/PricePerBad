
//  ViewController.swift
//  PricePerBad
//
//  Created by RYAN CHRISTENSEN on 5/13/16.
//  Copyright © 2016 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  
  let kUnitOfBad = "per Unit of Bad"
  let hideShowKeyboard = NotificationCenter.default
  let priceNumber = 0.0
  let averagePriceNumber = 0.0
  var priceHistory = [String]()
  var isSquished = false
  
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var priceTextField: UITextField!
  @IBOutlet weak var avgPriceTextField: UITextField!
  @IBOutlet weak var lastPriceLabel: UILabel!
  
  @IBOutlet weak var usefullScale: UIProgressView!
  @IBOutlet weak var usefullStepper: UIStepper!
  @IBOutlet weak var usefullBadUnitsLabel: UILabel!
  
  @IBOutlet weak var qualityOfBadLabel: UILabel!
  @IBOutlet weak var qualityScale: UIProgressView!
  @IBOutlet weak var qualityStepper: UIStepper!
  
  @IBOutlet weak var featuresUnitsLabel: UILabel!
  @IBOutlet weak var featuresScale: UIProgressView!
  @IBOutlet weak var featuresStepper: UIStepper!
  
  @IBOutlet weak var desireUnitLabel: UILabel!
  @IBOutlet weak var desireScale: UIProgressView!
  @IBOutlet weak var desireStepper: UIStepper!
  
  @IBOutlet weak var unitsStack: UIStackView!
  @IBOutlet weak var stepperStack: UIStackView!
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var shadeView: UIView!
  @IBOutlet weak var clearButton: UIButton!
  
  @IBOutlet weak var topStepperConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.priceTextField.delegate = self
    self.avgPriceTextField.delegate = self
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tap(_:)))
    view.addGestureRecognizer(tapGesture)
    
    self.clearButton.isEnabled = false
    
    hideShowKeyboard.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    hideShowKeyboard.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  //MARK: Steppers and Buttons
  
  @IBAction func usefullStepperPressed(_ sender: AnyObject) {
    if self.usefullStepper.value < 2 {
      self.usefullBadUnitsLabel.text = "\(Int(self.usefullStepper.value)) Unit of Bad"
    } else {
      self.usefullBadUnitsLabel.text = "\(Int(self.usefullStepper.value)) Units of Bad"
    }
    updateProgress(self.usefullStepper, progressView: self.usefullScale)
    getPPB()
    modifyButton(self.clearButton, stepperValue: self.usefullStepper)
  }
  
  @IBAction func qualityStepperPressed(_ sender: AnyObject) {
    if self.qualityStepper.value < 2 {
      self.qualityOfBadLabel.text = "\(Int(self.qualityStepper.value)) Unit of Bad"
    } else {
     self.qualityOfBadLabel.text = "\(Int(self.qualityStepper.value)) Units of Bad"
    }
    updateProgress(self.qualityStepper, progressView: self.qualityScale)
    getPPB()
    modifyButton(self.clearButton, stepperValue: self.qualityStepper)
  }
  
  @IBAction func featuresStepperPressed(_ sender: AnyObject) {
    if self.featuresStepper.value < 2 {
      self.featuresUnitsLabel.text = "\(Int(self.featuresStepper.value)) Unit of Bad"
    } else {
      self.featuresUnitsLabel.text = "\(Int(self.featuresStepper.value)) Units of Bad"
    }
    updateProgress(self.featuresStepper, progressView: self.featuresScale)
    getPPB()
    modifyButton(self.clearButton, stepperValue: self.featuresStepper)
  }
  
  @IBAction func desireStepperPressed(_ sender: AnyObject) {
    if self.desireStepper.value < 2 {
      self.desireUnitLabel.text = "\(Int(self.desireStepper.value)) Unit of Bad"
    } else {
       self.desireUnitLabel.text = "\(Int(self.desireStepper.value)) Units of Bad"
    }
    updateProgress(self.desireStepper, progressView: self.desireScale)
    getPPB()
    modifyButton(self.clearButton, stepperValue: self.desireStepper)
  }
  
  @IBAction func doneButtonPressed(_ sender: AnyObject) {
    resetValues(stepperValue: self.usefullStepper, labelText: self.usefullBadUnitsLabel, progress: self.usefullScale)
    resetValues(stepperValue: self.qualityStepper, labelText: self.qualityOfBadLabel, progress: self.qualityScale)
    resetValues(stepperValue: self.featuresStepper, labelText: self.featuresUnitsLabel, progress: self.featuresScale)
    resetValues(stepperValue: self.desireStepper, labelText: self.desireUnitLabel, progress: self.desireScale)
    
//    self.priceHistory.append(self.lastPriceLabel.text!)
    
    self.valueLabel.text = "$0"
    self.priceTextField.text = ""
    self.avgPriceTextField.text = ""
  }
  
  @IBAction func getHistoryPressed(_ sender: AnyObject) {
//    print(priceHistory)
  }
  
  //MARK: Functions
  
  func updateProgress(_ stepper: UIStepper, progressView: UIProgressView) {
    let price = Price()
    progressView.progress = Float(stepper.value) / Float(price.kMaxScore)
  }
  
  func getPrice(_ text: String) -> Double {
    let formatter = NewNumberFormatter()
    if text.contains("$") {
      formatter.numberStyle = .currency
    }
    return (formatter.number(from: text)?.doubleValue)!
  }
  
  func getAvgPrice(_ text: String) -> Double {
    let formatter = NewNumberFormatter()
    if text.contains("$") {
      formatter.numberStyle = .currency
    }
    return (formatter.number(from: text)?.doubleValue)!
  }
  
  @objc func tap(_ tap: UIGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  @objc func keyboardWillShow(_ notification: Notification) {
    self.shadeView.alpha = 0.35
    self.unitsStack.isHidden = true
    self.stepperStack.isHidden = true
    self.clearButton.isHidden = true
    UIView.animate(withDuration: 0.5, animations: { 
      self.imageView.alpha = 0.25
      if let keyboardSize = ((notification as NSNotification).userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y == 0 {
          self.view.frame.origin.y -= keyboardSize.height
        }
      }
    }) 
  }
  
  @objc func keyboardWillHide(_ notification: Notification) {
    self.shadeView.alpha = 0
    self.unitsStack.isHidden = false
    self.stepperStack.isHidden = false
    self.clearButton.isHidden = false
    self.imageView.alpha = 0
    getPPB()
    if let keyboardSize = ((notification as NSNotification).userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      self.view.frame.origin.y += keyboardSize.height
    }
  }
  
  func getPPB() {
    let pr = Price()
    let cur = NewNumberFormatter()
    let useStepVal = self.usefullStepper.value
    let qualStepVal = self.qualityStepper.value
    let featStepVal = self.featuresStepper.value
    let desStepVal = self.desireStepper.value
 
    if self.priceTextField.hasText && self.avgPriceTextField.hasText {
      let price = getPrice(self.priceTextField.text!)
      let avgPrice = getAvgPrice(self.avgPriceTextField.text!)
      
      let ppb = pr.pricePerBad(price: price, avgPrice: avgPrice, usefulness: useStepVal, quality: qualStepVal, features: featStepVal, desire: desStepVal)
      self.valueLabel.text = ppb
      self.priceTextField.text = "\(cur.currencyFormatter(number: price))"
      self.avgPriceTextField.text = "\(cur.currencyFormatter(number: avgPrice))"
    }
  }
  
   
  func resetValues(stepperValue: UIStepper, labelText: UILabel, progress: UIProgressView) {
    stepperValue.value = 0.0
    labelText.text = "0 Units of Bad"
    progress.progress = 0.0
    modifyButton(self.clearButton, stepperValue: stepperValue)
    self.lastPriceLabel.text = self.valueLabel.text
  }
  
  func modifyButton(_ button: UIButton, stepperValue: UIStepper) {
    let enabledColor = UIColor(hue: 0.55, saturation: 0.62, brightness: 0.18, alpha: 1)
    if button.isEnabled == false && stepperValue.value > 0  {
      button.isEnabled = true
      button.setTitleColor(enabledColor, for: UIControl.State())
    } else if stepperValue.value == 0 {
      button.isEnabled = false
      button.setTitleColor(UIColor.lightGray, for: UIControl.State())
    }
  }
}

