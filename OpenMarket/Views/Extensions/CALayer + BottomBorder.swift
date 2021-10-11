//
//  CALayer.swift
//  OpenMarket
//
//  Created by steven on 10/4/21.
//

import UIKit.UIView

extension CALayer {
    func drawBottomBorder() {
        let border = CALayer()
        border.frame = CGRect.init(x: 0,
                                   y: frame.height - 1.0,
                                   width: frame.width,
                                   height: 1.0)
        border.backgroundColor = UIColor.gray.cgColor
        self.addSublayer(border)
    }
}
