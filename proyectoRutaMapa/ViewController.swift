//
//  ViewController.swift
//  proyectoRutaMapa
//
//  Created by Faktos on 21/08/16.
//  Copyright © 2016 ERM. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var select_type: UISegmentedControl!
    var startLocation :CLLocation!
    var lastDistance :CLLocationDistance!
    var distanciaTotal = 0.0
    
    private let manejador = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        select_type.selectedSegmentIndex = 0
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            map.showsUserLocation = true
        }
        else{
            manejador.stopUpdatingLocation()
            map.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        map.setRegion(region, animated: false)
        
        if startLocation == nil {
            startLocation = locations.first! as CLLocation
        }
        let distance = startLocation.distanceFromLocation(location)
        if distance > 50{
            
            distanciaTotal += distance
            var punto = CLLocationCoordinate2D()
            punto.latitude = location.coordinate.latitude
            punto.longitude = location.coordinate.longitude
            
            let pin = MKPointAnnotation()
            pin.title = "Latitud: \(NSString(format: "%.5f", punto.latitude).doubleValue) Longitud: \((NSString(format: "%.5f", punto.longitude).doubleValue))"
            pin.subtitle = "Distancia \(distanciaTotal)m"
            pin.coordinate = punto
            
            map.addAnnotation(pin)

            startLocation = locations.last! as CLLocation
        }
        
    }

    @IBAction func event_changed(sender: UISegmentedControl) {
        switch select_type.selectedSegmentIndex {
        case 0:
            map.mapType = MKMapType.Standard
        case 1:
            map.mapType = MKMapType.Satellite
        case 2:
            map.mapType = MKMapType.Hybrid
        default:
            break;
        }
    }

}

