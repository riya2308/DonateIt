//
//  ProfileViewController.swift
//  DonateIt
//

//
import Parse
import UIKit



class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    
    
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndDisplayUserData()
        //loadAndDisplayProfilePicture()
        // Do any additional setup after loading the view.
   
        loadAndDisplayProfilePicture()
    }
    
    @IBAction func LogOut(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController = loginViewController
    }
    func fetchAndDisplayUserData() {
            if let currentUser = PFUser.current() {
                if let names = currentUser["name"] as? String {
                    name.text = "\(names)"
                }

                if let usernames = currentUser.username {
                    username.text = "@\(usernames)"
                }

                if let emails = currentUser.email {
                    email.text = "\(emails)"
                }
            }
        }
    func loadAndDisplayProfilePicture() {
        if let imageData = UserDefaults.standard.data(forKey: "profileImageData") {
            if let profileImage = UIImage(data: imageData) {
                profileImageView.image = profileImage
            }
        }
    }
    
     @IBAction func uploadImageButtonTapped(_ sender: Any) {
         let imagePicker = UIImagePickerController()
                 imagePicker.delegate = self
                 imagePicker.sourceType = .photoLibrary // You can also use .camera if you want to allow capturing from the camera
                 present(imagePicker, animated: true, completion: nil)
     }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                profileImageView.image = selectedImage
                dismiss(animated: true, completion: nil)

                // Save the selected image to UserDefaults
                if let imageData = selectedImage.pngData() {
                    UserDefaults.standard.set(imageData, forKey: "profileImageData")
                }
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
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
