//
//  CoinData.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/12.
//

import Foundation

struct CoinListResponse: Codable {
    let raw: RawData
    
    enum CodingKeys: String, CodingKey {
        case raw = "RAW"
    }
}

struct RawData: Codable {
    let btc: Coin
    let eth: Coin
    // ---
    let dash: Coin
    let ltc: Coin
    let etc: Coin
    let xrp: Coin
    let bch: Coin
    let xmr: Coint
    let qtum: Coin
    let zec: Coin
    let btg: Coin
    
    enum CodingKeys: String, CodingKey {
        case btc = "BTC"
        case eth = "ETH"
        // ---
        case dash = "DASH"
        case ltc = "LTC"
        case etc = "ETC"
        case xrp = "XRP"
        case bch = "BCH"
        case xmr = "XMR"
        case qtum = "QTUM"
        case zec = "ZEC"
        case bth = "BTG"
    }
}

struct Coin: Codable {
    let usd: CurrencyInfo
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

struct CurrencyInfo: Codable {
    let price: Double
    let changeLast24H: Double
    let changePercentLast24H: Double
    let market: String
    
    enum CodingKeys: String, CodingKey {
        case price = "PRICE"
        case changeLast24H = "CHANGE24HOUR"
        case changePercentLast24H = "CHANGEPCT24HOUR"
        case market = "LASTMARKET"
    }
}
