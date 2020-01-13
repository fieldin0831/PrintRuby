//
//  InputStringViewController.swift
//  PrintRuby
//
//  Created by Yuki Hatanaka on 2020/01/12.
//  Copyright © 2020 fieldin0831. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 文字入力画面ViewControllerクラス
class InputStringViewController: BaseViewController {

    @IBOutlet weak var stringTableView: UITableView!
    @IBOutlet weak var inputStringTextView: CustomTextView!
    @IBOutlet weak var stringCountLabel: UILabel!
    @IBOutlet weak var convertStringButton: CustomButton!
    @IBOutlet weak var inputAreaView: UIView!
    
    /// Viewモデル
    let viewModel: InputStringViewModel = InputStringViewModel()
    /// 最大入力文字数
    let maxInputStringCount: Int = 100
    /// 入力文字数ラベルフォーマット
    let stringCountFormat: String = "%d / %d"
    /// 活性ボタン色
    let enabledButtonColor: UIColor = UIColor(red: 0.0, green: 150.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    /// 非活性ボタン色
    let disabledButtonColor: UIColor = UIColor.lightGray
    
    
    // MARK: - override function
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初期化
        self.initViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 文字入力状態 & ボタン状態クリア
        self.inputStringTextView.text = ""
        self.updateInputStringState()
        self.updateConvertStringButtonState()
        
        // 入力文字一覧更新し、一番下の行を表示する
        if self.viewModel.viewData.inputStringList.count != 0 {
            self.stringTableView.reloadData()
            self.stringTableView.scrollToRow(at: IndexPath(row: self.viewModel.viewData.inputStringList.count - 1, section: 0),
                                             at: .bottom,
                                             animated: false)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // キーボードを閉じる
        if self.isShowKeybord {
            self.view.endEditing(true)
        }
    }

    
    // MARK: - private function
    
    /// 初期化
    private func initViewController() {
        // インジケータ表示タイプ設定
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultMaskType(.black)
        
        // Viewモデル初期化
        self.viewModel.initViewModel()
        
        // デリゲート設定
        self.inputStringTextView.delegate = self
        self.stringTableView.dataSource = self
        self.stringTableView.delegate = self
        
        // 文字入力状態 & ボタン状態設定
        self.updateInputStringState()
        self.updateConvertStringButtonState()
        
        // 入力文字一覧更新
        self.stringTableView.reloadData()
    }
    
    /// 文字入力状態更新
    private func updateInputStringState() {
        // 入力文字数表示更新([入力文字数] / [最大入力文字数])
        self.stringCountLabel.text = String(format: self.stringCountFormat, self.inputStringTextView.text.count, self.maxInputStringCount)
    }
    
    /// 文字変換ボタン状態更新
    private func updateConvertStringButtonState() {
        // 入力文字数により状態を判定
        if self.inputStringTextView.text.count > 0 && self.inputStringTextView.text.count <= self.maxInputStringCount {
            // 1〜最大文字数なら活性
            self.convertStringButton.isEnabled = true
            self.convertStringButton.backgroundColor = self.enabledButtonColor
        }
        else {
            // 0文字 or 最大文字数超なら非活性
            self.convertStringButton.isEnabled = false
            self.convertStringButton.backgroundColor = self.disabledButtonColor
        }
    }
    
    /// ルビ表示画面に遷移する
    ///
    /// - Parameters:
    ///   - sourceString: 変換元文字列
    ///   - destinationString: 変換後文字列
    private func gotoShowRubyView(sourceString: String, destinationString: String) {
        if let viewController = R.storyboard.showRubyView.showRubyView() {
            let viewData = ShowRubyViewData()
            viewData.sourceString = sourceString
            viewData.destinationString = destinationString
            viewController.setViewData(viewData)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    // MARK: - IBAction
    
    /// Goボタンタップ
    @IBAction func touchUpInsideConvertStringButton(_ sender: UIButton) {
        // 連打制御
        sender.afterEnabled(delay: 0.2)
        
        // キーボードを閉じる
        self.view.endEditing(true)
        
        // インジケータ表示
        SVProgressHUD.show()
        
        // 変換処理実行
        self.viewModel.convertStringToRuby(sourceString: self.inputStringTextView.text) { [weak self] (result, message, ruby) in
            // インジケータ非表示
            SVProgressHUD.dismiss()
            
            guard let weakSelf = self else {
                return
            }
            
            // エラーならメッセージ表示して終了
            if result != .success {
                let alert: UIAlertController = UIAlertController(title: "", message:  message, preferredStyle:  UIAlertController.Style.alert)
                let okAction: UIAlertAction = UIAlertAction(title: R.string.localizable.oK(), style: UIAlertAction.Style.default)
                alert.addAction(okAction)
                weakSelf.present(alert, animated: true, completion: nil)
                return
            }
            
            // 変換結果を入力文字一覧に追加
            weakSelf.viewModel.addInputStringListData(sourceString: weakSelf.inputStringTextView.text,
                                                      destinationString: ruby)
            
            // ルビ表示画面に遷移する
            weakSelf.gotoShowRubyView(sourceString: weakSelf.inputStringTextView.text,
                                      destinationString: ruby)
        }
    }
}


// MARK: - UITextViewDelegate

extension InputStringViewController: UITextViewDelegate {
    /// テキスト編集開始前通知
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // キーボードセーフエリア設定
        self.setKeyboardSafeAreaWithView(self.inputAreaView)
        return true
    }
    
    /// テキスト変更通知
    func textViewDidChange(_ textView: UITextView) {
        // テキスト入力状態及びボタン状態を更新する
        self.updateInputStringState()
        self.updateConvertStringButtonState()
    }
}


// MARK: - UITableViewDataSource

extension InputStringViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.viewData.inputStringList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.inputStringTableViewCell.identifier,
                                                 for: indexPath) as! InputStringTableViewCell
        
        cell.stringLabel.text = self.viewModel.viewData.inputStringList[indexPath.row].sourceString
        
        return cell
    }
}


// MARK: - UITableViewDataSource

extension InputStringViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // 対象の入力文字及びルビを渡してルビ表示画面に遷移する
        gotoShowRubyView(sourceString: self.viewModel.viewData.inputStringList[indexPath.row].sourceString,
                         destinationString: self.viewModel.viewData.inputStringList[indexPath.row].destinationString)
        return nil
    }
}
