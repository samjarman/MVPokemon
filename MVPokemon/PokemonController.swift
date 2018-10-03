//
//  PokemonController.swift
//  MVPokemon
//
//  Created by Sam Jarman on 15/08/18.
//  Copyright © 2018 Sam Jarman. All rights reserved.
//

import UIKit

class PokemonController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var loader: UIAlertController? = nil
    
    var presenter: PokemonPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = PokemonPresenter()
        presenter.view = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "pokecell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchPokemonList()
    }
}

extension PokemonController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pokecell") else { fatalError("Unable to dequeue table view cell")}
        cell.textLabel?.text = presenter.pokemonName(forIndexPath: indexPath)?.capitalized
        return cell
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfPokemon(inSection: section)
    }
    
}

extension PokemonController: PokemonPresenterView {
    func beginLoading(withText text: String) {
        DispatchQueue.main.async {
            self.loader = UIAlertController(title: "Loading...", message: "Loading your pokemon!", preferredStyle: .alert)
            self.present(self.loader!, animated: true)
        }
    }
    
    func endLoading() {
        DispatchQueue.main.async {
            guard let loader = self.loader else { return }
            loader.dismiss(animated: true, completion: nil)
        }
    }
    
    func showError(withText text: String) {
        print(text)
    }
    
    func refreshView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

