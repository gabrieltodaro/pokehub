import Foundation

/// Response from the `getSpeciesList` endpoint
struct SpeciesResponse: Decodable {
    let count: Int
    let results: [Species]
}

/// Species object returned as part of the `SpeciesResponse` object from the `getSpeciesList` endpoint
struct Species: Decodable, Hashable, Identifiable {
    var id: String { name }
    let name: String
    let url: URL
    
    func imageURL(for index: Int) -> URL {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(index + 1).png")!
    }
}
