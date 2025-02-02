//
//  PokemonDetailViewModel.swift
//  onTopPoke
//
//  Created by Gabriel Patané Todaro on 01/02/25.
//

import SwiftUI

@MainActor
class PokemonDetailViewModel: ObservableObject {
    @Published var evolutionChain: [SpeciesDetails] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
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
       retrieved data, manages the `isLoading` state, and handles possible errors.

     - Parameters:
       - species: The `Species` object representing the Pokémon whose evolution chain should be fetched.

     - Discussion:
       The function follows these steps:
       1. Sets `isLoading` to `true` and clears any previous `errorMessage`.
       2. Requests the `SpeciesDetails` for the given Pokémon species.
       3. Fetches the associated `EvolutionChainDetails` using the evolution chain URL fetched from the previous request.
       4. Calls `fetchEvolutionDetails(from:)` to process the entire evolution chain.
       5. Handles errors by updating the `errorMessage` property.
       6. Sets `isLoading` to `false` upon completion.

     - Throws: This function does not throw errors directly but updates `errorMessage`
       in case of a failure.

     - Example:
     ```swift
     await viewModel.fetchEvolutions(for: species)
     ```
     •    SeeAlso: fetchEvolutionDetails(from:)
     */
    func fetchEvolutions(for species: Species) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let speciesDetail: SpeciesDetails = try await requester.request(route: .getSpecies(species.url))
            
            let chain: EvolutionChainDetails = try await requester.request(route: .getEvolutionChain(speciesDetail.evolutionChain.url))
            
            evolutionChain = try await fetchEvolutionDetails(from: chain.chain)
        } catch {
            errorMessage = "Failed to fetch evolution data"
            print("Error fetching evolutions: \(error)")
        }
        
        isLoading = false
    }

    /**
     Fetches the full evolution chain details for a given Pokémon.

     This asynchronous method processes an evolution chain recursively, retrieving the species details for each evolutionary stage.

     - Parameters:
       - chain: The initial `ChainLink` representing the starting Pokémon species in the evolution chain.

     - Returns: An array of `SpeciesDetails`, representing the evolution chain from the starting species onward.

     - Throws: Throws an error if fetching the species details fails at any point in the chain.

     - Discussion:
       This function follows these steps:
       1. Initializes an empty array `speciesArray` to store the evolution details.
       2. Iterates through the evolution chain:
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
