//
//  PokemonListRow.swift
//  onTopPoke
//
//  Created by Gabriel Patané Todaro on 31/01/25.
//

import SwiftUI

struct PokemonListRow: View {
    let index: Int
    let species: Species
    
    var body: some View {
        HStack {
            CachedAsyncImage(url: species.imageURL(for: index))
                .frame(width: 84, height: 84)
            
            Text(species.name.capitalized)
                .bold()
            
            Spacer()
            
            Text("#\(index + 1)")
            
        }
    }
}
