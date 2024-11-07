//
//  NetworkServiceError.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//


import Foundation

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse(code: Int, message: String)
    case statusCode(code: Int, message: String)
    case decodingError(DecodingError)
    case networkError(Error)
    case cancelled // отменен запрос

    var localizedDescription: String {
        switch self {
            case .invalidRequest:
                "The request is invalid."
            case .invalidResponse(let code, let message):
                "The response is invalid, code: \(code).\n\(message)"
            case .statusCode(let code, let message):
                "Unexpected status code: \(code).\n\(message)"
            case .decodingError(let error):
                "Decoding failed with error: \(error.localizedDescription)."
            case .networkError(let error):
                "Network error occurred: \(error.localizedDescription)."
            case .cancelled:
                ""
        }
    }
}
