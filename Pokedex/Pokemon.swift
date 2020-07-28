import Foundation

struct PokemonListResults: Codable {
    let results: [PokemonListResult]
}

struct PokemonListResult: Codable {
    let name: String
    let url: String
}

struct PokemonResult: Codable {
    let id: Int
    let name: String
    let sprites : PokemonImage
    let types: [PokemonTypeEntry]
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}
struct PokemonImage : Codable {
    let front_default : String
}

struct PokemonDescription: Codable {
    
    let flavor_text_entries: [PokemonDescArray]
}

struct PokemonDescArray : Codable {
    let flavor_text : String
    let language : [String : String]
}


