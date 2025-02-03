import Foundation

/// EvolutionChain model returned from the `getEvolutionChain` endpoint
struct EvolutionChainDetails: Decodable {
    let id: Int
    let chain: ChainLink
}

/// ChainLink model returned as part of the EvolutionChainDetails from the `getEvolutionChain` endpoint
struct ChainLink: Decodable {
    let species: Species
    let evolvesTo: [ChainLink]
    
    enum CodingKeys: String, CodingKey {
        case species = "species"
        case evolvesTo = "evolves_to"
    }
}
