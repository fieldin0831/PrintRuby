# PrintRuby

## 概要
コーディング課題用に作成したiOSアプリです。
入力した文字列を平仮名に変換して表示します。

平仮名への変換はgooラボのひらがな化APIを使用しています。
https://labs.goo.ne.jp/api/jp/hiragana-translation/

## システム要件
- OS : iOS 12.0 以上

## 開発環境
- OS : macOS 10.15.2<br>
- Xcode : 10.2(Swift5)

## 使用OSS
- Alamofire
- ReachabilitySwift
- R.swift
- SVProgressHUD

## 画面機能
- 文字入力画面<br>
平仮名に変換する文字列を入力してひらがな化APIを呼びます。<br>
変換に成功するとルビ表示画面に遷移します。<br>
※変換に成功した文字列は一覧に表示され、項目タップをタップすることで再度同じ内容を表示することが可能です。(一覧はアプリ再起動時に全てクリアされます)
- ルビ表示画面<br>
平仮名に変換する前の後の文字列を表示します。
スピーカーボタンをタップすることで変換後文字列を読み上げます。

## フォルダ構成
アプリケーション設計としてはMVCを採用しているため、下記1.〜3がそれぞれ対応しています。
1. ViewModel
1. ViewController
1. View
1. API<br>
ひらがな化APIを呼ぶための通信関連処理
1. Common<br>
カスタムUI等

## 開発期間
- 約3日間 (機能及びUI検討含む)