//
//  Tabla1ViewController.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 20/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

class Tabla1ViewController: UITableViewController {
   
   var variable:Int = 0
   
   override func viewDidLoad() {
      super.viewDidLoad()
      loadData()
      self.clearsSelectionOnViewWillAppear = false
      self.navigationItem.rightBarButtonItem = self.editButtonItem
      
      if UIDevice.current.userInterfaceIdiom == .pad {
         NotificationCenter.default.post(name: NSNotification.Name("TOCO"), object: nil, userInfo: ["ROW": 0])
         tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
      }
   }
   
   // MARK: - Table view data source
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return mockdata.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
      
      let datos = mockdata[indexPath.row]
      
      cell.textLabel?.text = "\(datos.last_name), \(datos.first_name)"
      cell.detailTextLabel?.text = datos.email
      cell.imageView?.image = UIImage(named: "apple")
      if let imagen = cargarImagen(file: "tab_\(indexPath.row)") {
         cell.imageView?.image = imagen
      } else {
         recuperarImagen(url: datos.avatar) { imagen in
            DispatchQueue.main.async {
               if let visibles = self.tableView.indexPathsForVisibleRows {
                  if visibles.contains(indexPath) {
                     cell.imageView?.image = imagen
                  }
                  grabarImagen(imagen: imagen, file: "tab_\(indexPath.row)")
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
         NotificationCenter.default.post(name: NSNotification.Name("TOCO"), object: nil, userInfo: ["ROW": indexPath.row])
      }
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
