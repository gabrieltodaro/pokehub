import Foundation

/// Species object returned as part of the `getSpeciesDetails` endpoint
struct SpeciesDetails: Decodable, Equatable {
    let id: Int
    let name: String
    let evolutionChain: EvolutionChain
    let evolvesFromSpecies: Species?
    
    func imageURL(for index: Int) -> URL {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(index).png")!
    }
    
    static func ==(lhs: SpeciesDetails, rhs: SpeciesDetails) -> Bool {
        lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case evolutionChain = "evolution_chain"
        case evolvesFromSpecies = "evolves_from_species"
    }
}

/// EvolutionChain model returned as part of the SpeciesDetails from the `getSpecies` endpoint
struct EvolutionChain: Decodable {
    let url: URL
}
