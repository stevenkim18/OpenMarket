//
//  TitleLabel.swift
//  OpenMarket
//
//  Created by steven on 10/5/21.
//

import UIKit

class TitleLabel: UILabel {

    override func drawText(in rect: CGRect) {
        super.drawText(in: .init(origin: .zero,
                                 size: textRect(forBounds: rect,
                                                limitedToNumberOfLines: numberOfLines).size))
    }

}
