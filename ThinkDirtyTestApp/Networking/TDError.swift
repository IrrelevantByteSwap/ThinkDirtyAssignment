//
//  TDError.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//

import Foundation
import Foundation

enum TDError {
    case plainApiError(String)
    case coolApiError(Int, String, String)
    case urlError(URLError)
    case decodingError
}

extension TDError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .plainApiError(let message): return message
        case .coolApiError(let statusCode, let title, let description): return ["\(statusCode)", title, description].joined(separator: " ")
        case .urlError(let error): return error.localizedDescription
        case .decodingError: return "Response Decoding Error"
        }
    }
}
