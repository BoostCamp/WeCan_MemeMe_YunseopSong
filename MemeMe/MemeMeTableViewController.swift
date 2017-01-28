//
//  MemeMeTableViewController.swift
//  MemeMe
//
//  Created by mac on 2017. 1. 27..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

class MemeMeTableViewController: UITableViewController {
    // memes 배열 선언
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        // appDelegate에 저장된 memes를 가져오기
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes

        tableView.reloadData()
        super.viewWillAppear(true)
    }
    
    // table cell swipe 기능을 통해 삭제와 공유 기능을 추가
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        // 삭제 버튼
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.remove(at: editActionsForRowAt.row)
            self.memes.remove(at: editActionsForRowAt.row)
            self.tableView.reloadData()
            
        }
        delete.backgroundColor = .red
        
        // 공유 버튼
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            
            let memedImage = self.memes[editActionsForRowAt.row].memedImage
            
            let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            
            self.present(activityVC, animated: true, completion: nil)
        }
        share.backgroundColor = .blue
        
        return [share, delete]
    }
    

    // 테이블 뷰 섹션 수 설정
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // 테이블 뷰 셀 수 설정
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    // 테이블 뷰 셀 설정
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeMeTableViewCell") as! MemeMeTableViewCell
        
        let meme = self.memes[indexPath.row]
        cell.cellLabel.text = "\(meme.topText!) ... \(meme.bottomText!)"
        cell.cellImage.image = meme.originalImage
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        
        return cell

    }
    
    // 테이블 뷰 셀 선택 이벤트 핸들러
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // showMeme Segue 호출
        performSegue(withIdentifier: "showMeme", sender: indexPath.row)
    }
    
    // segue에 Meme index 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMeme" {
            let MemeImageVC = segue.destination as! MemeImageViewController
            MemeImageVC.MemeIndex = sender as! Int
        }
    }
    
}
