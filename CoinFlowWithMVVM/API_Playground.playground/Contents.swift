import UIKit


struct NewsResponse: Codable {
    let articleArray: [Article]
}

struct Article: Codable {
    let title: String
    let link: String
    let date: String
    let timestamp: TimeInterval
    let description: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case link
        case date
        case timestamp
        case description
        case imageURL = "imageUrl"
    }
}

let newsURL = URL(string: "http://coinbelly.com/api/get_rss")!
let urlSession = URLSession.shared
let taskWithNewsURL = urlSession.dataTask(with: newsURL) { (data, response, error) in
    let successRange = 200..<300
    
    guard error == nil,
          let statusCode = (response as? HTTPURLResponse)?.statusCode,
          successRange.contains(statusCode) else {
        return
    }
    
    // 문제가 없는쪽
    guard let responseData = data else { return }
    
    let decoder = JSONDecoder()
    do {
        let response = try decoder.decode([NewsResponse].self, from: responseData)
//        print("--> newsList success: \(response.first?.articleArray)")
    } catch {
        print("--> newsList err: \(error.localizedDescription)")
    }
    
}

taskWithNewsURL.resume()



//https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH,DASH,LTC,ETC,XRP,BCH,XMR,QTUM,ZEC,BTG&tsyms=USD
//https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH&tsyms=USD

let coinListURL = URL(string: "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH&tsyms=USD")!

let taskWithCoinListURL = urlSession.dataTask(with: coinListURL) { (data, response, error) in
    let successRange = 200..<300
    
    guard error == nil,
          let statusCode = (response as? HTTPURLResponse)?.statusCode,
          successRange.contains(statusCode) else {
        return
    }
    
    // 문제가 없는쪽
    guard let responseData = data else { return }
    let string = String(data: responseData, encoding: .utf8)
    print("코인리스트 -> :\(string)")
    let decoder = JSONDecoder()
    do {
//        let response = try decoder.decode([NewsResponse].self, from: responseData)
//        print("--> coinList success: \(response)")
    } catch {
        print("--> coinList err: \(error.localizedDescription)")
    }
    
}

taskWithCoinListURL.resume()
