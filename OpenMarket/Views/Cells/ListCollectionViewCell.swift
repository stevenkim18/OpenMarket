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
    var dataTask: URLSessionDataTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataTask?.cancel()
        self.thumbnailImageView.image = UIImage(systemName: "photo")
        self.stockLabel.textColor = UIColor.lightGray
        self.priceLabel.textColor = UIColor.lightGray
        self.priceLabel.removeCancelLine()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.titleLabel.sizeToFit()
//        self.titleLabel.layoutIfNeeded()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ListCollectionViewCell", bundle: nil)
    }
    
    func configure(with goods: GoodsBriefInfomation) {
        dataTask?.cancel()
        dataTask = self.thumbnailImageView.loadImage(with: goods.thumbnails.first)
        self.titleLabel.text = goods.title
        self.priceLabel.text = goods.priceText
        setStockLabel(by: goods)
        setPriceLabel(by: goods)
    }
    
    private func setStockLabel(by goods: GoodsBriefInfomation) {
        if goods.stock == 0 {
            self.stockLabel.textColor = UIColor.systemYellow
        }
        self.stockLabel.text = goods.stockText
    }
    
    private func setPriceLabel(by goods: GoodsBriefInfomation) {
        if goods.discountedPrice != nil {
            self.discountedPriceLabel.text = goods.discountedPriceText
            self.discountedPriceLabel.isHidden = false
            self.priceLabel.textColor = UIColor.red
            self.priceLabel.drawCancelLine()
        } else {
            self.discountedPriceLabel.isHidden = true
        }
    }

}
