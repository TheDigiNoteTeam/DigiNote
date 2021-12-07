//
//  SaveFile.swift
//  diginote
//
//  Created by Sayed Jahed Hussini on 12/7/21.
//

import Foundation
import PDFKit
import TPPDF

class CreatePDF {
    
    var data: String
    var fileName: String
    
    init(fileName: String, data: String){
        self.fileName = fileName
        self.data = data
        create()
    }
    
    private func create() {
        // get the directory url of the app
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = documentsUrl.appendingPathComponent("\(fileName).pdf")
        
        let document = PDFDocument(format: .a4)
        document.add(.contentCenter, text: self.data)
        let generator = PDFGenerator(document: document)
        
       
        do {
            try generator.generate(to: fileUrl)
        }catch let error {
            print(error)
        }
//
        
    }//create
    
//    private func create() {
//        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let filePath = (documentsDirectory as NSString).appendingPathComponent("\(self.fileName).pdf") as String
//
//        let pdfTitle = "PDF Created from Image"
//        let pdfMetadata = [
//            // The name of the application creating the PDF.
//            kCGPDFContextCreator: "DigitNote",
//
//            // The name of the PDF's author.
//            kCGPDFContextAuthor: "Digit Note Author",
//
//            // The title of the PDF.
////            kCGPDFContextTitle: "Lorem Ipsum",
//
//            // Encrypts the document with the value as the owner password. Used to enable/disable different permissions.
////            kCGPDFContextOwnerPassword: "myPassword123"
//        ]
//
//        // Creates a new PDF file at the specified path.
//        UIGraphicsBeginPDFContextToFile(filePath, CGRect.zero, pdfMetadata)
//
//        // Creates a new page in the current PDF context.
//        UIGraphicsBeginPDFPage()
//
//        // Default size of the page is 612x72.
//        let pageSize = UIGraphicsGetPDFContextBounds().size
//        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
//
//        // Let's draw the title of the PDF on top of the page.
//        let attributedPDFTitle = NSAttributedString(string: pdfTitle, attributes: [NSAttributedString.Key.font: font])
//        let stringSize = attributedPDFTitle.size()
//        let stringRect = CGRect(x: (pageSize.width / 2 - stringSize.width / 2), y: 20, width: stringSize.width, height: stringSize.height)
//        attributedPDFTitle.draw(in: stringRect)
//
//        let textFont = UIFont(name: "Helvetica Bold", size: 14.0)
//
//        let textRect = CGRect(x: 5, y: 3, width: 125, height: 18)
//        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
//        paragraphStyle.alignment = NSTextAlignment.left
//        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
//
//        let textColor: UIColor = .black
//
//        let textFontAttributes = [
//            NSAttributedString.Key.font: textFont!,
//            NSAttributedString.Key.foregroundColor: textColor,
//            NSAttributedString.Key.paragraphStyle: paragraphStyle
//        ]
//
//
//        let txt: NSString = self.data as NSString
//        txt.draw(in: textRect, withAttributes: textFontAttributes)
//
//
//
//
//
//        // Closes the current PDF context and ends writing to the file.
//        UIGraphicsEndPDFContext()
//    }//create
    
    
    
    
}
