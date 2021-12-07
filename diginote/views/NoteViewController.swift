//
//  NoteViewController.swift
//  diginote
//
//  Created by Sayed Jahed Hussini on 11/16/21.
//

import UIKit
import Vision
import Firebase
import FirebaseFunctions
import ProgressHUD
import SwiftUI


//struct RequestData: Codable{
//    var image: [String:String]
//    var features: [[String: String]]
//    var imageContext: [String:[String]]
//}

class NoteViewController: UIViewController {

   
    var text: String!
    var imagePicked: UIImage!
    
    @IBAction func openPhotoGalleryBtn(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @IBAction func openCameraBtn(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        
        present(imagePicker, animated: true)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        ProgressHUD.colorHUD = .white
        ProgressHUD.colorAnimation = UIColor(displayP3Red: 1/255.0, green: 4/255.0, blue: 69/255.0, alpha: 1)
        ProgressHUD.colorStatus = .label
        ProgressHUD.animationType = .lineScaling

    }
    
    

    
}

extension NoteViewController: UIImagePickerControllerDelegate,
                              UINavigationControllerDelegate {
                                  
      func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
          picker.dismiss(animated: true, completion: nil)
      }
      
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          picker.dismiss(animated: true, completion: nil)
          guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
              return
          }
          
          self.imagePicked = image

        //show the waiting animation
        ProgressHUD.show("Extracting Text...")

        //
        Task.init{
            
            do {
                self.text = try await ImageAnnotatorAsync().annotateImage(image: self.imagePicked)
//                let okDialogMessage = UIAlertController(title: "Success", message: self.text!, preferredStyle: .alert)
//                self.present(okDialogMessage, animated: true , completion: nil)
                
            }catch let error as NSError {
                
                let errorDialogMessage = UIAlertController(title: "Error", message: "Could not extract data.", preferredStyle: .alert)
                self.present(errorDialogMessage, animated: true, completion: nil)
                
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print("ERROR \(String(describing: message)), CODE \(String(describing: code)), DETAILS \(String(describing: details))")
                    
                }
            }
            
            ProgressHUD.dismiss()
        }

      }
}
