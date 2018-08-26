//
//  PokemonProvider.swift
//  MVPokemon
//
//  Created by Sam Jarman on 15/08/18.
//  Copyright © 2018 Sam Jarman. All rights reserved.
//

import UIKit

struct PokemonListResult: Codable {
    let count: Int?
    let previous: URL?
    let results: [PokemonIndex]?
    let next: URL?
}

struct PokemonIndex: Codable {
    let name: String?
    let detailsURL: URL?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case detailsURL = "url"
    }
}

protocol PokemonProviderFetchPokemonListDelegate: class {
    func didBeginFetchingPokemonList()
    func didFinishFetchingPokemonList()
    func didSuccessfullyFetchPokemonList(withList list: [PokemonIndex])
    func didFailToFetchPokemonList(withError error: Error)

}
class PokemonProvider {
    weak var listDelegate: PokemonProviderFetchPokemonListDelegate?
    //weak var detailsDelegate: PokemonProviderFetchPokemonListDelegate?

    func getPokemonList(session: URLSession = .shared) {
        guard let delegate = self.listDelegate else { return }
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=949")
        
        let fetchTask = session.dataTask(with: url!) { (data, response, error) in
            delegate.didFinishFetchingPokemonList()
            if let error = error {
                delegate.didFailToFetchPokemonList(withError: error)
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let pokemans = try decoder.decode(PokemonListResult.self, from: data)
                    print(pokemans)
                    delegate.didSuccessfullyFetchPokemonList(withList: pokemans.results!)
                } catch let err {
                    print("Err", err)
                }
            }
        }
        delegate.didBeginFetchingPokemonList()
        fetchTask.resume()
    }
}
