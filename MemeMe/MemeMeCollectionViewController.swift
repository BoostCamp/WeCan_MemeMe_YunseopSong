//
//  MemeMeCollectionViewController.swift
//  MemeMe
//
//  Created by mac on 2017. 1. 27..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit


class MemeMeCollectionViewController: UICollectionViewController {
    // memes 배열 선언
    var memes: [Meme]!
    
    // Flow Layout
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes

        collectionView?.reloadData()
        super.viewWillAppear(true)

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeMeCollectionCell", for: indexPath) as! MemeMeCollectionViewCell
        
        let meme = self.memes[indexPath.row]
        cell.cellImage.image = meme.originalImage
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMeme", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMeme" {
            let MemeImageVC = segue.destination as! MemeImageViewController
            MemeImageVC.MemeIndex = sender as! Int
        }
    }
}
