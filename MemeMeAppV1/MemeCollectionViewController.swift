//
//  MemeCollectionViewController.swift
//  MemeMeAppV1
//
//  Created by Rosario A Robinson on 8/30/18.
//  Copyright © 2018 Rosario Robinson. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Layout
        let space:CGFloat = 3.0
        let widthDimension = (view.frame.size.width - (2 * space)) / 3.0
        let heightDimension = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //dequeue a reusable cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        let meme: Meme = memes[(indexPath as NSIndexPath).row]
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = (UIApplication.shared.delegate as! AppDelegate).memes[(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: "MemeDetailViewController", sender: memes)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemeDetailViewController" {
            let memeDetailViewController = segue.destination as! MemeDetailViewController
            memeDetailViewController.meme = sender as! Meme
        }
    }
}

