//
//  NoteCollectionViewCell.swift
//  Note
//
//  Created by 1okmon on 01.02.2023.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var BodyLabel: UILabel!
    override func awakeFromNib() {
        //self.layer.masksToBounds = true
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.black.cgColor
        
        super.awakeFromNib()
    }
}
