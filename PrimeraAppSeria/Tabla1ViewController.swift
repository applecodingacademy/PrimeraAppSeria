//
//  Tabla1ViewController.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 20/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit
import CoreData

protocol DatoSeleccionado:class {
   func seleccionado(_ newPersona:Personas)
}

class Tabla1ViewController: UITableViewController {
   
   var variable:Int = 0
   weak var delegate:DatoSeleccionado?
   
   var consultaTabla:NSFetchedResultsController<Personas> = {
      let fetchRequest:NSFetchRequest<Personas> = Personas.fetchRequest()
      let ordenApellidos = NSSortDescriptor(key: "apellidos", ascending: true)
      let ordenNombre = NSSortDescriptor(key: "nombre", ascending: true)
      let ordenPuesto = NSSortDescriptor(key: #keyPath(Personas.puesto.puesto), ascending: true)
      fetchRequest.sortDescriptors = [ordenPuesto, ordenApellidos, ordenNombre]
      let result = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ctx, sectionNameKeyPath: #keyPath(Personas.puesto.puesto), cacheName: nil)
      return result
   }()
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      if UIDevice.current.userInterfaceIdiom == .pad {
         let indexInicio = IndexPath(row: 0, section: 0)
         tableView.selectRow(at: indexInicio, animated: false, scrollPosition: .none)
         let dato = consultaTabla.object(at: indexInicio)
         delegate?.seleccionado(dato)
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.clearsSelectionOnViewWillAppear = false
      self.navigationItem.rightBarButtonItem = self.editButtonItem
      
      if UIDevice.current.userInterfaceIdiom == .pad {
//         NotificationCenter.default.post(name: NSNotification.Name("TOCO"), object: nil, userInfo: ["ROW": 0])
//         tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
         
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let splitView = appDelegate.window?.rootViewController as? UISplitViewController, let navigation = splitView.viewControllers.last as? UINavigationController, let detalle = navigation.topViewController as? SplitViewController else {
            return
         }
         delegate = detalle
         reload()
         NotificationCenter.default.addObserver(forName: NSNotification.Name("SAVEDETALLE"), object: nil, queue: OperationQueue.main) { notification in
            self.reload()
            self.tableView.reloadData()
            if let userInfo = notification.userInfo, let persona = userInfo["DatoGrabado"] as? Personas, let index = self.consultaTabla.indexPath(forObject: persona) {
               self.tableView.scrollToRow(at: index, at: .middle, animated: false)
               self.tableView.selectRow(at: index, animated: false, scrollPosition: .middle)
            }
         }
      }
   }
   
   func reload() {
      do {
         try consultaTabla.performFetch()
      } catch {
         print("Error en la consulta")
      }
   }
   
   // MARK: - Table view data source
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      return consultaTabla.sections?.count ?? 0
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return consultaTabla.sections?[section].numberOfObjects ?? 0
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
      
      let datos = consultaTabla.object(at: indexPath)
      
      cell.textLabel?.text = "\(datos.apellidos ?? ""), \(datos.nombre ?? "")"
      cell.detailTextLabel?.text = datos.email
      cell.imageView?.image = UIImage(named: "apple")
      if let datosImagen = datos.imagen, let imagen = UIImage(data: datosImagen) {
         cell.imageView?.image = imagen
      } else {
         if let avatarURL = datos.avatarURL {
            recuperarImagen(url: avatarURL) { imagen in
               DispatchQueue.main.async {
                  if let visibles = self.tableView.indexPathsForVisibleRows {
                     if visibles.contains(indexPath) {
                        cell.imageView?.image = imagen
                     }
                     datos.imagen = imagen.pngData()
                     saveContext()
                  }
               }
            }
         }
      }
      return cell
   }
   
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
   }
   
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
         mockdata.remove(at: indexPath.row)
         tableView.deleteRows(at: [indexPath], with: .fade)
      }
   }
   
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
      mockdata.insert(mockdata.remove(at: fromIndexPath.row), at: to.row)
   }
   
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      return true
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if UIDevice.current.userInterfaceIdiom == .pad {
         //NotificationCenter.default.post(name: NSNotification.Name("TOCO"), object: nil, userInfo: ["ROW": indexPath.row])
         let dato = consultaTabla.object(at: indexPath)
         delegate?.seleccionado(dato)
      }
   }
   
   override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      return consultaTabla.sections?[section].name ?? ""
   }
   
   // MARK: - Navigation
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "detalle" {
         guard let celda = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: celda), let destination = segue.destination as? DetailTableViewController else {
            return
         }
         destination.fila = indexPath.row
         destination.imagenTmp = celda.imageView?.image
      }
   }
   
   @IBAction func salida(segue: UIStoryboardSegue) {
      if segue.identifier == "save", let source = segue.source as? DetailTableViewController, let fila = source.fila {
         let indexPath = IndexPath(row: fila, section: 0)
         tableView.reloadRows(at: [indexPath], with: .automatic)
      }
   }
}
