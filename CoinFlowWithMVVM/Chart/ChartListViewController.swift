//
//  ChartListViewController.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/03.
//

import UIKit

typealias CoinInfo = (key: CoinType, value: Coin)

class ChartListViewController: UIViewController {

    @IBOutlet weak var chartCollectionView: UICollectionView!
    @IBOutlet weak var chartTableView: UITableView!
    @IBOutlet weak var chartTableViewHeight: NSLayoutConstraint!

    var coinInfoList: [CoinInfo] = [] {
        didSet {
            // data 세팅이 되었을 때 무엇을 해야 하는가?
            // -> 테이블뷰 리로드 시키기
            DispatchQueue.main.async {
                self.chartTableView.reloadData()
                self.adjustTableViewHeight()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.requestCoinList { result in

            switch result {
            case .success(let coins):
                // CoinType.allCases + coins
                // => [(BTC, coin), (ETH, coin)]
                let tuples = zip(CoinType.allCases, coins).map { (key: $0, value: $1) }
                self.coinInfoList = tuples
                print("코인리스트 --> \(coins.count), 첫번째: \(coins.first)")
            case .failure(let error):
                print("코인리스트 에러 --> \(error.localizedDescription)")
            }
        }
        
//        NetworkManager.requestCoinChartData { result in
//
//            switch result {
//            case .success(let coinChartDatas):
//                print("차트데이터 --> \(coinChartDatas.count)")
//            case .failure(let error):
//                print("차트데이터 에러 --> \(error.localizedDescription)")
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        adjustTableViewHeight()
    }
}

// MARK: - Private Method
extension ChartListViewController {
    
    private func adjustTableViewHeight() {
        chartTableViewHeight.constant = chartTableView.contentSize.height
    }
    
    private func showDetail(coinInfo: CoinInfo) {
        let storyboard = UIStoryboard(name: "Chart", bundle: .main)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "ChartDetailViewController") as? ChartDetailViewController {
            detailVC.coinInfo = coinInfo
            navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
}

// MARK: - CollectionView
extension ChartListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChartCardCell", for: indexPath) as? ChartCardCell
        else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }

}

extension ChartListViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.bounds.width - 20 * 2 - 15
        let height: CGFloat = 200
        
        return CGSize(width: width, height: height)
        
    }
    
}

class ChartCardCell: UICollectionViewCell {
    
}

// MARK: - TableView
extension ChartListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinInfoList.count
//        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartListCell", for: indexPath) as? ChartListCell else {
            return UITableViewCell()
        }
        let coinInfo = coinInfoList[indexPath.row]
        cell.configCell(coinInfo)
        return cell
    }
    
    
}

extension ChartListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinInfo = coinInfoList[indexPath.row]
        showDetail(coinInfo: coinInfo)
    }
}
