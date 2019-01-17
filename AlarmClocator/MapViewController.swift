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


class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var myMapView: MKMapView!
    
    var location: CLLocationCoordinate2D?
    var locationName: String?
    
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToAddScreen", sender: self)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true)
        
        //create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        //adding the requested location to a variable
        self.locationName = searchBar.text
        
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
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)
                
                //zooming-in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                
                //adding the requested location coordinates to a variable
                self.location = coordinate
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) //means how much we want to be assumed in
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.myMapView.setRegion(region, animated: true)
                
            }
        }
        
    }
    
    @IBOutlet weak var SearchButton: UIBarButtonItem!

    let manager = CLLocationManager()
    
    //this function controls the attributes of the user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        myMapView.setRegion(region, animated: true)
        
        self.myMapView.showsUserLocation = true
        
}
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        
        // Do any additional setup after loading the view.
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
