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
    @State private var scrollProxy: ScrollViewProxy?

    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                
            case .error(let error):
                Text(error)
                    .foregroundColor(.red)
                    
            case .loaded:
                Spacer()
                ScrollViewReader { proxy in
                    drawHorizontalScrollView(proxy: proxy)
                    .scrollIndicators(.hidden)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if let selectedPokemon = viewModel.evolutionChain.first(where: { $0.name == species.name }) {
                                withAnimation(.easeInOut(duration: 0.7)) {
                                    scrollProxy?.scrollTo(selectedPokemon.id, anchor: .center)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .task {
            await viewModel.fetchEvolutions(for: species)
        }
        .navigationTitle(Text("#\(index + 1) - \(species.name.capitalized)"))
    }
    
    @ViewBuilder
    func drawHorizontalScrollView(proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.evolutionChain, id: \.id) { speciesDetail in
                    EvolutionCardView(
                        speciesDetail: speciesDetail,
                        isCurrent: speciesDetail.name == self.species.name
                    )
                    .id(speciesDetail.id)
                    
                    if speciesDetail != viewModel.evolutionChain.last {
                        Image(systemName: "arrow.right")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .onAppear {
                scrollProxy = proxy
            }
        }
    }
}
