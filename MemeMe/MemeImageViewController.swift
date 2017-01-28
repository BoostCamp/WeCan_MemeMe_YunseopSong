//
//  MemeImageViewController.swift
//  MemeMe
//
//  Created by mac on 2017. 1. 28..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

class MemeImageViewController: UIViewController {
    
    // segue sender로 넘어온 Meme Index
    var MemeIndex: Int!
    var memes: [Meme]!

    @IBOutlet weak var MemeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Image View에 Meme 이미지 설정
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        MemeImageView.image = memes[MemeIndex].memedImage
    }

}
