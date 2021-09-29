//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by steven on 9/29/21.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    static let identifier = "listCollectionViewCell"
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "ListCollectionViewCell", bundle: nil)
    }
    
    func configure(with goods: GoodsBriefInfomation) {
        self.thumbnailImageView.image = UIImage(systemName: "photo")
        self.titleLabel.text = goods.title
        self.stockLabel.text = "재고: \(goods.stock)"
        self.discountedPriceLabel.text = "\(goods.discountedPrice)"
        self.priceLabel.text = "\(goods.price)"
    }

}
