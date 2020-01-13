//
//  ShowRubyViewModel.swift
//  PrintRuby
//
//  Created by Yuki Hatanaka on 2020/01/13.
//  Copyright © 2020 fieldin0831. All rights reserved.
//

import Foundation
import AVFoundation

/// ルビ表示画面データ
class ShowRubyViewData: BaseViewData {
    /// 変換元文字列
    var sourceString: String = ""
    /// 変換後文字列
    var destinationString: String = ""
}

/// ルビ表示画面モデル
class ShowRubyViewModel: NSObject {
    /// Viewデータ
    let viewData: ShowRubyViewData = ShowRubyViewData()
    /// AVSpeechSynthesizer
    let speechSynthesizer = AVSpeechSynthesizer()
    /// 読み上げ完了クロージャ保持用
    var speakingDidFinishHandler: (() -> Void)?
    /// 読み上げ状態
    var isSpeaking: Bool = false
    
    // MARK: - internal function
    
    /// Viewモデル初期化
    func initViewModel() {
        self.speechSynthesizer.delegate = self
    }
    
    /// Viewデータ設定
    ///
    /// - Parameters:
    ///   - viewData: 設定するviewデータ
    func setViewData(_ viewData: ShowRubyViewData) {
        self.viewData.sourceString = viewData.sourceString
        self.viewData.destinationString = viewData.destinationString
    }
    
    /// 読み上げ開始
    ///
    /// - Parameters:
    ///   - text: 読み上げるテキスト
    ///   - didFinish: 読み上げ完了クロージャ
    func speak(text: String, didFinish: @escaping () -> Void) {
        // 読み上げ停止
        self.stopSpeaking()
        
        // 状態更新
        self.isSpeaking = true
        self.speakingDidFinishHandler = didFinish
        
        // 日本語で読み上げ開始
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        self.speechSynthesizer.speak(utterance)
    }
    
    /// 読み上げ停止
    func stopSpeaking() {
        // 読み上げ中なら停止する
        if self.isSpeaking {
            self.speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        // 状態クリア
        self.isSpeaking = false
        self.speakingDidFinishHandler = nil
    }
}


// MARK: - AVSpeechSynthesizerDelegate function

extension ShowRubyViewModel: AVSpeechSynthesizerDelegate {
    
    /// 読み上げ完了通知
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // 状態クリア
        self.isSpeaking = false
        
        // 完了クロージャ呼び出し
        if self.speakingDidFinishHandler != nil {
            self.speakingDidFinishHandler!()
            self.speakingDidFinishHandler = nil
        }
    }
}
