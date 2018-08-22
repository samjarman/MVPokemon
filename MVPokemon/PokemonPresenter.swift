//
//  PokemonPresenter.swift
//  MVPokemon
//
//  Created by Sam Jarman on 15/08/18.
//  Copyright © 2018 Sam Jarman. All rights reserved.
//

import UIKit

protocol PokemonPresenterView {
    func beginLoading(withText text: String)
    func endLoading()
    func showError(withText text: String)
    func refreshView()
}

class PokemonPresenter {
    var view: PokemonPresenterView?
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
    
    func numberOfPokemon() -> Int {
        guard let list = pokemonList else { return 0 }
        return list.count
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
