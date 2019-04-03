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
   @IBOutlet weak var direccion: UITextField!
   @IBOutlet weak var ciudad: UITextField!
   @IBOutlet weak var puesto: UITextField!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
//      NotificationCenter.default.addObserver(forName: NSNotification.Name("TOCO"), object: nil, queue: OperationQueue.main) { [weak self] notification in
//         if let datos = notification.userInfo as? [String:Int], let row = datos["ROW"] {
//            self?.testEtiqueta.text = "\(row)"
//         }
//      }
   }
   
   func seleccionado(_ newPersona: Personas) {
      nombre.text = newPersona.nombre
      apellidos.text = newPersona.apellidos
      email.text = newPersona.email
      if let datosImagen = newPersona.imagen {
         imagen.image = UIImage(data: datosImagen)
      }
      direccion.text = newPersona.direccion
      ciudad.text = newPersona.ciudad?.ciudad
      puesto.text = newPersona.puesto?.puesto
   }
   
   @IBAction func cambiarImagen(_ sender: UIButton) {
   }
   
   
   @IBAction func enviarEmail(_ sender: UIButton) {
   }
   
   @IBAction func compartir(_ sender: UIButton) {
   }
   //   deinit {
//      NotificationCenter.default.removeObserver(self, name: NSNotification.Name("TOCO"), object: nil)
//   }
//
}
