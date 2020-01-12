//
//  CustomButton.swift
//  PrintRuby
//
//  Created by Yuki Hatanaka on 2020/01/12.
//  Copyright © 2020 fieldin0831. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton {
    
    // 角丸の半径(0で四角形)
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = (cornerRadius > 0)
        }
    }
    
    // 枠色
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    // 枠幅
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
}
