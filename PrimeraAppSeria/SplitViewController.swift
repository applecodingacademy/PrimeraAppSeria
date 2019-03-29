//
//  SplitViewController.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 29/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

class SplitViewController: UIViewController {

   @IBOutlet weak var testEtiqueta: UILabel!
   
   override func viewDidLoad() {
        super.viewDidLoad()

      NotificationCenter.default.addObserver(forName: NSNotification.Name("TOCO"), object: nil, queue: OperationQueue.main) { [weak self] notification in
         if let datos = notification.userInfo as? [String:Int], let row = datos["ROW"] {
            self?.testEtiqueta.text = "\(row)"
         }
      }
    }
   
   deinit {
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name("TOCO"), object: nil)
   }

}
