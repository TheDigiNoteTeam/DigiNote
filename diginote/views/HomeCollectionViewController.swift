//
//  HomeCollectionViewController.swift
//  diginote
//
//  Created by Sayed Jahed Hussini on 11/21/21.
//

import UIKit
import Firebase
import FirebaseAuth
import PDFKit
import WebKit


class HomeCollectionViewController: UICollectionViewController{

    @IBOutlet var collView: UICollectionView!

    
    var docsUrl = [URL]()
    var filteredData:[URL]!
    
    //    let url: URL
    override func viewDidLoad() {
        super.viewDidLoad()
    

        
      
        
//        searchBar.delegate = self
        self.docsUrl = getDocsUrl()!
        self.filteredData  = docsUrl

    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return docsUrl.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if let fileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? FileCollectionViewCell {
            
            fileCell.configure(fileName: docsUrl[indexPath.row].lastPathComponent, image: pdfThumbnail(url: docsUrl[indexPath.row])!)
            cell = fileCell
        }
        
        return cell
    }
    
    
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! FileCollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let document = docsUrl[indexPath.row]
        
        let pdfViewController = segue.destination as! PdfViewController
        pdfViewController.document = document
    }
    
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        displayWebView(withUrl: docsUrl[indexPath.row])
//        
//    }
    
//    func getDocsName(fileUrl: URL ) -> String{
//        return fileUrl.lastPathComponent
//    }
    
    // read the apps current document and get the url of all pdf files
    func getDocsUrl() -> [URL]? {
        
        // get the directory url of the app
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // get teh file names withing the url directory
        do {
            let directoryContent = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            
            let items = directoryContent.filter{ $0.pathExtension == "pdf" }
//            for item in items {
//                print(item.lastPathComponent)
//            }
            
            return items
            
        } catch{
            print("Couldn't open directory.\(error)")
        }
        
        return nil
    }

    
    
    //create a thumbnail for the pdf from a given url
    private func pdfThumbnail(url: URL, width: CGFloat = 240) -> UIImage? {
        guard let data = try? Data(contentsOf: url),
              let page = PDFDocument(data: data)?.page(at: 0) else {
                  return nil
              }
        let pageSize = page.bounds(for: .mediaBox)
        let pdfScale = width / pageSize.width
        
        let scale = UIScreen.main.scale * pdfScale
        let screenSize = CGSize(width: pageSize.width * scale,
                                height: pageSize.height * scale)
        return page.thumbnail(of: screenSize, for: .mediaBox)
    }
    

}

