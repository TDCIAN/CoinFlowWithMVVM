//
//  NetworkManager.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/12.
//

import Foundation

class NetworkManager {
    
    static let session = URLSession.shared
    
    static func requestCoinList(completion: @escaping ([Coin]) -> Void) {
        let url = URL(string: "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH,DASH,LTC,ETC,XRP,BCH,XMR,QTUM,ZEC,BTG&tsyms=USD")!
        
        let taskWithURL = session.dataTask(with: url) { (data, response, error) in
            let successRange = 200..<300
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                return
            }
            
            guard let responseData = data else { return }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(CoinListResponse.self, from: responseData)
                //print("---> response: \(response)")
                let allCoins = response.raw.allCoins()
                completion(allCoins)
            } catch {
                print("---> err: \(error.localizedDescription)")
            }
        }

        taskWithURL.resume()
    }
    
    static func requestCoinChartData(completion: @escaping ([ChartData]) -> Void) {
        let chartURL = URL(string: "https://min-api.cryptocompare.com/data/histohour?fsym=BTC&tsym=USD&limit=24")!
        let taskWithChartURL = session.dataTask(with: chartURL) { (data, response, error) in
            let successRange = 200..<300
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                return
            }
            
            guard let responseData = data else { return }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ChartDataResponse.self, from: responseData)
                let chartDatas = response.chartDatas
                completion(chartDatas)
                //print("---> response: \(response)")
            } catch {
                print("---> err: \(error.localizedDescription)")
            }
        }

        taskWithChartURL.resume()
    }
    
    static func requestNewsList(completion: @escaping ([Article]) -> Void) {
        let newsURL = URL(string: "https://coinbelly.com/api/get_rss")!
        let taskWithNewsURL = session.dataTask(with: newsURL) { (data, response, error) in
            let successRange = 200..<300
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                return
            }
            
            guard let responseData = data else { return }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode([NewsResponse].self, from: responseData)
                let articles = response.flatMap({ $0.articleArray })
                completion(articles)
                //print("---> response: \(response)")
            } catch {
                print("---> err: \(error.localizedDescription)")
            }
        }
        taskWithNewsURL.resume()
    }
}


extension NetworkManager {
    static func requestCoinList(completion: @escaping (Result<[Coin], Error>) -> Void) {
        let params: RequestParam = .url(["fsyms": "BTC,ETH,DASH,LTC,ETC,XRP,BCH,XMR,QTUM,ZEC,BTG", "tsyms":"USD"])
        guard let url = CoinListRequest(param: params).urlRequest()?.url else { return }
        let taskWithURL = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let responseData = data else { return }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(CoinListResponse.self, from: responseData)
                let allCoins = response.raw.allCoins()
                completion(.success(allCoins))
            } catch {
                print("---> err: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func requestCoinChartData(coinType: CoinType, period: Period ,completion: @escaping (Result<[ChartData], Error>) -> Void) {
        let params: RequestParam =
            .url(["fsym":"\(coinType.rawValue)",
                  "tsym":"USD",
                  "limit":"\(period.limitParameter)",
                  "aggregate": "\(period.aggregateParameter)"])
        guard let url = CoinChartDataRequest(period: period, param: params).urlRequest()?.url else { return }
        let taskWithURL = session.dataTask(with: url) { (data, response, error) in
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
            } catch {
                print("---> err: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func requestNewsList(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = NewsListRequest().urlRequest()?.url else { return }
        let taskWithURL = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let responseData = data else { return }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode([NewsResponse].self, from: responseData)
                let articles = response.flatMap({ $0.articleArray })
                completion(.success(articles))
            } catch {
                print("---> err: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}
