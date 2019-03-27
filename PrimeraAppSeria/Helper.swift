//
//  Helper.swift
//  PrimeraAppSeria
//
//  Created by Dev1 on 21/03/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

enum TipoAlerta {
   case info, error
}

func mostrarAlerta(mensaje:String, tipo:TipoAlerta, vc:UIViewController) {
   let alerta = UIAlertController(title: tipo == .info ? "Información" : "Error", message: mensaje, preferredStyle: .alert)
   let accion = UIAlertAction(title: "OK", style: .default, handler: nil)
   alerta.addAction(accion)
   vc.present(alerta, animated: true, completion: nil)
}
