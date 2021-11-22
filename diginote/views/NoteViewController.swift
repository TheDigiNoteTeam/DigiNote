//
//  NoteViewController.swift
//  diginote
//
//  Created by Sayed Jahed Hussini on 11/16/21.
//

import UIKit
import Vision
//import Firebase

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
//        recognizeText(image: self.imagePicked)
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
    
//    func recognizeTextFirebase(image: UIImage){
//        let vision = Vision.vision()
//        let vImage = VisionImage(image: image)
//        let textRecognizer = vision.cloudTextRecognizer()
//
//        textRecognizer.process(vImage){ result, error in
//            guard error == nil, let result = result else {
//                return
//            }
//
//            let resultText = result.text
//
//            print(resultText)
//        }
//    }
    
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
          
//          recognizeTextFirebase(image: image)
//          self.imagePicked = image
//          recognizeText(image: image)
      }
}
