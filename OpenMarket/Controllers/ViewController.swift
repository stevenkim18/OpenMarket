//
//  ViewController.swift
//  OpenMarket
//
//  Created by steven on 9/6/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var goodsCollectionView: UICollectionView!
    var goods: [GoodsBriefInfomation] = []
    var lastLoadedPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 초기 데이터 로딩
        NetworkManager.shared.request(EndPoint.readList(lastLoadedPage)) { result in
            switch result {
            case .success(let data):
                if let goodsList = JsonParser.shared.decode(with: data, by: GoodsList.self) {
                    self.goods.append(contentsOf: goodsList.items)
                    print("성공")
                }
            case .failure(let error):
                print("실패")
                break
            }
        }
        
        goodsCollectionView.dataSource = self
        goodsCollectionView.delegate = self
        
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
