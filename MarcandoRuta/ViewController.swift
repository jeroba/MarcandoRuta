//
//  ViewController.swift
//  MarcandoRuta
//
//  Created by Jesus Rodriguez Barrera on 02/04/16.
//  Copyright © 2016 Aplicapp. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapa: MKMapView!

    private let manejador = CLLocationManager()
    
    let regionRadius: CLLocationDistance = 1000
    var initialLocation: CLLocation? = nil
    var ultimaLocation: CLLocation? = nil
    var distanciaRecorrida = 0.0
    
    @IBOutlet weak var tipoMapaControl: UISegmentedControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            
            
        }else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if initialLocation == nil{
            
            initialLocation = manejador.location
            centerMapOnLocation(initialLocation!)
            
            ultimaLocation = initialLocation
            
            var punto = CLLocationCoordinate2D()
            punto.latitude = initialLocation!.coordinate.latitude
            punto.longitude = initialLocation!.coordinate.longitude
            
            let pin = MKPointAnnotation()
            pin.title = "Longitud: \(initialLocation!.coordinate.longitude) Latitud: \(initialLocation!.coordinate.latitude)"
            pin.subtitle = "Distancia recorrida: 0 metros"
            pin.coordinate = punto
            
            mapa.addAnnotation(pin)
        }else{
            initialLocation = manejador.location
            centerMapOnLocation(initialLocation!)
            
            let distance = ultimaLocation!.distanceFromLocation(initialLocation!)
            
            if distance >= 50{
                distanciaRecorrida += 50
                
                ultimaLocation = initialLocation
                var punto = CLLocationCoordinate2D()
                punto.latitude = initialLocation!.coordinate.latitude
                punto.longitude = initialLocation!.coordinate.longitude
                
                let pin = MKPointAnnotation()
                pin.title = "Longitud: \(initialLocation!.coordinate.longitude) Latitud: \(initialLocation!.coordinate.latitude)"
                pin.subtitle = "Distancia recorrida: \(Int(distanciaRecorrida)) metros"
                pin.coordinate = punto
                
                mapa.addAnnotation(pin)
            }
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let alerta = UIAlertController(title: "ERROR", message: "error \(error.code)", preferredStyle: .Alert)
        
        let accionOK = UIAlertAction(title: "OK", style: .Default, handler: {
            accion in
            //..
        })
        
        alerta.addAction(accionOK)
        self.presentViewController(alerta, animated: true, completion: nil)
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapa.setRegion(coordinateRegion, animated: true)
    }
    
    
    @IBAction func tipoMapaCambio(sender: AnyObject) {
        switch (tipoMapaControl.selectedSegmentIndex) {
        case 0:
            mapa.mapType = MKMapType.Standard
        case 1:
            mapa.mapType = MKMapType.Satellite
        case 2:
            mapa.mapType = MKMapType.Hybrid
        default:
            mapa.mapType = MKMapType.Standard
        }
    }
    
   }

