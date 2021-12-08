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
import CRRefresh


class HomeCollectionViewController: UICollectionViewController, UISearchBarDelegate{


    // two variables to store data. One is
    // used to retain original data, when the user
    // searches
    var documentListUrl = [URL]()
    var documentListUrlCopy:[URL]!
    


    
    //    let url: URL
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.fetchFileData()

        
        // use CRRefresh pod to add a pull-to-refresh
        // functionality
        collectionView.cr.addHeadRefresh(animator: FastAnimator()) {
            self.fetchFileData()
            self.collectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.collectionView.cr.endHeaderRefresh()
            }
        }
        collectionView.cr.beginHeaderRefresh()
    }
    

    // get pdf file urls from apps document folder
    private func fetchFileData(){
//        self.documentListUrl.removeAll()
//        self.documentListUrlCopy.removeAll()
        self.documentListUrl = getDocsUrl()!
        self.documentListUrlCopy  = documentListUrl
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documentListUrl.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        // set the custom cell
        if let fileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? FileCollectionViewCell {
            
            fileCell.configure(fileName: documentListUrl[indexPath.row].lastPathComponent, image: pdfThumbnail(url: documentListUrl[indexPath.row])!)
            cell = fileCell
        }
        
        return cell
    }
    
    //add a search bar to the collection view
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                                   withReuseIdentifier: "SearchBar", for: indexPath)
        
        return searchView
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.documentListUrl.removeAll()
        
        for item in self.documentListUrlCopy {
            if item.lastPathComponent.lowercased().contains(searchBar.text!.lowercased()){
                self.documentListUrl.append(item)
            }
        }
        
        if(searchBar.text!.isEmpty){
            self.documentListUrl = self.documentListUrlCopy
        }
        
        self.collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.documentListUrl = self.documentListUrlCopy
        searchBar.resignFirstResponder()
        self.collectionView.reloadData()
    }

    
    // when a cell is clicked, open the underlying pdf in a new view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! FileCollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let document = documentListUrl[indexPath.row]
        
        let pdfViewController = segue.destination as! PdfViewController
        pdfViewController.document = document
    }
    
    
    
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
            // sort the files by their name and return
            let sortedItems = items.sorted(by: { $0.lastPathComponent < $1.lastPathComponent})
            
            return sortedItems
            
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

