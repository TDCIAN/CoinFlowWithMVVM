//
//  CoinData.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/12.
//

import Foundation

enum CoinType: String, CaseIterable {
    case BTC
    case ETH
    case DASH
    case LTC
    case ETC
    case XRP
    case BCH
    case XMR
    case QTUM
    case ZEC
    case BTG
}

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
    let xmr: Coin
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
        case btg = "BTG"
    }
}

extension RawData {
    func allCoins() -> [Coin] {
        return [btc, eth, dash, ltc, xrp, bch, xmr, qtum, zec, btg]
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
