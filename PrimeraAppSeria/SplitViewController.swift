//
//  SplitViewController.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 29/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class SplitViewController: UIViewController, DatoSeleccionado, UIPickerViewDelegate, UIPickerViewDataSource, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
   
   @IBOutlet weak var nombre: UITextField!
   @IBOutlet weak var apellidos: UITextField!
   @IBOutlet weak var email: UITextField!
   @IBOutlet weak var imagen: UIImageView!
   @IBOutlet weak var direccion: UITextField!
   @IBOutlet weak var ciudad: UITextField!
   @IBOutlet weak var puesto: UITextField!
   @IBOutlet weak var compartirContacto: UIButton!
   @IBOutlet weak var cancelar: UIBarButtonItem!
   @IBOutlet weak var grabar: UIBarButtonItem!
   
   var puestos:[Puestos] = []
   var valorSeleccionado = -1
   var personaSeleccionada:Personas?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      let queryPuestos:NSFetchRequest<Puestos> = Puestos.fetchRequest()
      queryPuestos.sortDescriptors = [NSSortDescriptor(key: #keyPath(Puestos.puesto), ascending: true)]
      do {
         puestos = try ctx.fetch(queryPuestos)
      } catch {
         print("Error en la consulta de puestos")
      }
      puesto.delegate = self
      
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
      personaSeleccionada = newPersona
      if puesto.isFirstResponder {
         puesto.resignFirstResponder()
         cancelar.isEnabled = true
         grabar.isEnabled = true
      }
   }
   
   func cambiarPuesto(_ sender: UITextField) {
      let picker = UIPickerView()
      picker.delegate = self
      picker.dataSource = self

      sender.inputView = picker
      let toolbar = UIToolbar()
      toolbar.barStyle = .default
      toolbar.isTranslucent = true
      toolbar.tintColor = .gray
      toolbar.sizeToFit()
      
      let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButton(_:)))
      let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
      let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButton(_:)))
      toolbar.setItems([doneButton,space,cancelButton], animated: false)
      toolbar.isUserInteractionEnabled = true
      sender.inputAccessoryView = toolbar
   
      for (i,v) in puestos.enumerated() {
         if v.puesto == puesto.text {
            picker.selectRow(i, inComponent: 0, animated: false)
            break
         }
      }
      grabar.isEnabled = false
      cancelar.isEnabled = false
   }
   
   @objc func doneButton(_ sender:UIBarButtonItem) {
      puesto.resignFirstResponder()
      if let puestoText = puesto.text, valorSeleccionado >= 0, let selecPuesto = puestos[valorSeleccionado].puesto, puestoText != selecPuesto {
         puesto.text = selecPuesto
      }
      cancelar.isEnabled = true
      grabar.isEnabled = true
   }
   
   @objc func cancelButton(_ sender:UIBarButtonItem) {
      puesto.text = personaSeleccionada?.puesto?.puesto
      puesto.resignFirstResponder()
      cancelar.isEnabled = true
      grabar.isEnabled = true
   }
   
   @IBAction func cambiarImagen(_ sender: UIButton) {
   }
   
   @IBAction func enviarEmail(_ sender: UIButton) {
      if !MFMailComposeViewController.canSendMail() {
         print("No se pueden enviar emails")
         return
      }
      let controladorEmail = MFMailComposeViewController()
      if let email = personaSeleccionada?.email {
         controladorEmail.setToRecipients([email])
      }
      controladorEmail.setMessageBody("<p>Hola. Este es un correo de prueba</p><p>Qué <strong>bonito</strong> me ha quedado</p>", isHTML: true)
      controladorEmail.mailComposeDelegate = self
      present(controladorEmail, animated: true, completion: nil)
   }
   
   @IBAction func compartir(_ sender: UIButton) {
      guard let image = imagen.image, let nombre = nombre.text else {
         return
      }
      let activity = UIActivityViewController(activityItems: [image, nombre], applicationActivities: nil)
      activity.excludedActivityTypes = [.addToReadingList, .mail]
      activity.completionWithItemsHandler = { (activityType, success, items, error) in
         if success {
            print("Compartidos los datos")
         }
      }
      if UIDevice.current.userInterfaceIdiom == .pad {
         activity.modalPresentationStyle = .popover
         activity.popoverPresentationController?.sourceRect = compartirContacto.frame
         activity.popoverPresentationController?.sourceView = self.view
      }
      present(activity, animated: true, completion: nil)
   }
   
   @IBAction func save(_ sender: UIBarButtonItem) {
      guard let seleccionada = personaSeleccionada else {
         return
      }
      seleccionada.nombre = nombre.text
      seleccionada.apellidos = apellidos.text
      seleccionada.email = email.text
      seleccionada.direccion = direccion.text
      if valorSeleccionado >= 0 {
         let newPuesto = puestos[valorSeleccionado]
         seleccionada.puesto = newPuesto
      }
      if let ciudadSeleccionada = seleccionada.ciudad?.ciudad, let ciudadText = ciudad.text, ciudadSeleccionada != ciudadText {
         let consultaCiudad:NSFetchRequest<Ciudades> = Ciudades.fetchRequest()
         consultaCiudad.predicate = NSPredicate(format: "ciudad = %@", argumentArray: [ciudadText])
         do {
            let fetchCiudad = try ctx.fetch(consultaCiudad)
            if fetchCiudad.count > 0 {
               seleccionada.ciudad = fetchCiudad.first
            } else {
               let newCiudad = Ciudades(context: ctx)
               newCiudad.ciudad = ciudadText
               seleccionada.ciudad = newCiudad
            }
         } catch {
            print("Error en la actualización")
         }
      }
      saveContext()
      NotificationCenter.default.post(name: NSNotification.Name("SAVEDETALLE"), object: nil, userInfo: ["DatoGrabado":seleccionada])
   }
   
   @IBAction func cancel(_ sender: UIBarButtonItem) {
      if let seleccionada = personaSeleccionada {
         seleccionado(seleccionada)
      }
      cancelar.isEnabled = true
      grabar.isEnabled = true
   }
   //   deinit {
//      NotificationCenter.default.removeObserver(self, name: NSNotification.Name("TOCO"), object: nil)
//   }
//
   
   func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      controller.dismiss(animated: true, completion: nil)
   }
   
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return puestos.count
   }
   
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return puestos[row].puesto
   }
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      valorSeleccionado = row
      puesto.text = puestos[row].puesto
   }
   
   func textFieldDidBeginEditing(_ textField: UITextField) {
      cambiarPuesto(textField)
   }
}
