//
//  ShowRubyViewModel.swift
//  PrintRuby
//
//  Created by Yuki Hatanaka on 2020/01/13.
//  Copyright © 2020 fieldin0831. All rights reserved.
//

import Foundation

class ShowRubyViewData: BaseViewData {
    /// 変換元文字列
    var sourceString: String = ""
    /// 変換後文字列
    var destinationString: String = ""
}

class ShowRubyViewModel: NSObject {
    /// Viewデータ
    let viewData: ShowRubyViewData = ShowRubyViewData()
    
    
    /// Viewデータ設定
    ///
    /// - Parameters:
    ///   - viewData: 設定するviewデータ
    func setViewData(_ viewData: ShowRubyViewData) {
        self.viewData.sourceString = viewData.sourceString
        self.viewData.destinationString = viewData.destinationString
    }
}
