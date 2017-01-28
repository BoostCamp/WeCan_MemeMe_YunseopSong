//
//  MemeImageViewController.swift
//  MemeMe
//
//  Created by mac on 2017. 1. 28..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

class MemeImageViewController: UIViewController {
    
    var MemeIndex: Int!
    var memes: [Meme]!

    @IBOutlet weak var MemeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        MemeImageView.image = memes[MemeIndex].memedImage
    }

    @IBAction func editMeme(_ sender: UIBarButtonItem) {
    }

}
