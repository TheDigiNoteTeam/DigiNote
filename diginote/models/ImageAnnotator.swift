//
//  ImageAnnotator.swift
//  diginote
//
//  Created by Sayed Jahed Hussini on 12/5/21.
//

import Foundation
import Firebase
import FirebaseFunctions
import Resolver

class ImageAnnotator: ObservableObject {
  @LazyInjected var functions: Functions
  @Published var annotatedText: String?
  
  func annotateImage(imageData: Data) {

    struct requestData: Encodable {
      let image: [String: Data]
      let features = [["type": "DOCUMENT_TEXT_DETECTION"]]

      init(imageData: Data) {
        image = ["content": imageData]
      }
    }

    let encoder = JSONEncoder()

    let encodedData = try! encoder.encode(requestData(imageData: imageData))
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
}
