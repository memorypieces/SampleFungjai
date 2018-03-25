//
//  TrackCollectionViewCell.swift
//  Fungjai
//
//  Created by BSD_MAC_Pro2 on 25/3/18.
//  Copyright © 2018 BSD_MAC_Pro2. All rights reserved.
//

import UIKit
import AlamofireImage

class TrackCollectionViewCell: SeedCollectionViewCell {
    
    //MARK:- Constant
    static var cellHeight : CGFloat {
        return cellWidth * (9/24)
    }
    
    static var cellWidth : CGFloat {
        return SCREEN_WIDTH * 0.8
    }
    
    static let identifier : String = "TrackCollectionViewCell"
    
    //MARK:- Controls
    var coverImageView = UIImageView()
    var titleLabel = UILabel()
    
    
    //MARK:- Constructor
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.coverImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.coverImageView)
        
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.titleLabel.textColor = UIColor.darkGray
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.contentView.addSubview(self.titleLabel)
        
        self.makeConstraints()
    }
    
    //MARK:- Override Func
    override func bind() {
        super.bind()
        
        if let seed = super.seed{
            if let title = seed.name{
                self.titleLabel.text = title
            }else{
                self.titleLabel.text = "-"
            }
            
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
            }
            else{
                self.coverImageView.image = nil
                self.coverImageView.backgroundColor = UIColor.lightGray
            }
        }else{
            self.titleLabel.text = "-"
            self.coverImageView.image = nil
            self.coverImageView.backgroundColor = UIColor.lightGray
        }
        

        
    }
    
    
    
    //MARK:- Private func
    private func makeConstraints(){
        let coverHeight = TrackCollectionViewCell.cellHeight * 0.8
        let marginLeft = TrackCollectionViewCell.cellWidth * 0.05
        
        self.coverImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(marginLeft)
            make.centerY.equalToSuperview()
            make.width.equalTo(coverHeight)
            make.height.equalTo(coverHeight)
        }

        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.coverImageView.snp.top)
            make.left.equalTo(self.coverImageView.snp.right).offset(20)
            make.right.equalToSuperview().offset(-10)
        }
    }
}
