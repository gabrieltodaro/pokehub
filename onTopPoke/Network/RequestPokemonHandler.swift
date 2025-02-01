//
//  RequestPokemonHandler.swift
//  onTopPoke
//
//  Created by Gabriel Patané Todaro on 31/01/25.
//

import Foundation

enum APIError: Error {
    case needImplementation
    case invalidURL
    case decodingFailed
}

final class RequestPokemonHandler: RequestHandling {    
    func request<T>(route: APIRoute) async throws -> T {
        switch route {
        case .getSpeciesList(_, _):
            let urlRequest = route.asRequest()
            
            do {
                let (data, _) = try await URLSession.shared.data(for: urlRequest)
                let response = try JSONDecoder().decode(SpeciesResponse.self, from: data)
                
                if let typedResponse = response as? T {
                    return typedResponse
                } else {
                    throw APIError.decodingFailed
                }
            } catch {
                throw error
            }
            
        default:
            throw APIError.needImplementation
        }
    }
}
