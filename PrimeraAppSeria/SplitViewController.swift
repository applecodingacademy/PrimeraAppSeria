//
//  SplitViewController.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 29/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit
import CoreData

class SplitViewController: UIViewController, DatoSeleccionado, UIPickerViewDelegate, UIPickerViewDataSource {
   
   @IBOutlet weak var nombre: UITextField!
   @IBOutlet weak var apellidos: UITextField!
   @IBOutlet weak var email: UITextField!
   @IBOutlet weak var imagen: UIImageView!
   @IBOutlet weak var direccion: UITextField!
   @IBOutlet weak var ciudad: UITextField!
   @IBOutlet weak var puesto: UITextField!
   @IBOutlet weak var botonCambiarPuesto: UIButton!
   @IBOutlet weak var cancelar: UIBarButtonItem!
   @IBOutlet weak var grabar: UIBarButtonItem!
   
   var seleccionDesplegada = false
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
   }
   
   @IBAction func cambiarPuesto(_ sender: UIButton) {
      if !seleccionDesplegada {
         let picker = UIPickerView()
         picker.delegate = self
         picker.dataSource = self
         picker.translatesAutoresizingMaskIntoConstraints = false
         picker.tag = 100
         view.addSubview(picker)
         NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
         seleccionDesplegada = true
         botonCambiarPuesto.setTitle("Elegir este puesto", for: .normal)
         botonCambiarPuesto.setTitleColor(.black, for: .normal)
         for (i,v) in puestos.enumerated() {
            if v.puesto == puesto.text {
               picker.selectRow(i, inComponent: 0, animated: false)
               break
            }
         }
         grabar.isEnabled = false
         cancelar.isEnabled = false
      } else {
         guard let picker = view.viewWithTag(100) as? UIPickerView else {
            return
         }
         seleccionDesplegada = false
         picker.removeFromSuperview()
         botonCambiarPuesto.setTitle("Cambiar de puesto", for: .normal)
         botonCambiarPuesto.setTitleColor(.blue, for: .normal)
         grabar.isEnabled = true
         cancelar.isEnabled = true
      }
   }
   
   @IBAction func cambiarImagen(_ sender: UIButton) {
   }
   
   
   @IBAction func enviarEmail(_ sender: UIButton) {
   }
   
   @IBAction func compartir(_ sender: UIButton) {
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
   }
   //   deinit {
//      NotificationCenter.default.removeObserver(self, name: NSNotification.Name("TOCO"), object: nil)
//   }
//
   
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
   
}
