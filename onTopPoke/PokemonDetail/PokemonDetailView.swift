//
//  PokemonDetailView.swift
//  onTopPoke
//
//  Created by Gabriel Patané Todaro on 01/02/25.
//

import SwiftUI
struct PokemonDetailView: View {
    let index: Int
    let species: Species

    @StateObject private var viewModel = PokemonDetailViewModel()

    var body: some View {
        VStack {
            Spacer()

            HStack {
                ForEach(viewModel.evolutionChain, id: \.id) { speciesDetail in
                    VStack {
                        CachedAsyncImage(url: speciesDetail.imageURL(for: speciesDetail.id))
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(speciesDetail.name == self.species.name ? Color.blue : Color.gray, lineWidth: 3))

                        Text(speciesDetail.name.capitalized)
                            .font(.caption)
                    }

                    if speciesDetail != viewModel.evolutionChain.last {
                        Image(systemName: "arrow.right")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
            }

            if viewModel.isLoading {
                ProgressView()
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .task {
            await viewModel.fetchEvolutions(for: species)
        }
        .navigationTitle(Text("#\(index + 1) - \(species.name.capitalized)"))
    }
}
