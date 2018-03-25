//
//  ViewController.swift
//  Fungjai
//
//  Created by BSD_MAC_Pro2 on 24/3/18.
//  Copyright © 2018 BSD_MAC_Pro2. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController {
    
    //MARK:- Datasource
    var seeds : [Seed]?
    
    //MARK:- Control
    var collectionView : UICollectionView!
    
    //MARK:- Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCollection()
        self.makeConstraint()
        
        let loading = MBProgressHUD.showAdded(to: self.collectionView, animated: true)
        loading.alpha = 0.8
        SeedAPI.getSeeds { (dataRequest, error) in
            loading.hide(animated: true)
            if let seedArr = dataRequest, error == nil {
                self.seeds = seedArr
                self.collectionView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Private Func
    private func makeConstraint(){
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadCollection(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(TrackCollectionViewCell.self, forCellWithReuseIdentifier: TrackCollectionViewCell.identifier)
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)
        collectionView.register(AdsCollectionViewCell.self, forCellWithReuseIdentifier: AdsCollectionViewCell.identifier)
        
        collectionView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.view.addSubview(collectionView)
    }

}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : SeedCollectionViewCell!
        if let seeds = seeds {
            let seed = seeds[indexPath.row]
            if seed.isTrack {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCollectionViewCell.identifier, for: indexPath) as! SeedCollectionViewCell
            }else if seed.isVideo{
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for: indexPath) as! SeedCollectionViewCell
            }else if seed.isAds {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdsCollectionViewCell.identifier, for: indexPath) as! SeedCollectionViewCell
            }else{
                cell = SeedCollectionViewCell()
            }
            
            cell.bind(source: seed)
        }else{
            cell = SeedCollectionViewCell()
            cell.bind()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let seeds = self.seeds{
            return seeds.count
        }else{
            return 0
        }
    }
}

extension ViewController : UICollectionViewDelegate {
    
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{

        if let seeds = seeds {
            let seed = seeds[indexPath.row]
            if seed.isTrack {
                return CGSize(width: TrackCollectionViewCell.cellWidth, height: TrackCollectionViewCell.cellHeight)
            }else if seed.isVideo{
                return CGSize(width: VideoCollectionViewCell.cellWidth, height: VideoCollectionViewCell.cellHeight)
            }else if seed.isAds {
                return CGSize(width: AdsCollectionViewCell.cellWidth, height: AdsCollectionViewCell.cellHeight)
            }else{
                return CGSize(width: TrackCollectionViewCell.cellWidth, height: TrackCollectionViewCell.cellHeight)
            }
        }else{
            return CGSize(width: TrackCollectionViewCell.cellWidth, height: TrackCollectionViewCell.cellHeight)
        }
    }
}

