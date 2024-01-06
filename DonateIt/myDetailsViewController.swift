//
//  myDetailsViewController.swift
//  DonateIt
//

//

import UIKit
import Parse
import AlamofireImage

class myDetailsViewController: UIViewController {


    var post: PFObject!
        
        
        @IBOutlet weak var author: UILabel!
        @IBOutlet weak var category: UILabel!
        @IBOutlet weak var itemImage: UIImageView!
        @IBOutlet weak var itemName: UILabel!
        @IBOutlet weak var itemStatus: UILabel!
        @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var pickupTime: UILabel?
        @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var donatedLabel: UILabel!
    
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            author.text = post["author"] as? String
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
            
            pickupTime?.text = post["pickupTime"] as! String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
           itemImage.af_setImage(withURL: url)
            itemImage.layer.cornerRadius = 20
            itemImage.clipsToBounds = true
        
            
            let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonPressed))
                   navigationItem.rightBarButtonItem = deleteButton
        }
    
    
    @objc func deleteButtonPressed() {
            // Show an alert to confirm deletion
            let alertController = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                // Perform the deletion
                self.deletePost()
            }
            alertController.addAction(deleteAction)

            present(alertController, animated: true, completion: nil)
        }

    func deletePost() {
        // Delete the post from Parse
        post.deleteInBackground { (success, error) in
            if success {
                // Post deleted successfully, navigate back or perform any additional actions
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Error deleting post: \(error?.localizedDescription ?? "Unknown error")")
            }
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
