//
//  ImageAnnotator.swift
//  diginote
//
//  Created by Sayed Jahed Hussini on 12/5/21.
//

import Foundation
import Firebase
import FirebaseFunctions
import UIKit

// struct for the request
struct RequestData: Codable{
    
    var image: [String:String]
    var features: [[String: String]]
    var imageContext: [String:[String]]
}

class ImageAnnotator: ObservableObject{
    
    //notify when text is gotten 
    @Published var annotatedText: String = ""
    
    func annotateImage(image: UIImage) -> String? {

        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil}

        let base64encodedImage = imageData.base64EncodedString()

        let requestData = RequestData(image: ["content": base64encodedImage],
                                      features: [["type": "DOCUMENT_TEXT_DETECTION"]],
                                      imageContext: ["languageHints":["en"]]
                                    )
        
        let encoder = JSONEncoder()

        let encodedData = try! encoder.encode(requestData)
        let string = String(data: encodedData, encoding: .utf8)!
        
        let functions =  Functions.functions()
        

            
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
            
            //successful
            guard let nsaray = result?.data as? NSArray else { return }
            guard let nsdictionary = nsaray[0] as? NSDictionary else {return }
            guard let fullTextAnnotation = nsdictionary["fullTextAnnotation"] as? [String: Any] else {return}
            
            self.annotatedText = fullTextAnnotation["text"] as? String ?? ""
                
                
            }//end of functions.httpsCallable

        return self.annotatedText
            
        
    }//end annotate image
  

  }//end class imageAnnotator

