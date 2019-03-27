//
//  CollectionViewZelda.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 22/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

class CollectionViewZelda: UICollectionViewCell {
    
   @IBOutlet weak var email: UILabel!
   @IBOutlet weak var last_name: UILabel!
   @IBOutlet weak var first_name: UILabel!
   @IBOutlet weak var imagen: UIImageView!
   
   override func awakeFromNib() {
      layer.cornerRadius = 4.0
      layer.borderColor = UIColor.red.cgColor
      layer.borderWidth = 2.0
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
      layer.shadowOpacity = 0.5
      layer.masksToBounds = false
   }
}
