//
//  ChartData.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/12.
//

import Foundation

struct ChartDataResponse: Codable {
    let chartDatas: [ChartData]
    
    enum CodingKeys: String, CodingKey {
        case chartDatas = "Data"
    }
}

struct ChartData: Codable {
    let time: TimeInterval
    let closePrice: Double
    
    enum CodingKeys: String, CodingKey {
        case time
        case closePrice = "close"
    }
}

