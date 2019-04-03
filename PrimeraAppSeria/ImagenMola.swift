//
//  ImagenMola.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 03/04/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

@IBDesignable
class ImagenMola: UIImageView {
   
   @IBInspectable
   var cornerRadius:CGFloat {
      set {
         layer.cornerRadius = newValue
      }
      get {
         return layer.cornerRadius
      }
   }
}
