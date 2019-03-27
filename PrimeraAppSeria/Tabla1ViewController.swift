//
//  Tabla1ViewController.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 20/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

class Tabla1ViewController: UITableViewController {
   
   let testData = ["John Williams", "Jerry Goldsmith", "James Horner", "James Newton Howard", "Michael Giacchino", "John Barry", "David Arnold", "Brian Tyler", "Joel McNeely", "Bruce Broughton", "John Debney", "Alan Silvestri"]
   
   override func viewDidLoad() {
      super.viewDidLoad()
      loadData()
      // Uncomment the following line to preserve selection between presentations
      self.clearsSelectionOnViewWillAppear = false
      
      // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
      self.navigationItem.rightBarButtonItem = self.editButtonItem
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
   
   // MARK: - Navigation
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "detalle" {
         guard let celda = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: celda), let destination = segue.destination as? DetailTableViewController else {
            return
         }
         destination.fila = indexPath.row
      }
   }
   
   @IBAction func salida(segue: UIStoryboardSegue) {
      if segue.identifier == "save", let source = segue.source as? DetailTableViewController, let fila = source.fila {
         let indexPath = IndexPath(row: fila, section: 0)
         tableView.reloadRows(at: [indexPath], with: .automatic)
      }
   }
}
