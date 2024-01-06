//
//  AllDetailsViewController.swift
//  DonateIt
//

//

import UIKit
import Parse
import AlamofireImage
import MapKit
import MessageUI





class AllDetailsViewController: UIViewController  {
    
    
    var post : PFObject!
    
    
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemStatus: UILabel!
    
    @IBOutlet weak var itemDescription: UILabel!
    
    @IBOutlet weak var pickupTime: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var donatedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
                   author.text = post["author"] as? String
                   category.text = post["itemCategory"] as? String
                   itemName.text = post["itemName"] as? String

                   // ... other assignments
               } else {
                   // Handle the case where post is nil
                   print("Post is nil")
               }
        author.text = post["author"] as! String
        category.text = post["itemCategory"] as? String
        itemName.text = post["itemName"] as? String
        if post["itemStatus"] as! Bool == true {
            itemStatus.text = "Status: Donated"
            donatedLabel.isHidden = false
        }
        else {
            itemStatus.text = "Status: Available"
            donatedLabel.isHidden = true
        }
        itemDescription.text = post["description"] as? String
        
        let date = post.createdAt!
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "PST") as TimeZone?
        formatter.dateFormat = "MMM d, y"
        dateLabel.text = formatter.string(from: date as! Date)
        
        pickupTime.text = post["pickupTime"] as! String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        itemImage.af_setImage(withURL: url)
        itemImage.layer.cornerRadius = 20
        itemImage.clipsToBounds = true
    }
    
    
    @IBAction func getDirectionsButton(_ sender: Any) {
        
        let placemark = post["location"] as! PFGeoPoint
        let itemLatitude = placemark.latitude
        let itemLongitude = placemark.longitude
        let coordinates = CLLocationCoordinate2D(latitude: itemLatitude, longitude: itemLongitude)
        let mkplacemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: mkplacemark)
        mapItem.name = post["itemName"] as! String?
        mapItem.openInMaps()
    }
    
    
    @IBAction func onContactButton(_ sender: Any) {

        let alertController = UIAlertController(title: "Contact", message: "Choose an option", preferredStyle: .actionSheet)

                let callAction = UIAlertAction(title: "Call", style: .default) { _ in
                    self.makeCall()
                }

                let messageAction = UIAlertAction(title: "Message", style: .default) { _ in
                    self.sendMessage()
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                alertController.addAction(callAction)
                alertController.addAction(messageAction)
                alertController.addAction(cancelAction)

                present(alertController, animated: true, completion: nil)
       
    }
    func makeCall() {
            let number = post["phoneNumber"] as! String
            if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Handle the case where the device can't make a call
                print("Device can't make a call.")
            }
        }

        func sendMessage() {
            guard MFMessageComposeViewController.canSendText() else {
                // Handle the case where the device can't send messages
                print("Device can't send messages.")
                return
            }

            let messageComposeViewController = MFMessageComposeViewController()
            messageComposeViewController.messageComposeDelegate = self

            let number = post["phoneNumber"] as! String
            let username = post["author"] as! String
            let selectitem = post["itemName"] as! String

            var itemname = ""
            for char in selectitem {
                if char == " " {
                    itemname += "%20"
                } else {
                    itemname += String(char)
                }
            }

            let body = "Hello \(username), I am interested in the \(itemname) you are donating on DonateIt."

            messageComposeViewController.recipients = [number]
            messageComposeViewController.body = body

            present(messageComposeViewController, animated: true, completion: nil)
        }

   
    
}
extension AllDetailsViewController: MFMessageComposeViewControllerDelegate {

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}



    


