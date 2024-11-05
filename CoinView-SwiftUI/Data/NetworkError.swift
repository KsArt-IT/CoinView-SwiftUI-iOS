//
//  NetworkServiceError.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//


import Foundation

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse(code: Int)
    case statusCode(code: Int, message: String)
    case decodingError(DecodingError)
    case networkError(Error)
    case cancelled // отменен запрос

    var localizedDescription: String {
        switch self {
            case .invalidRequest:
                "The request is invalid."
            case .invalidResponse(let code):
                "The response is invalid. Code: \(code)."
            case .statusCode(let code, let message):
                "Unexpected status code: \(code). \(message)"
            case .decodingError(let error):
                "Decoding failed with error: \(error.localizedDescription)."
            case .networkError(let error):
                "Network error occurred: \(error.localizedDescription)."
            case .cancelled:
                ""
        }
    }
}
