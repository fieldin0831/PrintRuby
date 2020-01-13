//
//  ShowRubyViewController.swift
//  PrintRuby
//
//  Created by Yuki Hatanaka on 2020/01/12.
//  Copyright © 2020 fieldin0831. All rights reserved.
//

import UIKit

/// ルビ表示画面ViewControllerクラス
class ShowRubyViewController: BaseViewController {

    @IBOutlet weak var sourceStringTextView: CustomTextView!
    @IBOutlet weak var destinationStringTextView: CustomTextView!
    @IBOutlet weak var speakButton: CustomButton!
    
    /// Viewモデル
    let viewModel: ShowRubyViewModel = ShowRubyViewModel()
    
    
    // MARK: - override function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初期化
        self.initViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.viewModel.stopSpeaking()
    }
    
    override func setViewData(_ viewData: BaseViewData) {
        // ルビ表示画面データならそれを設定
        if viewData is ShowRubyViewData {
            self.viewModel.setViewData(viewData as! ShowRubyViewData)
        }
    }
    
    
    // MARK: - private function
    
    /// 初期化
    private func initViewController() {
        // Viewモデル初期化
        self.viewModel.initViewModel()
        
        // 表示テキスト設定
        self.sourceStringTextView.text = self.viewModel.viewData.sourceString
        self.destinationStringTextView.text = self.viewModel.viewData.destinationString
        
        // 読み上げボタン状態更新
        self.updateSpeakButtonState()
    }
    
    /// 読み上げボタン状態更新
    private func updateSpeakButtonState() {
        // 読み上げ状態判定
        if self.viewModel.isSpeaking {
            // 読み上げ中なら停止ボタン
            self.speakButton.setTitle("■", for: .normal)
            self.speakButton.setImage(nil, for: .normal)
        }
        else {
            // 停止中なら読み上げボタン
            self.speakButton.setTitle("", for: .normal)
            self.speakButton.setImage(R.image.speak(), for: .normal)
        }
    }
    
    
    // MARK: - IBAction
    
    /// 読み上げボタンタップアクション
    @IBAction func touchUpInsideSpeakButton(_ sender: UIButton) {
        // 読み上げ状態判定
        if self.viewModel.isSpeaking {
            // 読み上げ中なら停止させる
            self.viewModel.stopSpeaking()
            self.updateSpeakButtonState()
        }
        else {
            // 停止中なら読み上げ開始する
            self.viewModel.speak(text: viewModel.viewData.destinationString) { [weak self] in
                self?.updateSpeakButtonState()
            }
            self.updateSpeakButtonState()
        }
    }
}
