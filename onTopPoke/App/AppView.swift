//
//  AppView.swift
//  onTopPoke
//
//  Created by Gabriel Patané Todaro on 31/01/25.
//

import SwiftUI

enum Router: Hashable {
    case pokemon(index: Int, species: Species)
}

struct AppView: View {
    @State private var router: [Router] = []
    
    var body: some View {
        NavigationStack(path: $router) {
            PokemonList(
                viewModel: PokemonListViewModel(
                    requestHandler: RequestPokemonHandler()
                )
            )
            .navigationDestination(for: Router.self) { router in
                switch router {
                case let .pokemon(index, species):
                    PokemonDetailView(index: index, species: species)
                }
            }
        }
    }
}
