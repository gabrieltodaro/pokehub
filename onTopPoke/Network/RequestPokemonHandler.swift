//
//  RequestPokemonHandler.swift
//  onTopPoke
//
//  Created by Gabriel Patané Todaro on 31/01/25.
//

import Foundation

enum APIError: Error {
    case decodingFailed
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .decodingFailed:
            return "Failed to decode the response from the server."
        case .networkError(let error):
            return "A network error occurred: \(error.localizedDescription)"
        }
    }
}

final class RequestPokemonHandler: RequestHandling {    
    func request<T: Decodable>(route: APIRoute) async throws -> T {
        switch route {
        case .getSpeciesList(_, _), .getSpecies(_), .getEvolutionChain(_):
            let urlRequest = route.asRequest()
            
            do {
                let (data, response) = try await URLSession.shared.data(for: urlRequest)
                
                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    throw APIError.networkError(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil))
                }
                
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            } catch let decodingError as DecodingError {
                throw APIError.decodingFailed
            } catch {
                throw APIError.networkError(error)
            }
            
        }
    }
}
