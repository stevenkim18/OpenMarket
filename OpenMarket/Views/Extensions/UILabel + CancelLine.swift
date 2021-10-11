//
//  UILabel + CancelLine.swift
//  OpenMarket
//
//  Created by steven on 10/4/21.
//

import UIKit.UILabel

extension UILabel {
    func drawCancelLine() {
        let attributeString = NSMutableAttributedString(string: self.text!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSRange(location: 0,
                                                    length: self.text?.count ?? 0))
        self.attributedText = attributeString
    }
    
    func removeCancelLine() {
        let attributeString = NSMutableAttributedString(string: self.text!)
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle,
                                        range: NSRange(location: 0,
                                                       length: self.text?.count ?? 0))
        self.attributedText = attributeString
    }
}
