//
//  PokemonDetailView.swift
//  onTopPoke
//
//  Created by Gabriel Patané Todaro on 01/02/25.
//

import SwiftUI

/// Details view showing the evolution chain of a Pokémon (WIP)
///
/// It now only shows a placeholder image, make it so that it also shows the evolution chain of the selected Pokémon, in whatever way you think works best.
/// The evolution chain url can be fetched using the endpoint `APIRouter.getSpecies(URL)` (returns type `SpeciesDetails`), and the evolution chain details through `APIRouter.getEvolutionChain(URL)` (returns type `EvolutionChainDetails`).
/// Requires a working `RequestHandler`
struct PokemonDetailView: View {
    let index: Int
    let species: Species
    
    var body: some View {
        Text("#\(index + 1)")
        Text("Hello \(species.name.capitalized)")
    }
}
