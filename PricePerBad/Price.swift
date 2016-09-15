//
//  Price.swift
//  Free
//
//  Created by RYAN CHRISTENSEN on 9/14/16.
//  Copyright © 2016 RYAN CHRISTENSEN. All rights reserved.
//

import UIKit

class Price  {
  
  let kMaxScore: Double = 7.0
  let kUsefulnessFactor: Double = 2.0
  let kQualityFactor: Double = 3.5
  let kFeaturesFactor: Double = 1.618
  let kDesireFactor: Double = 2.0
  
  func pricePerBad(price: Double, avgPrice: Double, usefulness: Double, quality: Double, features: Double, desire: Double) -> String {
    let priceFactor = ((price - avgPrice) / avgPrice)
    let attributes = ((kUsefulnessFactor * (usefulness)) + (kQualityFactor * (quality)) + (kFeaturesFactor * (features)) - (kDesireFactor * (desire)))
    let kTotalWeights = kUsefulnessFactor + kQualityFactor + kFeaturesFactor + kDesireFactor
    let maxNumber = ((kMaxScore * kUsefulnessFactor) + (kMaxScore * kQualityFactor) + (kMaxScore + kFeaturesFactor) + (kMaxScore * kDesireFactor))
    let denom = maxNumber - (attributes - kTotalWeights)
    if priceFactor > 0 {
      let adjustedPrice = price * (1.0 + priceFactor)
      return "$\(NewNumberFormatter.sharedInstance.string(from: (adjustedPrice / denom) as NSNumber)!)"
    } else if priceFactor == 0 || attributes == 0 {
      let adjustedPrice = price * (1.0 + priceFactor)
      if attributes == 0 {
        return "$\(NewNumberFormatter.sharedInstance.string(from: (adjustedPrice / denom) as NSNumber)!)"
      }
      return "$\(NewNumberFormatter.sharedInstance.string(from: (price / denom) as NSNumber)!)"
    } else {
      let adjustedPrice = price * (1.0 + priceFactor)
      return "$\(NewNumberFormatter.sharedInstance.string(from: (adjustedPrice / denom) as NSNumber)!)"
    }
  }

}
