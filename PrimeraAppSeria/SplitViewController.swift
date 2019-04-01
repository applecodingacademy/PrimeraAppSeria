//
//  SplitViewController.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 29/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

class SplitViewController: UIViewController, DatoSeleccionado {
   
   @IBOutlet weak var nombre: UITextField!
   @IBOutlet weak var apellidos: UITextField!
   @IBOutlet weak var email: UITextField!
   @IBOutlet weak var imagen: UIImageView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
//      NotificationCenter.default.addObserver(forName: NSNotification.Name("TOCO"), object: nil, queue: OperationQueue.main) { [weak self] notification in
//         if let datos = notification.userInfo as? [String:Int], let row = datos["ROW"] {
//            self?.testEtiqueta.text = "\(row)"
//         }
//      }
   }
   
   func seleccionado(_ newPersona: MockData) {
      nombre.text = newPersona.first_name
      apellidos.text = newPersona.last_name
      email.text = newPersona.email
      imagen.image = cargarImagen(file: "tab_\(newPersona.id - 1)")
   }
   
   
   
   
//   deinit {
//      NotificationCenter.default.removeObserver(self, name: NSNotification.Name("TOCO"), object: nil)
//   }
//
}
