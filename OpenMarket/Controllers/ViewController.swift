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
        fetchFirstPageData()
    }
    
    private func setUpCollectionView() {
        goodsCollectionView.dataSource = self
        goodsCollectionView.delegate = self
        goodsCollectionView.register(ListCollectionViewCell.nib(), forCellWithReuseIdentifier: "listCollectionViewCell")
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

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height / 8)
    }
}
