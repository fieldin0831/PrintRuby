//
//  BaseViewController.swift
//  PrintRuby
//
//  Created by Yuki Hatanaka on 2020/01/12.
//  Copyright © 2020 fieldin0831. All rights reserved.
//

import UIKit

/// ViewController基底クラス
class BaseViewController: UIViewController {
    
    /// キーボード表示状態
    var isShowKeybord = false
    /// キーボードセーフエリア(このエリアにキーボードが被らないようにする)
    private var keyboardSafeArea: CGRect? = nil
    
    
    // MARK: - override function
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // --------------------------------------------------
        // 通知受信設定
        // --------------------------------------------------
        
        // キーボード表示直前通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        // キーボード非表示直前通知
        NotificationCenter.default.addObserver(self,
                                                selector: #selector(keyboardWillHide(notification:)),
                                                name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // キーボード表示中なら閉じる
        if self.isShowKeybord {
            self.view.endEditing(true)
            self.isShowKeybord = false
        }
        
        // 通知設定削除
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - internal function
    
    /// Viewを元にキーボードセーフエリア設定
    ///
    /// - Parameters:
    ///   - safeAreaView: 設定元View
    func setKeyboardSafeAreaWithView(_ safeAreaView: UIView) {
        keyboardSafeArea = safeAreaView.convert(safeAreaView.bounds, to: self.view)
    }
    
    /// Viewデータ設定
    ///
    /// - Parameters:
    ///   - viewData: 設定するviewデータ
    func setViewData(_ viewData: BaseViewData) {
        
    }
    
    
    // MARK: - notification function
    
    /// キーボード表示直前通知
    @objc func keyboardWillShow(notification: Notification) {
        
        // キーボード表示状態設定
        self.isShowKeybord = true
        
        // キーボードセーフエリア未指定なら終了
        guard self.keyboardSafeArea != nil else {
            return
        }
        
        // --------------------------------------------------
        // 通知情報取得
        // --------------------------------------------------
        
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return
        }
        guard let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        guard let duration:TimeInterval = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        // --------------------------------------------------
        // キーボードがキーボードセーフエリアに被る範囲を計算
        // --------------------------------------------------
        
        let keyboardArea:CGRect = keyboardInfo.cgRectValue
        let hideY = (self.view.frame.height - keyboardArea.height) - keyboardSafeArea!.maxY
        
        // キーボードがキーボードセーフエリアに被る場合、viewをその分上に移動させる
        if hideY < 0.0 {
            UIView.animate(withDuration: duration, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: hideY)
            })
        }
    }
    
    /// キーボード非表示直前通知
    @objc func keyboardWillHide(notification: Notification) {
        
        // キーボード表示状態設定
        self.isShowKeybord = false
        
        // キーボードセーフエリア未指定なら終了
        guard self.keyboardSafeArea != nil else {
            return
        }
        
        // --------------------------------------------------
        // 通知情報取得
        // --------------------------------------------------
        
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return
        }
        guard let duration:TimeInterval = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        // 移動量を元に戻す
        UIView.animate(withDuration: duration, animations: { () in
            self.view.transform = CGAffineTransform.identity
        })
        
        // 木ーボードセーフエリア初期化
        self.keyboardSafeArea = nil
    }
}
