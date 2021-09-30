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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImageView.image = nil
        self.priceLabel.textColor = UIColor.lightGray
        self.priceLabel.removeCancelLine()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ListCollectionViewCell", bundle: nil)
    }
    
    func configure(with goods: GoodsBriefInfomation) {
        self.thumbnailImageView.loadImage(with: goods.thumbnails.first)
        self.titleLabel.text = goods.title
        self.stockLabel.text = goods.stockText
        self.priceLabel.text = goods.priceText
        setPriceLabel(by: goods)
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
                                        range: NSRange(location: 0, length: self.text?.count ?? 0))
        self.attributedText = attributeString
    }
}

extension UIImageView {
    func loadImage(with url: String?) {
        guard let url = URL(string: url ?? "") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
