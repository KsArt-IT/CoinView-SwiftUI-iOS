//
//  CoinNetworkServiceImpl.swift
//  CoinView-SwiftUI
//
//  Created by KsArT on 05.11.2024.
//

import Foundation

final class CoinNetworkServiceImpl: CoinNetworkService {
    private let decoder = JSONDecoder()

    func fetchData<T>(endpoint: CoinEndpoint) async -> Result<T, any Error> where T : Decodable {
        guard let request = getRequest(endpoint.url) else { return .failure(NetworkError.invalidRequest)}
        
        do {
            let data = try await executeRequest(request)
            let result: T = try decode(from: data)
            return .success(result)
        } catch let error as NetworkError {
            return .failure(error)
        } catch let error as DecodingError {
            return .failure(NetworkError.decodingError(error))
        } catch let error as URLError where error.code == .cancelled {
            return .failure(NetworkError.cancelled)
        } catch {
            print("NetworkServiceImpl: \(error)")
            return .failure(NetworkError.networkError(error))
        }
    }
    
    func fetchData(url: String) async -> Data? {
        guard let url = URL(string: url), let request = getRequest(url) else { return nil }
        
        do {
            let data = try await executeRequest(request)
            return data
        } catch {
            print("CoinNetworkServiceImpl: error=\(error.localizedDescription)")
            return nil
        }
    }
    
}

private extension CoinNetworkServiceImpl {
    
    // MARK: - Dencode - Request - Response
    private func getRequest(_ url: URL?) -> URLRequest? {
        guard let url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return request
    }

    private func executeRequest(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        if let codeError = getCodeErrorFormResponse(response) {
            throw NetworkError.invalidResponse(code: codeError)
        }
        
        return data
    }
    
    private func getCodeErrorFormResponse(_ response: URLResponse) -> Int? {
        guard let httpResponse = response as? HTTPURLResponse else { return -1 }
        
        return if 200...299 ~= httpResponse.statusCode {
            nil
        } else {
            httpResponse.statusCode
        }
    }

    private func decode<T>(from data: Data) throws -> T where T : Decodable {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }

}
