//
//  UIButton.swift
//  PrintRuby
//
//  Created by Yuki Hatanaka on 2020/01/13.
//  Copyright © 2020 fieldin0831. All rights reserved.
//

import UIKit

extension UIButton {
    
    override open var isEnabled: Bool {
        didSet {
            /// 非活性時、半透明にして明確にする
            self.alpha = (isEnabled ? 1.0 : 0.5)
        }
    }
    
    // ボタン連打制御(delayで指定した時間の間タップ不可にする(秒))
    func afterEnabled(delay: Double) {
        isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: { [weak self] () in
            self?.isUserInteractionEnabled = true
        })
    }
}

