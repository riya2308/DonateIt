//
//  PostViewController.swift
//  DonateIt
//

//

import UIKit
import AlamofireImage
import Parse
import CoreLocation

class PostViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var itemName: UITextField!
    
    @IBOutlet var itemDescription: UITextField!
    
    @IBOutlet var itemCategory: UIPickerView!
    
    @IBOutlet var itemPickupTime: UITextField!
    private var datePicker: UIDatePicker?
    
    @IBOutlet var itemImage: UIImageView!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    var userlocation: CLLocation!
    var geolocation: PFGeoPoint!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.userlocation = locationManager.location
            self.geolocation = PFGeoPoint(location: userlocation)
        }
        
        self.itemCategory.delegate = self
        self.itemCategory.dataSource = self
        
        pickerData = ["Clothes","Electronics","Food", "Furniture","Sports","Toys", "Other"]
        datePicker = UIDatePicker()
                datePicker?.datePickerMode = .time
                itemPickupTime.inputView = datePicker

                // Add a toolbar with a "Done" button to dismiss the date picker
                let toolbar = UIToolbar()
                toolbar.sizeToFit()

                let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
                toolbar.setItems([doneButton], animated: true)

                itemPickupTime.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
            // Format the selected date and update the text field
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            itemPickupTime.text = formatter.string(from: datePicker!.date)

            // Dismiss the date picker
            itemPickupTime.resignFirstResponder()
        }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    @IBAction func onPhotoButton(_ sender: Any) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.allowsEditing = true
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                    picker.sourceType = .camera
//                } else {
//                    picker.sourceType = .photoLibrary
//                }
//        
//        //picker.sourceType = .photoLibrary
//        present(picker, animated: true, completion: nil)
        
        let picker = UIImagePickerController()
               picker.delegate = self
               picker.allowsEditing = true

               let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)

               let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                   picker.sourceType = .camera
                   self.present(picker, animated: true, completion: nil)
               }

               let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
                   picker.sourceType = .photoLibrary
                   self.present(picker, animated: true, completion: nil)
               }

               let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

               alertController.addAction(cameraAction)
               alertController.addAction(photoLibraryAction)
               alertController.addAction(cancelAction)

               present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        itemImage.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPostButton(_ sender: Any) {
        
        guard let PhoneNumber = phoneNumber.text, PhoneNumber.count == 10, PhoneNumber.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil else {
                showAlert(title: "Error", message: "Please enter a valid 10-digit phone number.")
                return
            }
        let post = PFObject(className: "Item")
        
        post["location"] = geolocation
        post["itemName"] = itemName.text!
        post["description"] = itemDescription.text!
        post["itemCategory"] = pickerData[itemCategory.selectedRow(inComponent: 0)]
        post["itemStatus"] = false
        post["phoneNumber"] = phoneNumber.text!
        let imageData = itemImage.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        post["image"] = file
        post["author"] = PFUser.current()?.username!
        post["pickupTime"] = itemPickupTime.text!
        
        post.saveInBackground { (success, error) in
            if success {
                print("saved")
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                print("error")
            }
        }
    }
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
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
