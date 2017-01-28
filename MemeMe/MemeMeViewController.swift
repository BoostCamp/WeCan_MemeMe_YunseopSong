//
//  MemeMeViewController.swift
//  MemeMe
//
//  Created by mac on 2017. 1. 27..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // IBOutlet 선언
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var pickButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // 상태바 가리기
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        // 키보드 Notification 등록
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        // 키보드 Notification 해제
        unsubscribeFromKeyboardNotifications()
    }
    
    // 앨범으로부터 이미지 선택
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        imagePickerShow(.photoLibrary)
    }
    
    // 카메라로부터 이미지 캡쳐
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        imagePickerShow(.camera)
    }
    
    
    // 미미 공유 액션
    @IBAction func shareMeMe(_ sender: UIBarButtonItem) {
        
        // 미미 이미지 생성
        let memedImage = generateMemedImage()
        
//        let objectsToShare =
        // 액티비티 뷰 컨트롤러 생성
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // 액티비티 뷰 활성화
        self.present(activityVC, animated: true, completion: nil)
        
        // 액티비티 뷰 핸들러
        activityVC.completionWithItemsHandler = {(activityType: UIActivityType?, complete: Bool, returnedItems: [Any]?, error: Error?) in
            // complete되지 않으면 리턴
            guard complete else {
                return
            }
            
            // meme 생성
            let meme: Meme = Meme(topText: self.topText.text!, bottomText: self.bottomText.text!, originalImage: self.imagePickerView.image!, memedImage: memedImage)
            
            // appDelegate의 모델에 append
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.append(meme)
            
            // MemeMeViewController 내리기
            self.dismiss(animated: true, completion: nil)
            
        }

    }
    
    // 취소: MemeMeViewController 내리기
    @IBAction func cancelMeme(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveMeme(_ sender: Any) {
        let memedImage = generateMemedImage()

        let meme: Meme = Meme(topText: self.topText.text!, bottomText: self.bottomText.text!, originalImage: self.imagePickerView.image!, memedImage: memedImage)
        
        // appDelegate의 모델에 append
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
        // MemeMeViewController 내리기
        self.dismiss(animated: true, completion: nil)
    }
    
    // 초기 UI 적용
    func initUI() {
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -2.0]
        
        shareButton.isEnabled = false
        saveButton.isEnabled = false
        topText.delegate = self
        bottomText.delegate = self
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.center
        topText.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = NSTextAlignment.center
        bottomText.autocapitalizationType = UITextAutocapitalizationType.allCharacters
    }
    
    // imagePicker 띄우기
    // source: [.camera, .photoLibrary]
    func imagePickerShow(_ source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // imagePicker에서 이미지를 선택했을 때 이벤트 핸들러
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
            topText.text = "TOP"
            bottomText.text = "BOTTOM"
            shareButton.isEnabled = true
            saveButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    // textField 초기화
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    // textField 리턴키를 눌렀을 때 키보드 내리는 함수
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
        
    }
    
    // keybord가 올라올 때 이벤트 핸들러
    func keyboardWillShow(_ notification:Notification) {
        //keyboard 높이
        let keyboardHeight = getKeyboardHeight(notification)
        
        let bottom: Bool = bottomText.isEditing && bottomText.frame.maxY > keyboardHeight
        let top: Bool = topText.isEditing && topText.frame.maxY > keyboardHeight
        if bottom || top {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    // keyboard가 내려갈 때 이벤트 핸들러
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    // keyboard 높이 구하는 함수
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // Notification 등록
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    // Notification 해제
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // Meme 이미지 생성
    func generateMemedImage() -> UIImage {
        
        self.topToolBar?.isHidden = true
        self.bottomToolBar?.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.topToolBar?.isHidden = false
        self.bottomToolBar?.isHidden = false
        
        return memedImage
    }
}
