//
//  CoinChartDataRequest.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/13.
//

import Foundation

struct CoinChartDataRequest: Request {
    var method: HTTPMethod = .get
    var params: RequestParam
    var path: String
    
    init(period: Period, param: RequestParam) {
        self.path = EndPoint.coinList + period.urlPath
        self.params = param
    }
}
