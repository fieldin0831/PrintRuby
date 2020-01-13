//
//  InputStringViewModel.swift
//  PrintRuby
//
//  Created by Yuki Hatanaka on 2020/01/13.
//  Copyright © 2020 fieldin0831. All rights reserved.
//

import Foundation

/// 入力文字一覧データ
class InputStringListData: NSObject {
    /// 変換元文字列
    var sourceString: String = ""
    /// 変換後文字列
    var destinationString: String = ""
}

/// 文字入力画面データ
class InputStringViewData: BaseViewData {
    /// 入力文字一覧データ
    var inputStringList: [InputStringListData] = []
}

/// 文字入力画面モデル
class InputStringViewModel: NSObject {
    /// Viewデータ
    let viewData: InputStringViewData = InputStringViewData()
    
    
    // MARK: - internal function
    
    /// Viewモデル初期化
    func initViewModel() {

    }
    
    /// 指定文字列を平仮名に変換する
    ///
    /// - Parameters:
    ///   - sourceString: 変換元文字列
    ///   - completion: 結果を返却クロージャ
    func convertStringToRuby(sourceString: String,
                             completion: @escaping (_ result: Int, _ message: String, _ rubyString: String) -> Void) {
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1.0)
            DispatchQueue.main.async {
                completion(1, "", sourceString)
            }
        }
    }
    
    /// 入力文字一覧データ追加
    ///
    /// - Parameters:
    ///   - sourceString: 変換元文字列
    ///   - destinationString: 変換後文字列
    func addInputStringListData(sourceString: String, destinationString: String) {
        // データ作成
        let inputStringListData = InputStringListData()
        inputStringListData.sourceString = sourceString
        inputStringListData.destinationString = destinationString
        
        // データ追加
        self.viewData.inputStringList.append(inputStringListData)
    }
}
