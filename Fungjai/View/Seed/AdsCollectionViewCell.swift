//
//  AdsCollectionViewCell.swift
//  Fungjai
//
//  Created by BSD_MAC_Pro2 on 25/3/18.
//  Copyright © 2018 BSD_MAC_Pro2. All rights reserved.
//

import UIKit

class AdsCollectionViewCell: SeedCollectionViewCell {
    //MARK:- Constant
    static var cellHeight : CGFloat {
        return cellWidth * (9/24)
    }
    
    static var cellWidth : CGFloat {
        return SCREEN_WIDTH * 0.8
    }
    
    static let identifier : String = "AdsCollectionViewCell"
    
    //MARK:- Controls
    var coverImageView = UIImageView()
    
    
    //MARK:- Constructor
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.coverImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.coverImageView)
        
        self.makeConstraints()
    }
    
    //MARK:- Override Func
    override func bind() {
        super.bind()
        if let seed = super.seed{
            if let url = seed.coverUrl{
                self.coverImageView.af_setImage(withURL: url
                    , placeholderImage: nil
                    , filter: nil
                    , progress: nil
                    , progressQueue: DispatchQueue.init(label: "LoadImage")
                    , imageTransition: UIImageView.ImageTransition.crossDissolve(0.4)
                    , runImageTransitionIfCached: false
                    , completion: {completed in
                        if completed.error == nil {
                            self.coverImageView.backgroundColor = UIColor.clear
                        }else{
                            self.coverImageView.backgroundColor = UIColor.lightGray
                        }
                })
                
            }else{
                self.coverImageView.image = nil
                self.coverImageView.backgroundColor = UIColor.lightGray
            }
        }else{
            self.coverImageView.image = nil
            self.coverImageView.backgroundColor = UIColor.lightGray
        }
    }
    
    
    
    //MARK:- Private func
    private func makeConstraints(){
        self.coverImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.85)
        }
    }
}
