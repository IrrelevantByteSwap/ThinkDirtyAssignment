//
//  ProductsService.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//

import Foundation
import Combine

class ProductsService {
    
    enum Endpoint: String {
        case fetchProducts = "products.json"
        case fetchMalformed = "products_malformed.json"
        case fetchEmpty = "products_empty.json"
    }
    
    let agent = NetworkAgent()
    let base = URL(string:"https://td-ios-coding-challenge.s3.amazonaws.com/product_data/")! // should be constructed considering Backend Env through xcconfig files
}

extension ProductsService {
    
    func fetchProducts() -> AnyPublisher<Products, Error> {
        let url = base.appendingPathComponent(Endpoint.fetchProducts.rawValue)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Content-Type": "application/json", "accept": "application/json"]
        return agent.run(request).eraseToAnyPublisher()
    }
    
    func fetchMalformed() -> AnyPublisher<Products, Error> {
        let url = base.appendingPathComponent(Endpoint.fetchMalformed.rawValue)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Content-Type": "application/json", "accept": "application/json"] // should be set once per service, sorry for copypaste
        return agent.run(request).eraseToAnyPublisher()
    }
    
    func fetchEmpty() -> AnyPublisher<Products, Error> {
        let url = base.appendingPathComponent(Endpoint.fetchEmpty.rawValue)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Content-Type": "application/json", "accept": "application/json"]
        return agent.run(request).eraseToAnyPublisher()
    }
    
}
