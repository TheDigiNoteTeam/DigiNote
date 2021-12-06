//
//  ImageRecognizer.swift
//  diginote
//
//  Created by Sayed Jahed Hussini on 12/5/21.
//

import Firebase
import FirebaseFunctions
import UIKit
import Foundation

struct PhotoData: Encodable {
    
    var imageUrl: URL
    let image: [String: Data]
    let features = [["type": "TEXT_DETECTION"]]
    let imageContext = ["LanguageHints":["en"]]
    
    init(imageUrl: URL){
        self.imageUrl = imageUrl
        //get the image from url
        var imageData: Data = Data()
        if let data = try? Data(contentsOf: self.imageUrl){
            if let userImage = UIImage(data: data){
                imageData = userImage.jpegData(compressionQuality: 1.0)!
            }
        }
        image = ["content": imageData]
        
    }
}//end of PhotoData

class ImageRecognizer: Codable {
    
//    let imageName: String
    let imageUrl: URL
    lazy var functions = Functions.functions()
    
    init(imageUrl: URL) {
//        self.imageName = imageName
        self.imageUrl = imageUrl
    }
    
    func recognize() {
        
        let encoder = JSONEncoder()
        
        let encodedData = try! encoder.encode(PhotoData(imageUrl: self.imageUrl))
        
        let string = String(data: encodedData, encoding: .utf8)!
            
            functions.httpsCallable("annotateImage").call(string) { (result, error) in
              if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print("ERROR \(message), CODE \(code), DETAILS \(details)")
                    return
                }
                
                  print("SUCCESS")
                  print("RESULT \(result?.data)")
                
                  guard let annotation = (result?.data as? [String: Any])?["fullTextAnnotation"] as? [String: Any] else { return }
                  print("%nComplete annotation:")
                  let text = annotation["text"] as? String ?? ""
                  print("%n\(text)")
              }
                
                
            }
        }
        
}

