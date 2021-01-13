//
//  NetworkManager.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/12.
//

import Foundation

class NetworkManager {
    
    static let session = URLSession.shared
    
//    static func requestCoinList(completion: @escaping ([Coin]) -> Void) {
//        let coinListURL = URL(string: "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH,DASH,LTC,ETC,XRP,BCH,XMR,QTUM,ZEC,BTG&tsyms=USD")!
//        let taskWithCoinListURL = session.dataTask(with: coinListURL) { (data, response, error) in
//            let successRange = 200..<300
//            guard error == nil,
//                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
//                  successRange.contains(statusCode) else {
//                return
//            }
//
//            guard let responseData = data else { return }
//
//            let decoder = JSONDecoder()
//            do {
//                let response = try decoder.decode(CoinListResponse.self, from: responseData)
//                print("--> coinList Success: \(response.raw.btg)")
//                let coinList = response.raw.allCoins()
//                completion(coinList)
//            } catch {
//                print("--> CoinList Err: \(error.localizedDescription)")
//            }
//
//        }
//        taskWithCoinListURL.resume()
//    }
//
//    static func requestCoinChartData(completion: @escaping ([ChartData]) -> Void) {
//        let coinChartDataURL = URL(string: "https://min-api.cryptocompare.com/data/histohour?fsym=BTC&tsym=USD&limit=24")!
//        let taskWithCoinChartDataURL = session.dataTask(with: coinChartDataURL) { (data, response, error) in
//            let successRange = 200..<300
//            guard error == nil,
//                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
//                  successRange.contains(statusCode) else {
//                return
//            }
//
//            guard let responseData = data else { return }
//            let decoder = JSONDecoder()
//            do {
//                let response = try decoder.decode(ChartDataResponse.self, from: responseData)
//                let chartDatas = response.chartDatas
//                completion(chartDatas)
//            } catch {
//                print("--> CoinChart Err: \(error.localizedDescription)")
//            }
//        }
//        taskWithCoinChartDataURL.resume()
//    }
//
//    static func requestNewsList(completion: @escaping ([Article]) -> Void) {
//        let newsURL = URL(string: "http://coinbelly.com/api/get_rss")!
//        let taskWithNewsURL = session.dataTask(with: newsURL) { (data, response, error) in
//            let successRange = 200..<300
//
//            guard error == nil,
//                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
//                  successRange.contains(statusCode) else {
//                return
//            }
//
//            guard let responseData = data else { return }
//
//            let decoder = JSONDecoder()
//            do {
//                let response = try decoder.decode([NewsResponse].self, from: responseData)
//                let articles = response.flatMap { $0.articleArray }
//                completion(articles)
//            } catch {
//                print("--> NewsList Error: \(error.localizedDescription)")
//            }
//
//        }
//        taskWithNewsURL.resume()
//    }
    
}

extension NetworkManager {
    static func requestCoinList(completion: @escaping (Result<[Coin], Error>) -> Void) {
        let param: RequestParam = .url(["fsyms":"BTC,ETH,DASH,LTC,ETC,XRP,BCH,XMR,QTUM,ZEC,BTG", "tsyms":"USD"])
        guard let url = CoinListRequest(param: param).urlRequest().url else { return }
        
//        let coinListURL = URL(string: "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH,DASH,LTC,ETC,XRP,BCH,XMR,QTUM,ZEC,BTG&tsyms=USD")!
        let taskWithCoinListURL = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let responseData = data else { return }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(CoinListResponse.self, from: responseData)
                print("--> coinList Success: \(response.raw.btg)")
                let coinList = response.raw.allCoins()
                completion(.success(coinList))
            } catch let error {
                print("--> CoinList Err: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
        }
        taskWithCoinListURL.resume()
    }

    static func requestCoinChartData(completion: @escaping (Result<[ChartData], Error>) -> Void) {
        let param: RequestParam = .url(["fsym":"BTC", "tsym":"USD", "limit":"24"])
        guard let url = CoinChartDataRequest(period: .day, param: param).urlRequest().url else { return }
        
        let coinChartDataURL = URL(string: "https://min-api.cryptocompare.com/data/histohour?fsym=BTC&tsym=USD&limit=24")!
        let taskWithCoinChartDataURL = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let responseData = data else { return }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ChartDataResponse.self, from: responseData)
                let chartDatas = response.chartDatas
                completion(.success(chartDatas))
            } catch let error {
                print("--> CoinChart Err: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        taskWithCoinChartDataURL.resume()
    }
    
    static func requestNewsList(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = NewsListRequest().urlRequest().url else { return }
//        let newsURL = URL(string: "http://coinbelly.com/api/get_rss")!
        let taskWithNewsURL = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let responseData = data else { return }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode([NewsResponse].self, from: responseData)
                let articles = response.flatMap { $0.articleArray }
                completion(.success(articles))
            } catch let error {
                print("--> NewsList Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
        }
        taskWithNewsURL.resume()
    }
    
}
