//
//  ChartDetailViewController.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/03.
//

import UIKit

typealias CoinChartInfo = (key: Period, value: [ChartData])

class ChartDetailViewController: UIViewController {
    @IBOutlet weak var coinTypeLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var highlightBar: UIView!
    @IBOutlet weak var highlightBarLeading: NSLayoutConstraint!
    
    var coinInfo: CoinInfo!
    var chartDatas: [CoinChartInfo] = []
    var selectedPeriod: Period = .day
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateCoinInfo(coinInfo)
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("--> 꽂힌 정보 확인 => 키: \(coinInfo.key), 밸류: \(coinInfo.value)")
    }

    @IBAction func dailyButtonTapped(_ sender: UIButton) {
        moveHighlightBar(to: sender)
    }
    
    @IBAction func weeklyButtonTapped(_ sender: UIButton) {
        moveHighlightBar(to: sender)
    }
    
    @IBAction func monthlyButtonTapped(_ sender: UIButton) {
        moveHighlightBar(to: sender)
    }
    
    @IBAction func yearlyButtonTapped(_ sender: UIButton) {
        moveHighlightBar(to: sender)
    }
    
}

extension ChartDetailViewController {
    
    private func fetchData() {
        
        Period.allCases.forEach { period in
            NetworkManager.requestCoinChartData(coinType: coinInfo.key, period: period) { result in
                switch result {
                case .success(let coinChartDatas):
    //                print("--> 코인차트데이터: \(coinChartDatas)")
                    self.chartDatas.append(CoinChartInfo(key: period, value: coinChartDatas))
                case .failure(let error):
                    print("--> 코인차트데이터에러: \(error.localizedDescription)")
                }
            }
        }



    }
    
    private func updateCoinInfo(_ coinInfo: CoinInfo) {
        coinTypeLabel.text = "\(coinInfo.key)"
        currentPriceLabel.text = String(format: "%.1f", coinInfo.value.usd.price)
    }
    
    private func moveHighlightBar(to button: UIButton) {
        highlightBarLeading.constant = button.frame.minX
    }
}
