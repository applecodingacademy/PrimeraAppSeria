//
//  Model.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 20/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit
import CoreData

var persistentContainer:NSPersistentContainer = {
   let container = NSPersistentContainer(name: "MOREDATA")
   container.loadPersistentStores { storeDescripcion, error in
      if let error = error as NSError? {
         fatalError("No se ha podido abrir la BD")
      }
   }
   return container
}()

var ctx:NSManagedObjectContext {
   return persistentContainer.viewContext
}

func saveContext() {
   if ctx.hasChanges {
      do {
         try ctx.save()
      } catch {
         print("Error en el commit")
      }
   }
}

var mockdata:[MockData] = []
var moredata:[MoreData] = []

struct MockData:Codable {
   let id:Int
   var first_name:String
   var last_name:String
   var email:String
   var avatar:URL
}

struct MoreData:Codable {
   var username:String
   var first_name:String
   var last_name:String
   var email:String
   var jobtitle:String
   var address:String
   var city:String
   var avatar:URL
}

func loadData() {
   guard let ruta = Bundle.main.url(forResource: "MOCK_DATA", withExtension: "json"), let rutaDoc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("MOCK_DATA").appendingPathExtension("json") else {
      return
   }
   print(rutaDoc)
   let rutaFinal = FileManager.default.fileExists(atPath: rutaDoc.path) ? rutaDoc : ruta
   do {
      let rawData = try Data(contentsOf: rutaFinal)
      let decoder = JSONDecoder()
      mockdata = try decoder.decode([MockData].self, from: rawData)
      
   } catch {
      print("Error \(error)")
   }
}

func saveData() {
   guard let ruta = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("MOCK_DATA").appendingPathExtension("json") else {
      return
   }
   if FileManager.default.fileExists(atPath: ruta.path) {
      try? FileManager.default.removeItem(at: ruta)
   }
   do {
      let encoder = JSONEncoder()
      let rawData = try encoder.encode(mockdata)
      try rawData.write(to: ruta, options: .atomicWrite)
   } catch {
      print("Error \(error)")
   }
}

func loadDataMore() {
   guard let ruta = Bundle.main.url(forResource: "MORE_DATA", withExtension: "json"), let rutaDoc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("MORE_DATA").appendingPathExtension("json") else {
      return
   }
   print(rutaDoc)
   let rutaFinal = FileManager.default.fileExists(atPath: rutaDoc.path) ? rutaDoc : ruta
   do {
      let rawData = try Data(contentsOf: rutaFinal)
      let decoder = JSONDecoder()
      let cargaMore = try decoder.decode([MoreData].self, from: rawData)
      for carga in cargaMore {
         let consulta:NSFetchRequest<Personas> = Personas.fetchRequest()
         consulta.predicate = NSPredicate(format: "userName = %@", carga.username)
         let count = try ctx.count(for: consulta)
         if count == 0 {
            let newPersonas = Personas(context: ctx)
            newPersonas.userName = carga.username
            newPersonas.nombre = carga.first_name
            newPersonas.apellidos = carga.last_name
            newPersonas.email = carga.email
            newPersonas.direccion = carga.address
            newPersonas.avatarURL = carga.avatar
            
            let consultaPuesto:NSFetchRequest<Puestos> = Puestos.fetchRequest()
            consultaPuesto.predicate = NSPredicate(format: "puesto = %@", argumentArray: [carga.jobtitle])
            let fetchPuesto = try ctx.fetch(consultaPuesto)
            if fetchPuesto.count > 0 {
               newPersonas.puesto = fetchPuesto.first
            } else {
               let newPuesto = Puestos(context: ctx)
               newPuesto.puesto = carga.jobtitle
               newPersonas.puesto = newPuesto
            }
            
            let consultaCiudad:NSFetchRequest<Ciudades> = Ciudades.fetchRequest()
            consultaCiudad.predicate = NSPredicate(format: "ciudad = %@", argumentArray: [carga.city])
            let fetchCiudad = try ctx.fetch(consultaCiudad)
            if fetchCiudad.count > 0 {
               newPersonas.ciudad = fetchCiudad.first
            } else {
               let newCiudad = Ciudades(context: ctx)
               newCiudad.ciudad = carga.city
               newPersonas.ciudad = newCiudad
            }
         }
      }
      saveContext()
   } catch {
      print("Error \(error)")
   }
}

func saveDataMore() {
   guard let ruta = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("MORE_DATA").appendingPathExtension("json") else {
      return
   }
   if FileManager.default.fileExists(atPath: ruta.path) {
      try? FileManager.default.removeItem(at: ruta)
   }
   do {
      let encoder = JSONEncoder()
      let rawData = try encoder.encode(moredata)
      try rawData.write(to: ruta, options: .atomicWrite)
   } catch {
      print("Error \(error)")
   }
}

func grabarImagen(imagen:UIImage, file:String) {
   guard let ruta = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(file).appendingPathExtension("png") else {
      return
   }
   if FileManager.default.fileExists(atPath: ruta.path) {
      try? FileManager.default.removeItem(at: ruta)
   }
   do {
      let imagenData = imagen.pngData()
      try imagenData?.write(to: ruta, options: .atomicWrite)
   } catch {
      print("Error al grabar la imagen \(error)")
   }
}

func cargarImagen(file:String) -> UIImage? {
   guard let ruta = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(file).appendingPathExtension("png") else {
      return nil
   }
   do {
      if FileManager.default.fileExists(atPath: ruta.path) {
         let imagenRaw = try Data(contentsOf: ruta)
         return UIImage(data: imagenRaw)
      }
   } catch {
      print("Error recuperación la imagen \(error)")
   }
   return nil
}


