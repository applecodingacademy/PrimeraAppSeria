//
//  CollectionViewController.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 22/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.clearsSelectionOnViewWillAppear = false
      if moredata.isEmpty {
         loadDataMore()
      }
   }
   
   // MARK: UICollectionViewDataSource
   
   override func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return mockdata.count
   }
   
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "zeldaCol", for: indexPath) as! CollectionViewZelda
      let dato = moredata[indexPath.row]
      cell.first_name.text = dato.first_name
      cell.last_name.text = dato.last_name
      cell.email.text = dato.email
      cell.row = indexPath.row
      if let imagen = cargarImagen(file: "col_\(indexPath.row)") {
         cell.imagen.image = imagen
      } else {
         recuperarImagen(url: dato.avatar) { imagen in
            DispatchQueue.main.async {
               if self.collectionView.indexPathsForVisibleItems.contains(indexPath) {
                  cell.imagen.image = imagen
                  grabarImagen(imagen: imagen, file: "col_\(indexPath.row)")
               }
            }
         }
      }
      return cell
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      guard let zelda = sender as? CollectionViewZelda, let destination = segue.destination as? Table3DetalleViewController else {
         return
      }
      destination.row = zelda.row
   }
   
   @IBAction func salidaColeccion(segue:UIStoryboardSegue) {
      if segue.identifier == "grabar", let source = segue.source as? Table3DetalleViewController, let row = source.row {
         let index = IndexPath(item: row, section: 0)
         collectionView.reloadItems(at: [index])
      }
   }
   
   // MARK: UICollectionViewDelegate
   
   /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return true
    }
    */
   
   /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
    }
    */
   
   /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
    return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
    return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
   
}
