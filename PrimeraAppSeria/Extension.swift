//
//  Extension.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 28/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

extension UIImage {
   func resizeImage(newWidth:CGFloat) -> UIImage? {
      let scale = newWidth / self.size.width
      let newHeight = self.size.height * scale
      let newSize = CGSize(width: newWidth, height: newHeight)
      UIGraphicsBeginImageContext(newSize)
      self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return newImage
   }
}
