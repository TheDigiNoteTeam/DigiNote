//
//  PdfViewController.swift
//  diginote
//
//  Created by Sayed Jahed Hussini on 12/2/21.
//

import UIKit
import PDFKit

class PdfViewController: UIViewController{

    var document: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayPdf()

    }
    
    
    private func createPdfView(withFrame frame: CGRect) -> PDFView {
        let pdfView = PDFView(frame: frame)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.autoScales = true
        
        return pdfView
    }
    
    private func createPdfDocument() -> PDFDocument? {
        if document != nil {
            return PDFDocument(url: document)
        }
        
        return nil
    }
    
    private func displayPdf() {
        let pdfView = self.createPdfView(withFrame: self.view.bounds)
        
        if let pdfDocument = createPdfDocument(){
            self.view.addSubview(pdfView)
            pdfView.document = pdfDocument
        }
    }

}
    




