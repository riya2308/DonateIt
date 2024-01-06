//
//  CenterDetailsViewController.swift
//  DonateIt
//
//

import UIKit
import Parse
import MapKit

class Segue1: UIViewController {

    var receivedLocation : MKMapItem!
   
    @IBOutlet weak var itemImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        itemImage.layer.cornerRadius = 20
        itemImage.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
 
  
    @IBAction func onDirection(_ sender: Any) {
        receivedLocation.openInMaps()
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
