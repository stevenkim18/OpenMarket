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
        setUpCollectionView()
        loadingView.startAnimating()
        fetchgoodsData()
    }
    
    private func setUpCollectionView() {
        goodsCollectionView.dataSource = self
        goodsCollectionView.delegate = self
        goodsCollectionView.prefetchDataSource = self
        goodsCollectionView.register(ListCollectionViewCell.nib(), forCellWithReuseIdentifier: "listCollectionViewCell")
    }
    
    func fetchgoodsData() {
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
                    self?.lastLoadedPage += 1
                    print("성공")
                }
            case .failure(let error):
                print("실패")
                break
            }
        }
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("prefetchItemsAt \(indexPaths)")
        for indexPath in indexPaths {
            if indexPath.item == self.goods.count - 1 {
                fetchgoodsData()
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

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height / 8)
    }
}
