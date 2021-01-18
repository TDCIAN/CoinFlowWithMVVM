//
//  ChartDetailViewModel.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/18.
//

import Foundation
import UIKit

class ChartDetailViewModel {
    typealias Handler = ([CoinChartInfo], Period) -> Void
    var changeHandler: Handler
        
    var coinInfo: CoinInfo!
    var chartDatas: [CoinChartInfo] = []
    var selectedPeriod: Period = .day
    
    init(coinInfo: CoinInfo, chartDatas: [CoinChartInfo], selectedPeriod: Period, changeHandler: @escaping Handler) {
        self.coinInfo = coinInfo
        self.chartDatas = chartDatas
        self.selectedPeriod = selectedPeriod
        self.changeHandler = changeHandler
    }
}

extension ChartDetailViewModel {
    func fetchData() {
        let dispatchGroup = DispatchGroup()
        Period.allCases.forEach { period in
            dispatchGroup.enter()
            NetworkManager.requestCoinChartData(coinType: coinInfo.key, period: period) { (result: Result<[ChartData], Error>) in
                dispatchGroup.leave()
                switch result {
                case .success(let chartDatas):
                    self.chartDatas.append(CoinChartInfo(key: period, value: chartDatas))
                    print("--> success:\(chartDatas.count), \(period)")
                case .failure(let error):
                    print("--> err: \(error.localizedDescription)")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // update chart
            print("update chart")
            self.changeHandler(self.chartDatas, self.selectedPeriod)
        }
    }
    
    func updateNotify(handler: @escaping Handler) {
        self.changeHandler = handler
    }
}
