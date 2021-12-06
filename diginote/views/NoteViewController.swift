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


struct RequestData: Codable{
    var image: [String:String]
    var features: [[String: String]]
    var imageContext: [String:[String]]
}

class NoteViewController: UIViewController {

   
    var text: String!
    var imagePicked: UIImage!
    var imagePickedUrl: URL!
    
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
    
    
//    func recognizeTextFirebase(){
//        print("Initialized text extraction ...")
//        ImageRecognizer.init(imageUrl: self.imagePickedUrl).recognize()
//        print("Text extraction finished.")
//    }


    func recognizeTextFirebase(){

        ProgressHUD.show()

        
        guard let imageData = self.imagePicked.jpegData(compressionQuality: 1.0) else { return }

  
        let base64encodedImage = imageData.base64EncodedString()

        lazy var functions = Functions.functions()

        let requestData = RequestData(image: ["content": base64encodedImage],
                                      features: [["type": "TEXT_DETECTION"]],
                                      imageContext: ["languageHints":["en"]]
                                    )
        
        let encoder = JSONEncoder()

        let encodedData = try! encoder.encode(requestData)
        let string = String(data: encodedData, encoding: .utf8)!
        functions.httpsCallable("annotateImage").call(string) { (result, error) in
          if let error = error as NSError? {
            if error.domain == FunctionsErrorDomain {
              let code = FunctionsErrorCode(rawValue: error.code)
              let message = error.localizedDescription
              let details = error.userInfo[FunctionsErrorDetailsKey]
              print("ERROR \(String(describing: message)), CODE \(String(describing: code)), DETAILS \(String(describing: details))")
            }
            return
          }
            ProgressHUD.dismiss()
          print("Success.")
            DispatchQueue.main.async {
              /* Parse result object */
              guard let nsarray = result?.data as? NSArray
              else {
                return
              }
              
              guard let nsdictionary = nsarray[0] as? NSDictionary
              else {
                return
              }

              guard let fullTextAnnotation = nsdictionary["fullTextAnnotation"] as? [String: Any]
              else {
                return
              }
              
              let text = fullTextAnnotation["text"] as? String ?? ""
              print("Recognized text: \(text)")
            }
        



        }
        
    }
    
    func recognizeText(image: UIImage?){
        guard let cgImage = image?.cgImage else {
            fatalError("Could not get CG Image")
        }
        
        // handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Request
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                      return
                  }
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            
            
            
            DispatchQueue.main.async {
//                self.text = text
                print(text)
                print("done here")
            }
            
            
        }
        
        //process
        do {
            try handler.perform([request])
        }
        catch {
            print(error	)
        }
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
          guard let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
              return
          }
          
          self.imagePicked = image
          self.imagePickedUrl = imageUrl
          recognizeTextFirebase()
//
//          recognizeText(image: image)
      }
}
