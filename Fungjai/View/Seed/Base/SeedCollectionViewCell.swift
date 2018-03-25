//
//  SeedCollectionViewCell.swift
//  Fungjai
//
//  Created by BSD_MAC_Pro2 on 25/3/18.
//  Copyright © 2018 BSD_MAC_Pro2. All rights reserved.
//

import UIKit

class SeedCollectionViewCell: BaseCollectionViewCell {
    //MARK:- Field
    var seed : Seed?
    
    //MARK:- Constructor
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 3
        self.contentView.layer.borderWidth = 3
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.contentView.dropShadow(scale: true)
    }
    
    
    //MARK:- For Override
    func bind(){
        
    }
    
    final func bind(source:Seed){
        seed = source
        self.bind()
    }
}
