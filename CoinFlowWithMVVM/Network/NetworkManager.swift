//
//  NetworkManager.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/12.
//

import Foundation

class NetworkManager {
    
    static let session = URLSession.shared
    
    static func requestCoinList() {
        
    }

    static func requestCoinChartData() {
        
    }
    
    static func requestNewsList() {
        let newsURL = URL(string: "http://coinbelly.com/api/get_rss")!
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
            } catch {
                print("--> NewsList Error: \(error.localizedDescription)")
            }
            
        }
    }
    
}
