//
//  ChartDetailViewController.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/03.
//

import UIKit

class ChartDetailViewController: UIViewController {

    var coinInfo: CoinInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager.requestCoinChartData { result in
            switch result {
            case .success(let coinChartDatas):
                print("--> 코인차트데이터: \(coinChartDatas)")
            case .failure(let error):
                print("--> 코인차트데이터에러: \(error.localizedDescription)")
            }
        }

    }

}
