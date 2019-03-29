//
//  Model.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 20/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

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
      moredata = try decoder.decode([MoreData].self, from: rawData)
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


