//
//  HTTPClient.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/10/24.
//

import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        if let queryItems = endpoint.queryItems {
            urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
         
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.type.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            switch response.statusCode {
            case 200...299:
//                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
//                    print("endpoint: \(endpoint) data: \(data)")
//                    return .failure(.decode)
//                }
//                return .success(decodedResponse)
                do {
                    let decodedResponse = try JSONDecoder().decode(responseModel.self, from: data)
                    // Use decodedResponse here
                    return .success(decodedResponse)
                } catch {
                    print("Error decoding response: \(error)")
                    print("Endpoint: \(endpoint) Data: \(data)")
                    return .failure(.decode)
                }
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
