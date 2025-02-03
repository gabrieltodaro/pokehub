//
//  EvolutionCardView.swift
//  onTopPoke
//
//  Created by Gabriel Patané Todaro on 03/02/25.
//

import SwiftUI

struct EvolutionCardView: View {
    let speciesDetail: SpeciesDetails
    let isCurrent: Bool

    var body: some View {
        VStack {
            CachedAsyncImage(url: speciesDetail.imageURL(for: speciesDetail.id))
                .scaledToFit()
                .frame(width: 160, height: 160)

            Text(speciesDetail.name.capitalized)
                .font(.caption)
                .foregroundColor(.primary)
                .padding(.top, 4)
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    isCurrent ? pokeballGradient : LinearGradient(
                        gradient: Gradient(colors: [Color.gray, Color.gray]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 4
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
    
    private var pokeballGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color.red, location: 0.0),
                .init(color: Color.red, location: 0.3),
                .init(color: Color.black, location: 0.45),
                .init(color: Color.white, location: 0.55),
                .init(color: Color.white, location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
