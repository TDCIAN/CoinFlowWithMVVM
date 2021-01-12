//
//  Request.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/13.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
    case put = "PUT"
    
    var name: String {
        return self.rawValue
    }
}

enum RequestParam {
    case url([String: String])
    case body([String: String])
}

protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var params: RequestParam { get}
    var format: String? { get }
    var headers: [String]? { get }
}

extension Request {
    var method: HTTPMethod { return .get }
    var format: String? { return "application/json"}
    var headers: [String]? { return ["Content-Type", "Accept"]}
    
    // Request 해야하는 목표 -> URL 만들어 내기
    func urlRequest() -> URLRequest {
        let url = URL(string: path)!
        var request = URLRequest(url: url)
        
        // http method
        request.httpMethod = method.name
        
        // header
        headers?.forEach { headerField in
            request.setValue(format, forHTTPHeaderField: headerField)
        }
        
        // config param
        switch params {
        case .body(let params):
            let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
            if let data = bodyData {
                request.httpBody = data
            }
        case .url(let params):
            let queryParams = params.map { URLQueryItem(name: $0.key, value: $0.value) }
            var components = URLComponents(string: path)
            components?.queryItems = queryParams
            request.url = components?.url
        }
        
        return request
    }
}
