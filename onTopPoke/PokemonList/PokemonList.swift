//
//  PokemonList.swift
//  onTopPoke
//
//  Created by Gabriel Patané Todaro on 31/01/25.
//

import SwiftUI

struct PokemonList: View {
    @StateObject var viewModel: PokemonListViewModel
    
    var body: some View {
        ZStack {
            List(viewModel.species) { specie in
                let index = viewModel.species.firstIndex(where: { $0.id == specie.id }) ?? 0
                
                NavigationLink(value: Router.pokemon(index: index, species: specie)) {
                    PokemonListRow(
                        index: index,
                        specie: specie
                    )
                    .onAppear {
                        if specie == viewModel.species.last, !viewModel.isLoading {
                            Task {
                                await viewModel.appendSpeciesIfNeeded()
                            }
                        }
                    }
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .opacity(viewModel.isLoading ? 1 : 0)
                    .animation(.easeOut(duration: 0.5), value: viewModel.isLoading)
            }
        }
        .task {
            await viewModel.fetchSpecies()
        }
        .navigationTitle("POKéMON")
    }
}
