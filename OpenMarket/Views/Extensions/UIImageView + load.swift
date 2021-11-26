//
//  UIImageView + load.swift
//  OpenMarket
//
//  Created by steven on 10/4/21.
//

import UIKit.UIImageView

extension UIImageView {
    func loadImage(with url: String?) -> URLSessionDataTask? {
        guard let url = URL(string: url ?? "") else {
            return nil
        }
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.image = image
            }
        }
        dataTask.resume()
        return dataTask
    }
}
