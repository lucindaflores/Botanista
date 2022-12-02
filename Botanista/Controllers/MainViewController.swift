//
//  ViewController.swift
//  Botanista
//
//  Created by Lucinda Flores on 12/10/2022.
//

import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var networkManager = NetworkManager()
  
    let imagePicker = UIImagePickerController()
    var imageCamera = UIImageView()
    
    @IBOutlet var goToPhotoLibraryButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }

    
    @IBAction func scanButtonPressed(_ sender: UIButton) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func goToLibraryButtonPressed(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickerImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {

            imageCamera.image = userPickerImage
            imagePicker.dismiss(animated: true, completion: nil)
            
            performSegue(withIdentifier: "goToFlowerInfoVC", sender: self)
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFlowerInfoVC" {
            if let destinationVC = segue.destination as? FlowerInfoViewController {
                destinationVC.newCameraImage = imageCamera.image
            }
        }
    }
    
}

