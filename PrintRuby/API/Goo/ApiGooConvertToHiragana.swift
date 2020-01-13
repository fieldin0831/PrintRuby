//
//  ApiGooConvertToHiragana.swift
//  PrintRuby
//
//  Created by Yuki Hatanaka on 2020/01/13.
//  Copyright © 2020 fieldin0831. All rights reserved.
//

import Foundation
import Alamofire

/// 平仮名変換リクエストクラス
class ApiGooConvertToHiraganaRequest: Request {
    private var app_id: String?
    private var output_type: String?
    var sentence: String?
    
    init() {
        app_id = self.getAppId()
        output_type = "hiragana"
    }
}

/// 平仮名変換レスポンスクラス
class ApiGooConvertToHiraganaResponse: Codable {
    var request_id: String?
    var output_type: String?
    var converted: String?
}

extension ApiGooManager {
    /// 平仮名変換
    ///
    /// - Parameters:
    ///   - success: 正常時処理
    ///   - failure: 異常時処理
    func convertToHiragana(request: ApiGooConvertToHiraganaRequest,
                           success: @escaping (_ response: Response<ApiGooConvertToHiraganaResponse>, _ statusCode: Int) -> (),
                           failure: @escaping (_ error: APIResultType, _ statusCode: Int, _ message: String) -> ()) {
        // APIリクエスト共通メソッド
        self.request(endPoint: "hiragana",
                     method: HTTPMethod.post,
                     reqeust: request,
                     success: success,
                     failure: failure)
    }
}

