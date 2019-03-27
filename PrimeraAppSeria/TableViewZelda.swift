//
//  TableViewZelda.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 22/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

class TableViewZelda: UITableViewCell {
   
   @IBOutlet weak var usuario: UILabel!
   @IBOutlet weak var name: UILabel!
   @IBOutlet weak var jobtitle: UILabel!
   @IBOutlet weak var domicilio: UILabel!
   @IBOutlet weak var ciudad: UILabel!
   @IBOutlet weak var email: UILabel!
   @IBOutlet weak var imagen: UIImageView!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
   override func prepareForReuse() {
      usuario.text = nil
      name.text = nil
      jobtitle.text = nil
      domicilio.text = nil
      ciudad.text = nil
      email.text = nil
      imagen.image = nil
   }
   
}
