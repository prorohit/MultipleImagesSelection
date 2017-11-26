//
//  ViewController.swift
//  MultipleImagePicker
//
//  Created by Rohit Singh on 11/26/17.
//  Copyright © 2017 Rohit Singh. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos


class ViewController: UIViewController {
    
    var arrOfImages = [UIImage]()

    @IBOutlet weak var btnMultipleImagePicker: UIButton!
    @IBOutlet weak var collectionViewMultipleImages: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuration()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func configuration () {
        self.collectionViewMultipleImages.delegate = self
        self.collectionViewMultipleImages.dataSource = self
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapBtnMultipleImagePicker(_ sender: UIButton) {
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 4
        
        weak var weakSelf = self
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            // Do something, cancel upload?
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            
            print(assets.count)
            for asset in assets {
                let image = self.getAssetThumbnail(asset: asset)
                self.arrOfImages.append(image)
                
            }
            DispatchQueue.main.async(execute: {
                weakSelf?.collectionViewMultipleImages.reloadData()
            })
            // User finished with these assets
        }, completion: nil)
    }
    
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrOfImages.count;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = cell.viewWithTag(100) as! UIImageView

        imageView.image = self.arrOfImages[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    
}
