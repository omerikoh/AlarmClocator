//
//  MapViewController.swift
//  AlarmClocator
//
//  Created by Omer Hasson on 18/12/2018.
//  Copyright © 2018 Omer Hasson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var myMapView: MKMapView!
    
    // These variables are being used in the searching function
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!

    var location: CLLocationCoordinate2D?
    var locationName: String?
    
    
    
    
    @IBAction func donePressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToAddScreen", sender: self)
    }
    
    // This function shows the user's location at the moment he's openning the map view
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        myMapView.setRegion(region, animated: true)
        
        self.myMapView.showsUserLocation = true
        self.manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        addMapTrackingButton()
        
        // Lines 132-144 build the search bar and the list of places
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = myMapView
        locationSearchTable.handleMapSearchDelegate = self as HandleMapSearch
        
        // Do any additional setup after loading the view.
    }
    
    /// This function adds the button that let the user to focus on his location
    func addMapTrackingButton(){
        let buttonItem = MKUserTrackingButton(mapView: myMapView)
        buttonItem.frame = CGRect(origin: CGPoint(x: 336.5, y: 45), size: CGSize(width: 35, height: 35))
        
        myMapView.addSubview(buttonItem)
    }
    
    @objc func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //the chosen location
        guard let destinationViewController = segue.destination as? AddScreen else {return}
        
        if self.location != nil {
            destinationViewController.destinationName = self.locationName
            destinationViewController.destination = self.location
            destinationViewController.tableView.reloadData()
        }
    }
 
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark){
        /*/ cache the pin
        selectedPin = placemark
        // clear existing pins
        myMapView.removeAnnotations(myMapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
 */
        /*
        myMapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        myMapView.setRegion(region, animated: true)
        */
        //create the search request
        
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = placemark.title
        
        //adding the requested location to a variable
        self.locationName = placemark.name
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil
            {
                // If location hasn't been found
                self.locationName = nil
                self.location = nil
                print("LOCATION WAS NOT FOUND")
            }
            else
            {
                //remove annotations
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                
                //getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                UserDefaults.standard.set(latitude, forKey: "latitude")
                
                //create annotation
                let annotation = MKPointAnnotation()
                annotation.title = placemark.title
                annotation.coordinate = placemark.coordinate
                self.myMapView.addAnnotation(annotation)
                
                if let city = placemark.locality,
                    let state = placemark.administrativeArea {
                    annotation.subtitle = "\(city) \(state)"
                }
                
                //zooming-in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                
                //adding the requested location coordinates to a variable
                self.location = coordinate
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) //means how much we want to be assumed in
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.myMapView.setRegion(region, animated: true)
                
            }
        }
    }
}
