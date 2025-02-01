//
//  PokemonListViewModel.swift
//  onTopPoke
//
//  Created by Gabriel Patané Todaro on 31/01/25.
//

import SwiftUI

final class PokemonListViewModel: ObservableObject {
    private let requestHandler: RequestHandling
    
    @Published private(set) var species: [Species] = []
    @Published private(set) var isLoading = false
    private var nextOffset = 0
    private let limit = 20
    private var hasMoreData = true
    
    init(requestHandler: RequestHandling) {
        self.requestHandler = requestHandler
    }
    
    @MainActor
    func fetchSpecies() async {
        if !species.isEmpty { return }
        await loadMoreSpecies()
    }
    
    @MainActor
    func appendSpeciesIfNeeded() async {
        await loadMoreSpecies()
    }
    
    @MainActor
    private func loadMoreSpecies() async {
        guard !isLoading, hasMoreData else { return }
        isLoading = true
        
        do {
            let response: SpeciesResponse = try await requestHandler.request(
                route: .getSpeciesList(
                    limit: limit,
                    offset: nextOffset
                )
            )
            
            species.append(contentsOf: response.results)
            nextOffset += limit
            
            if response.results.isEmpty {
                hasMoreData = false
            }
            
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation {
                isLoading = false
            }
        } catch {
            // TODO: handle request handling failures
            print("\(error.localizedDescription)")
        }
    }
}
