//
//  PokemonDetailViewModel.swift
//  onTopPoke
//
//  Created by Gabriel Patané Todaro on 01/02/25.
//

import SwiftUI

@MainActor
class PokemonDetailViewModel: ObservableObject {
    enum ViewState {
        case loading
        case loaded
        case error(String)
    }
    
    @Published var evolutionChain: [SpeciesDetails] = []
    @Published var viewState: ViewState = .loading
    
    private let requester: RequestPokemonHandler
    
    init(requester: RequestPokemonHandler = RequestPokemonHandler()) {
        self.requester = requester
    }
    
    /**
     Fetches the evolution chain for a given Pokémon species.
     
     This asynchronous method retrieves the detailed species information,
     fetches its corresponding evolution chain, and processes the data
     to construct a complete sequence of evolutions.
     
     - Important: This function updates the `evolutionChain` property with the
     retrieved data, manages the `viewState` state, and handles possible errors.
     
     - Parameters:
     - species: The `Species` object representing the Pokémon whose evolution chain should be fetched.
     
     - Discussion:
     The function follows these steps:
     1. Sets `viewState` to `.loading`.
     2. Requests the `SpeciesDetails` for the given Pokémon species.
     3. Fetches the associated `EvolutionChainDetails` using the evolution chain URL fetched from the previous request.
     4. Calls `fetchEvolutionDetails(from:)` to process the entire evolution chain.
     5. Handles errors by updating the `viewState` property to `.error(String)`.
     6. Sets `viewState` to `.loaded` upon completion.
     
     - Throws: This function does not throw errors directly but updates `viewState` in case of a failure.
     
     - Example:
     ```swift
     await viewModel.fetchEvolutions(for: species)
     ```
     •    SeeAlso: fetchEvolutionDetails(from:)
     */
    func fetchEvolutions(for species: Species) async {
        viewState = .loading
        
        do {
            let speciesDetail: SpeciesDetails = try await requester.request(route: .getSpecies(species.url))
            let chain: EvolutionChainDetails = try await requester.request(route: .getEvolutionChain(speciesDetail.evolutionChain.url))
            
            evolutionChain = try await fetchEvolutionDetails(from: chain.chain)
        } catch {
            viewState = .error("Failed to fetch evolution data")
#if DEBUG
            print("🚨🚨🚨 There's an error with your request: \(error.localizedDescription)")
#endif
        }
        
        viewState = .loaded
    }
    
    /**
     Fetches the full evolution chain details for a given Pokémon.
     
     This asynchronous method processes an evolution chain iteratively,
     retrieving the species details for each evolutionary stage.
     
     - Parameters:
     - chain: The initial `ChainLink` representing the starting Pokémon species in the evolution chain.
     
     - Returns: An array of `SpeciesDetails`, representing the evolution chain from the starting species onward.
     
     - Throws: Throws an error if fetching the species details fails at any point in the chain.
     
     - Discussion:
     This function follows these steps:
     1. Initializes an empty array `speciesArray` to store the evolution details.
     2. Iterates through the evolution chain using a `while` loop:
     - Fetches details of the current species.
     - Appends the species details to `speciesArray`.
     - If an evolution exists (`evolvesTo.first`), proceeds to the next stage.
     3. Stops when there are no further evolutions.
     
     - Important: This function is not handling correctly the Eevee chain of evolution.
     
     - Example:
     ```swift
     let evolutionDetails = try await fetchEvolutionDetails(from: chain.chain)
     ```
     •    SeeAlso: fetchEvolutions(for:)
     */
    private func fetchEvolutionDetails(
        from chain: ChainLink
    ) async throws -> [SpeciesDetails] {
        var speciesArray: [SpeciesDetails] = []
        var currentChain = chain
        
        while true {
            let speciesDetail: SpeciesDetails = try await requester.request(route: .getSpecies(currentChain.species.url))
            speciesArray.append(speciesDetail)
            
            guard let nextEvolution = currentChain.evolvesTo.first else {
                break
            }
            currentChain = nextEvolution
        }
        
        return speciesArray
    }
}
