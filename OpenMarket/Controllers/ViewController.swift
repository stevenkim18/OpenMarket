//
//  ViewController.swift
//  OpenMarket
//
//  Created by steven on 9/6/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var goodsCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var goods: [GoodsBriefInfomation] = []
    var lastLoadedPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goodsCollectionView.dataSource = self
        goodsCollectionView.delegate = self
//        goodsCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
        goodsCollectionView.register(ListCollectionViewCell.nib(), forCellWithReuseIdentifier: "listCollectionViewCell")
        // 초기 데이터 로딩
        fetchFirstPageData()
    }
    
    func fetchFirstPageData() {
        loadingView.startAnimating()
        NetworkManager.shared.request(EndPoint.readList(lastLoadedPage)) { [weak self] result in
            switch result {
            case .success(let data):
                if let goodsList = JsonParser.shared.decode(with: data, by: GoodsList.self) {
                    self?.goods.append(contentsOf: goodsList.items)
                    DispatchQueue.main.async {
                        self?.goodsCollectionView.reloadData()
                        self?.loadingView.stopAnimating()
                        self?.loadingView.isHidden = true
                    }
                    print("성공")
                }
            case .failure(let error):
                print("실패")
                break
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier,
                                                            for: indexPath) as? ListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: goods[indexPath.item])
        return cell
    }
    
}
