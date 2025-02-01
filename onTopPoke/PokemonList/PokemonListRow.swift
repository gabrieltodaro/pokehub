//
//  PokemonListRow.swift
//  onTopPoke
//
//  Created by Gabriel Patané Todaro on 31/01/25.
//

import SwiftUI

struct PokemonListRow: View {
    let index: Int
    let specie: Species
    var imageURL: URL {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(index + 1).png")!
    }
    
    var body: some View {
        HStack {
            CachedAsyncImage(url: imageURL)
                .frame(width: 84, height: 84)
            
            Text(specie.name.capitalized)
                .bold()
            
            Spacer()
            
            Text("#\(index + 1)")
            
        }
    }
}
