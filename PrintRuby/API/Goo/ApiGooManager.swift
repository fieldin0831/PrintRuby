//
//  APIGooManager.swift
//  PrintRuby
//
//  Created by Yuki Hatanaka on 2020/01/13.
//  Copyright © 2020 fieldin0831. All rights reserved.
//

import Foundation
import Alamofire
import Reachability

/// Goo向けAPI管理クラス
class ApiGooManager: NSObject {
    
    /// URL
    let API_SERVER_URL = "https://labs.goo.ne.jp/api/"
    /// HTTPステータス有効(成功)範囲
    let VALIDATE_STATUS = 200..<400
    
    /// API結果種別
    enum APIResultType: Error {
        case success            // なし（正常）
        case disconnect         // ネットワーク利用不可
        case badRequest         // リクエストエラー
        case badResponse        // レスポンスエラー
        case timeout            // タイムアウト
        case invalidURL         // URL不正
        case elseError          // その他エラー
    }
    
    static let singleton = ApiGooManager() // シングルトン・インタンス
    
    
    // MARK: - internal function
    
    /// APIリクエスト共通メソッド
    ///
    /// - Parameters:
    ///   - endPoint: APIエンドポイント
    ///   - method:   APIメソッド
    ///   - reqeust: 要求クラス
    ///   - success: 正常時実行
    ///   - failure: 異常時実行
    func request<Body>(endPoint: String,
                       method: HTTPMethod,
                       reqeust: Request,
                       success: @escaping (_ response: Response<Body>, _ statusCode: Int) -> (),
                       failure: @escaping (_ error: APIResultType, _ statusCode: Int, _ message: String) -> ()) {
        print("start request")
        
        // 接続確認
        if !isConnected() {
            print("connection error")
            failure(.disconnect, 0, R.string.localizable.e_00_0001())
            return
        }
        
        // リクエストJsonを作成
        guard reqeust.toData() != nil else {
            print("convert request to json error")
            failure(.badRequest, 0, R.string.localizable.e_00_0002())
            return
        }
        
        // URL作成
        let url = API_SERVER_URL + endPoint
        print("URL: \(url)")
        
        let request = Alamofire.request(url,
                                        method: method,
                                        parameters: reqeust.toDict(),
                                        encoding: (method == .get) ? URLEncoding.default : JSONEncoding.default,
                                        headers: ["Content-Type":"application/json"]).validate(statusCode: VALIDATE_STATUS)
        
        request.responseData(completionHandler: { (response) in
            switch (response.result) {
            // 通信ステータス:OK
            case .success:
                // Json文字列を出力
                let jsonString: String = String(data: response.data!, encoding: .utf8)!
                print("Response:\(jsonString)")
                
                // Json解析
                if let responseData = Response<Body>.jsonDecode(with: response.data) {
                    success(responseData, response.response?.statusCode ?? 0)
                } else {
                    print("convert response to json error")
                    failure(.badResponse, response.response?.statusCode ?? 0, R.string.localizable.e_00_0003())
                }
                break
                
            // 通信ステータス:NG
            case .failure(let error):
                // レスポンスからメッセージを取り出す
                var message: String = R.string.localizable.e_00_0007()
                do {
                    // パースする
                    let jsonInfo = try JSONSerialization.jsonObject(with: response.data!) as! [String:Any]
                    if let error = jsonInfo["error"] as? [String:Any] {
                        if let errorMessage = error["message"] as? String {
                            message = errorMessage
                        }
                    }
                }
                catch {
                }
                
                // タイムアウトorキャンセル
                if (error._code == NSURLErrorTimedOut || error._code == NSURLErrorCancelled) {
                    print("timeout error")
                    failure(.timeout, response.response?.statusCode ?? 0, R.string.localizable.e_00_0004())
                }
                else {
                    // その他エラー
                    switch response.response?.statusCode {
                    case 404:   // 該当ページなし
                        print("invalidURL error")
                        failure(.invalidURL, response.response?.statusCode ?? 0, R.string.localizable.e_00_0006())
                    default:
                        failure(.elseError, response.response?.statusCode ?? 0, message)
                    }
                }
                break
            }
        })
    }
    
    // MARK: - private function
    
    /// 接続状態確認
    ///
    /// - Returns: 接続中の場合はtrueを返却する。
    private func isConnected() -> Bool {
        let reachability = try! Reachability()
        let connection: Reachability.Connection = reachability.connection
        
        switch connection {
        // セルラー
        case .cellular:
            return true
        // Wi-Fi
        case .wifi:
            return true
        // 接続なし
        case .unavailable:
            return false
        // 接続なし
        case .none:
            return false
        }
    }
}


// MARK: - リクエストクラス

protocol Request: Codable {
    /// JSON-Dictionaryを返却
    ///
    /// - Returns: JSON-Dictionary
    func toDict() -> [String:Any]?
    
    /// JSON-Dataを返却
    ///
    /// - Returns: JSON-Data
    func toData() -> Data?
    
    /// アプリケーションIDを返却
    ///
    /// - Returns: アプリケーションID
    func getAppId() -> String
}

extension Request {
    /// JSON-Dictionaryを返却
    ///
    /// - Returns: JSON-Dictionary
    func toDict() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: toData()!, options: .allowFragments) as? [String:Any]
        } catch (let error) {
            print("\(error)")
            return nil
        }
    }
    
    /// JSON-Dataを返却
    ///
    /// - Returns: JSON-Data
    func toData() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch (let error) {
            print("\(error)")
            return nil
        }
    }
    
    /// アプリケーションIDを返却
    ///
    /// - Returns: アプリケーションID
    func getAppId() -> String {
        return "5be7007c70b026810ab24b69530345e924466086520efd39a1602bd15fca4773"
    }
}


//MARK: - レスポンスクラス

/// API応答クラス
class Response<Body: Codable>: NSObject, Codable {
    /// ボディ
    var body: Body?
    
    /// DataをJson解析する
    ///
    /// - Parameter data: データ
    /// - Returns: API応答クラス
    static func jsonDecode(with data: Data?) -> Response<Body>? {
        do {
            let data: Body! = try JSONDecoder().decode(Body.self, from: data!)
            let body = Response<Body>()
            body.body = data
            return body
        } catch (let error) {
            print("\(error)")
            return nil
        }
    }
}
