//
//  ImageAnnotatorAsync.swift
//  diginote
//
//  Created by Sayed Jahed Hussini on 12/7/21.
//
//

import Foundation
import Firebase
import FirebaseFunctions
import UIKit

// format the input data as codable struct
// this is in order to create a json data
// otherwise firebase was complaining about
//wrong type of data being sent
struct RequestData: Codable{

    var image: [String:String]
    var features: [[String: String]]
    var imageContext: [String:[String]]
}

class ImageAnnotator{
    
    //store the extracted text here
    var annotatedText: String = ""
    
    // run asynchronously and return the extracted data
    // all the code is gotten from firebase docs
    func annotateImage(image: UIImage) async throws -> String? {
        
        // convert UIImage to string
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil}
        
        // encode it
        let base64encodedImage = imageData.base64EncodedString()
        
        //create a request
        let requestData = RequestData(image: ["content": base64encodedImage],
                                      features: [["type": "DOCUMENT_TEXT_DETECTION"]],
                                      imageContext: ["languageHints":["en"]]
                                    )
        
        // create a jsonencoder. on the official firebase docs
        // this is misssing. but not converting to json,
        // the api won't work and will complain about broken input json
        let encoder = JSONEncoder()

        let encodedData = try! encoder.encode(requestData)
        let string = String(data: encodedData, encoding: .utf8)!
        
        let functions =  Functions.functions()
        
        do {
            // call the httpsCallable function to extract text and then process it
            let result: HTTPSCallableResult? = try await functions.httpsCallable("annotateImage").call(string)
            
            //get only the text so that we return it.
            guard let nsaray = result?.data as? NSArray else { return nil }
            guard let nsdictionary = nsaray[0] as? NSDictionary else {return nil }
            guard let fullTextAnnotation = nsdictionary["fullTextAnnotation"] as? [String: Any] else {return nil}

            self.annotatedText = fullTextAnnotation["text"] as? String ?? ""
            
        } catch let error {
            //let the caller handle the error
            throw error
        }

        return self.annotatedText
            
        
    }//end annotate image
  

  }//end class imageAnnotator


