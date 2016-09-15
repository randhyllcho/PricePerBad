//
//  NumberFormatter.swift
//  PricePerBad
//
//  Created by RYAN CHRISTENSEN on 5/13/16.
//  Copyright © 2016 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit


class NewNumberFormatter: NumberFormatter {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  override init() {
    super.init()
    self.maximumFractionDigits = 2
    self.minimumFractionDigits = 2
    self.alwaysShowsDecimalSeparator = false
    self.numberStyle = .decimal
  }
  static let sharedInstance = NewNumberFormatter()
  
  func currencyFormatter(number: Double) -> String {
    let formatter = NewNumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = "USD"
    return formatter.string(from: NSNumber(value: number))!
  }
}

