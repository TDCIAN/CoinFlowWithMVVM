//
//  Request.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/13.
//

import Foundation

enum HTTPMethod {
    
}

enum RequestParam {
    
}

protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var params: RequestParam { get}
    var format: String? { get }
    var header: [String]? { get }
}
