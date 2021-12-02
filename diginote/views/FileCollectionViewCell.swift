//
//  FileCollectionViewCell.swift
//  diginote
//
//  Created by Sayed Jahed Hussini on 11/21/21.
//

import UIKit

class FileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var fileImageView: UIImageView!
    
//    func configure(fileName: String){
//
//        fileNameLabel.text = fileName
//
////        fileImageView.image = UIImage(named: "collections-black-ios")
//    }
    
    func configure(fileName: String, image: UIImage){

        fileNameLabel.text = fileName
        fileImageView.image = image
//        if image != nil {
//            fileImageView.image = image
//        }
    }
}
