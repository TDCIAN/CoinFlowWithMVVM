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

struct CoinListResponse: Codable {
    let raw: RawData
    
    enum CodingKeys: String, CodingKey {
        case raw = "RAW"
    }
}

struct RawData: Codable {
    let btc: Coin
    let eth: Coin
    
    enum CodingKeys: String, CodingKey {
        case btc = "BTC"
        case eth = "ETH"
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
//    print("코인리스트 -> :\(string)")
    let decoder = JSONDecoder()
    do {
        let response = try decoder.decode(CoinListResponse.self, from: responseData)
//        print("--> coinList success: \(response.raw.eth)")
    } catch {
        print("--> coinList err: \(error.localizedDescription)")
    }
    
}

taskWithCoinListURL.resume()


struct StockDataResponse: Codable {
    let metaData: MetaData
    let timeSeries: TimeSeries
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Time Series (Daily)"
    }
}

struct MetaData: Codable {
    let information: String
    let symbol: String
    let lastRefreshed: String
    let outputSize: String
    let timeZone: String
    
    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case symbol = "2. Symbol"
        case lastRefreshed = "3. Last Refreshed"
        case outputSize = "4. Output Size"
        case timeZone = "5. Time Zone"
    }
}

struct TimeSeries: Codable {

    let priceForDate: [PriceForDate]
    
    enum CodingKeys: String, CodingKey {
        
        case priceForDate = dateString
    }
}

let stockDataURL = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=IBM&apikey=demo")!

let taskWithStockURL = urlSession.dataTask(with: stockDataURL) { (data, response, error) in
    let successRange = 200..<300
    
    guard error == nil,
          let statusCode = (response as? HTTPURLResponse)?.statusCode,
          successRange.contains(statusCode) else {
        return
    }
    
    guard let responseData = data else { return }
    let string = String(data: responseData, encoding: .utf8)
//    print("주식 스트링: \(string)")
    let decoder = JSONDecoder()
    do {
        let response = try decoder.decode(StockDataResponse.self, from: responseData)
        print("주식 리스트 석세스: \(response.metaData)")
    } catch {
        print("주식 리스트 에러: \(error.localizedDescription)")
    }
}
taskWithStockURL.resume()
