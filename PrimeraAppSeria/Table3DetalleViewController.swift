//
//  Table3DetalleViewController.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 25/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

class Table3DetalleViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   @IBOutlet weak var username: UITextField!
   @IBOutlet weak var nombre: UITextField!
   @IBOutlet weak var apellidos: UITextField!
   @IBOutlet weak var email: UITextField!
   @IBOutlet weak var puesto: UITextField!
   @IBOutlet weak var direccion: UITextField!
   @IBOutlet weak var ciudad: UITextField!
   @IBOutlet weak var imagen: UIImageView!
   var row:Int?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      if let row = row {
         let dato = moredata[row]
         username.text = dato.username
         nombre.text = dato.first_name
         apellidos.text = dato.last_name
         email.text = dato.email
         puesto.text = dato.jobtitle
         direccion.text = dato.address
         ciudad.text = dato.city
      }
   }
   
   @IBAction func save(_ sender: UIBarButtonItem) {
      var errores = "Error: Complete los siguientes campos:\n"
      var error = false
      if let username = username.text, username.isEmpty {
         error = true
         errores += "Nombre de usuario\n"
      }
      if let nombre = nombre.text, nombre.isEmpty {
         error = true
         errores += "Nombre\n"
      }
      if let apellidos = apellidos.text, apellidos.isEmpty {
         error = true
         errores += "Apellido\n"
      }
      if let email = email.text, email.isEmpty {
         error = true
         errores += "Email\n"
      }
      if let puesto = puesto.text, puesto.isEmpty {
         error = true
         errores += "Puesto de trabajo\n"
      }
      if let direccion = direccion.text, direccion.isEmpty {
         error = true
         errores += "Dirección\n"
      }
      if let ciudad = ciudad.text, ciudad.isEmpty {
         error = true
         errores += "Ciudad\n"
      }
      if error {
         mostrarAlerta(mensaje: errores, tipo: .error, vc: self)
      } else {
         if let row = row {
            var dato = moredata[row]
            dato.username = username.text ?? ""
            dato.first_name = nombre.text ?? ""
            dato.last_name = apellidos.text ?? ""
            dato.email = email.text ?? ""
            dato.jobtitle = puesto.text ?? ""
            dato.address = direccion.text ?? ""
            dato.city = ciudad.text ?? ""
            moredata[row] = dato
            saveDataMore()
            performSegue(withIdentifier: "grabar", sender: nil)
         }
      }
   }
   
   @IBAction func cambiarFoto(_ sender: UIButton) {
      let picker = UIImagePickerController()
      picker.delegate = self
      picker.sourceType = .photoLibrary
      if let types = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
         picker.mediaTypes = types
      }
      present(picker, animated: true, completion: nil)
   }
   
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      picker.dismiss(animated: true, completion: nil)
   }
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let image = info[.originalImage] as? UIImage, let resizedImage = image.resizeImage(newWidth: 256) {
         imagen.image = resizedImage
         grabarImagen(imagen: resizedImage, file: "col_\(row ?? 0)")
      }
      picker.dismiss(animated: true, completion: nil)
   }
}
