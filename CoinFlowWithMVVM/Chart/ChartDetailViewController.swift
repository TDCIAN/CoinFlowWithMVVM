//
//  ChartDetailViewController.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/03.
//

import UIKit

class ChartDetailViewController: UIViewController {
    @IBOutlet weak var coinTypeLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    
    var coinInfo: CoinInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateCoinInfo(coinInfo)
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("--> 꽂힌 정보 확인 => 키: \(coinInfo.key), 밸류: \(coinInfo.value)")
    }

}

extension ChartDetailViewController {
    
    private func fetchData() {
        NetworkManager.requestCoinChartData { result in
            switch result {
            case .success(let coinChartDatas):
                print("--> 코인차트데이터: \(coinChartDatas)")
            case .failure(let error):
                print("--> 코인차트데이터에러: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateCoinInfo(_ coinInfo: CoinInfo) {
        coinTypeLabel.text = "\(coinInfo.key)"
        currentPriceLabel.text = String(format: "%.1f", coinInfo.value.usd.price)
    }
}
