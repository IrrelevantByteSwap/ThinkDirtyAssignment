//
//  NetworkAgent.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//

import Foundation
import Combine

struct NetworkAgent {
    private var urlSession: URLSession
    private let configuration = NetworkLogger.defaultSessionConfiguration()
    private let queue = OperationQueue()
    private let session = HTTPSSessionHandler()

    init() {
        queue.qualityOfService = .utility
        urlSession = URLSession(configuration: configuration, delegate: session, delegateQueue: queue)
    }

    func run<T: Codable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        urlSession
            .dataTaskPublisher(for: request)
            .mapError({ error in TDError.plainApiError(error.localizedDescription)})
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ _ in TDError.decodingError })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class HTTPSSessionHandler: NSObject, URLSessionDelegate {

    static let shared = HTTPSSessionHandler()
    private let disposition = URLSession.AuthChallengeDisposition.useCredential
    private let credential = URLCredential()

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(disposition, credential)
    }
}
