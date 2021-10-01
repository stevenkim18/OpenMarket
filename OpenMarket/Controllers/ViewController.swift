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
    var isFetching: Bool = false
    
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
//        let firstIndexPath = 20 * (self.lastLoadedPage - 1)
        
        if isFetching { return }
        isFetching = true
        NetworkManager.shared.request(EndPoint.readList(lastLoadedPage)) { [weak self] result in
            switch result {
            case .success(let data):
                if let goodsList = JsonParser.shared.decode(with: data, by: GoodsList.self),
                   goodsList.items.count != 0 {
                    self?.goods.append(contentsOf: goodsList.items)
                    DispatchQueue.main.async {
                        self?.goodsCollectionView.reloadData()
//                        self?.goodsCollectionView.performBatchUpdates {
//                            let indexPaths = (firstIndexPath..<(firstIndexPath + 20)).map { IndexPath(item: $0, section: 0) }
//                            self?.goodsCollectionView.insertItems(at: indexPaths)
//                        }
                        self?.loadingView.stopAnimating()
                        self?.loadingView.isHidden = true
                    }
                    self?.lastLoadedPage += 1
                }
            case .failure(_):
                print("실패")
                break
            }
            self?.isFetching = false
        }
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.item == self.goods.count - 1 {
                fetchgoodsData()
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.goods.count - 1 {
            fetchgoodsData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier,
                                                            for: indexPath) as? ListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.layer.drawBottomBorder()
        cell.configure(with: goods[indexPath.item])
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height / 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
