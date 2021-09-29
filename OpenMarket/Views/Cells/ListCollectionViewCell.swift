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
        thumbnailImageView.image = nil
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ListCollectionViewCell", bundle: nil)
    }
    
    func configure(with goods: GoodsBriefInfomation) {
        self.thumbnailImageView.loadImage(with: goods.thumbnails.first)
        self.titleLabel.text = goods.title
        self.stockLabel.text = "재고: \(goods.stock)"
        self.discountedPriceLabel.text = "\(goods.discountedPrice)"
        self.priceLabel.text = "\(goods.price)"
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
