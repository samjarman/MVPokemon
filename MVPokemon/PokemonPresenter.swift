//
//  PokemonPresenter.swift
//  MVPokemon
//
//  Created by Sam Jarman on 15/08/18.
//  Copyright © 2018 Sam Jarman. All rights reserved.
//

import Foundation

protocol PokemonPresenterView: class {
    func beginLoading(withText text: String)
    func endLoading()
    func showError(withText text: String)
    func refreshView()
}

class PokemonPresenter {
    weak var view: PokemonPresenterView?
    var provider: PokemonProvider!
    var pokemonList: [PokemonIndex]?
    
    init() {
        provider = PokemonProvider()
        provider.listDelegate = self
    }
    
    func fetchPokemonList(_ alternateProvider: PokemonProvider? = nil) {
        if let alternateProvider = alternateProvider {
            alternateProvider.listDelegate = self
            alternateProvider.getPokemonList()
        } else {
            provider.getPokemonList()
        }
    }
    
    func pokemonName(forIndexPath indexPath: IndexPath) -> String? {
        guard let list = pokemonList else { return nil }
        return list[indexPath.row].name
    }
    
    func numberOfPokemon(inSection section: Int) -> Int {
        guard let list = pokemonList else { return 0 }
        return list.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
}

extension PokemonPresenter: PokemonProviderFetchPokemonListDelegate {
    func didBeginFetchingPokemonList() {
        view?.beginLoading(withText: "Loading...")
    }
    
    func didFinishFetchingPokemonList() {
        view?.endLoading()
    }
    
    func didSuccessfullyFetchPokemonList(withList list: [PokemonIndex]) {
        pokemonList = list
        view?.refreshView()
    }
    
    func didFailToFetchPokemonList(withError error: Error) {
        view?.showError(withText: error.localizedDescription)
    }
}
