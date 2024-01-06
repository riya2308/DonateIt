//
//  DonationMapViewController.swift
//  DonateIt
//
//  
import UIKit
import MapKit
import Parse

class DonationMapViewController: UIViewController {
    
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
            let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
            mapView.setRegion(zoomRegion, animated: true)
        }


    @IBOutlet weak var mapView: MKMapView!
    var centers = [PFObject]()
    
    private let locationManager = CLLocationManager()
    private var currentCoordinate = CLLocationCoordinate2D()
    var selectedTitle : String!
    var selectedPFObject: PFObject!
    var mapItem: MKMapItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        configureLocationServices()
        // Do any additional setup after loading the view.
    }
    
    private func configureLocationServices(){
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            mapView.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    

    private func beginLocationUpdates(locationManager: CLLocationManager){
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    private func addAnotations() {
        let dcenter1 = MKPointAnnotation()
        dcenter1.title = "Mangalore"
        dcenter1.coordinate = CLLocationCoordinate2D(latitude: 12.9141, longitude: 74.8560)
        
        let dcenter2 = MKPointAnnotation()
        dcenter2.title = "Manipal"
        dcenter2.coordinate = CLLocationCoordinate2D(latitude: 13.3525, longitude: 74.7857)
    
        let dcenter3 = MKPointAnnotation()
        dcenter3.title = "Udupi"
        dcenter3.coordinate = CLLocationCoordinate2D(latitude: 13.3409, longitude: 74.7421)
       
        mapView.addAnnotation(dcenter1)
        mapView.addAnnotation(dcenter2)
        mapView.addAnnotation(dcenter3)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "segue2" {
              let centerDetailsViewController = segue.destination as! CenterDetailsViewController
              centerDetailsViewController.receivedLocation = self.mapItem as? MKMapItem
        } else if segue.identifier == "segue1" {
            let segue1 = segue.destination as! Segue1
            segue1.receivedLocation = self.mapItem as? MKMapItem
            //let destinationViewController = segue.destination as! segue1
            // Set properties for YourSegue1ViewController if needed
        }
//          } else if segue.identifier == "segue3" {
//              let segue3 = segue.destination as! Segue3
//              segue3.receivedLocation = self.mapItem as? MKMapItem
//              //let anotherDestinationViewController = segue.destination as! segue1
//              // Set properties for YourAnotherSegueViewController if needed
//          }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        //let centerDetailsViewController = segue.destination as! CenterDetailsViewController
        //centerDetailsViewController.location = self.mapItem as! MKMapItem
        
    }
    

}

extension DonationMapViewController: CLLocationManagerDelegate{
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        
        guard let latestLocation = locations.first else{
            return
        }
        
        if currentCoordinate != nil{
            zoomToLatestLocation(with: latestLocation.coordinate)
            addAnotations()
        }
        currentCoordinate = latestLocation.coordinate
        
        
    }


    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The status changed")
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManager: manager)
    }
 }
}
extension DonationMapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if mapView.userLocation == annotation as! NSObject{
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Annotation View")
        }
       
        if annotation.title != "My Location"{
        annotationView?.image = UIImage(named: "pindrop")
        }
        
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("the annotation was selected: \(String(describing: view.annotation?.title))")
        selectedTitle = String((view.annotation?.title)!!)
        
        
        let coordinates = (view.annotation?.coordinate)!
        let mkplacemark = MKPlacemark(coordinate: coordinates)
        mapItem = MKMapItem(placemark: mkplacemark)
        mapItem.name = selectedTitle
        switch selectedTitle {
            case "Mangalore":
                performSegue(withIdentifier: "segue2", sender: nil)
            case "Manipal":
                performSegue(withIdentifier: "segue1", sender: nil)
            case "Udupi":
                performSegue(withIdentifier: "segue3", sender: nil)
            default:
                break
            }
        //performSegue(withIdentifier: "centerInfo", sender: Any?(nilLiteral: ()))
        
    }
    
}
