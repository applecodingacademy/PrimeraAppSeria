//
//  DetailTableViewController.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 21/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
   @IBOutlet weak var nombre: UITextField!
   @IBOutlet weak var email: UITextField!
   @IBOutlet weak var apellidos: UITextField!
   @IBOutlet weak var imagen: UIImageView!
   
   var fila:Int?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      if let fila = fila {
         let datos = mockdata[fila]
         nombre.text = datos.first_name
         apellidos.text = datos.last_name
         email.text = datos.email
      }
   }
   @IBAction func validarSave(_ sender: UIBarButtonItem) {
      var errores = "Faltan valores en los siguientes campos:\n"
      var error = false
      if let nombre = nombre.text, nombre.isEmpty {
         errores += "- Nombre\n"
         error = true
      }
      if let apellidos = apellidos.text, apellidos.isEmpty {
         errores += "- Apellidos\n"
         error = true
      }
      if let email = email.text, email.isEmpty {
         errores += "- Email\n"
         error = true
      }
      if error {
         errores += "Corrija estos errores antes de continuar"
         mostrarAlerta(mensaje: errores, tipo: .error, vc: self)
      } else {
         if let fila = fila {
            var datos = mockdata[fila]
            datos.first_name = nombre.text!
            datos.last_name = apellidos.text!
            datos.email = email.text!
            mockdata[fila] = datos
         }
         saveData()
         performSegue(withIdentifier: "save", sender: self)
      }
   }
}
