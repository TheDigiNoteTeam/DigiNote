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
//        recognizeText(image: self.imagePicked)
//        recognizeTextFirebase(image: self.imagePicked)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func recognizeTextFirebase(image: UIImage){
        
        //show progress
        ProgressHUD.colorHUD = .white
        ProgressHUD.colorAnimation = UIColor(displayP3Red: 1/255.0, green: 4/255.0, blue: 69/255.0, alpha: 1)
        ProgressHUD.colorStatus = .label
        ProgressHUD.animationType = .lineScaling
        
        ProgressHUD.show()
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        let base64encodedImage = imageData.base64EncodedString()
        
        lazy var functions = Functions.functions()
        
        let requestData = [
          "image": ["content": base64encodedImage],
          "features": ["type": "TEXT_DETECTION"],
          "imageContext": ["languageHints": ["en"]],
        ]

        functions.httpsCallable("annotageImage").call(requestData) { result, error in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain{
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
//                    print(code,message,details!!!!)
//                    print(error)
                    print("Code is\n:\(code)")
                    print("Message is:\n\(message)")
                    print("Details:\n\(details)")
                    print("Error Complete:\n\(error)")
                    ProgressHUD.showError()
                    return
                }
            }
            
            ProgressHUD.showSucceed()
            ProgressHUD.dismiss()
            print("SUCCESS")
            guard let annotation = (result?.data as? [String: Any])?["fullTextAnnotation"] as? [String: Any] else {
                print(result?.data)
                return
                
            }
            print("%nComplete annotation:")
            let text = annotation["text"] as? String ?? ""
            print("%n\(text)")
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
           
          self.imagePicked = image
          recognizeTextFirebase(image: image)
//
//          recognizeText(image: image)
      }
}
