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
        // Do any additional setup after loading the view, typically from a nib.
        presenter = PokemonPresenter()
        presenter.view = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "pokecell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.fetchPokemonList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfPokemon()
    }
    
}

extension PokemonController: PokemonPresenterView {
    func beginLoading(withText text: String) {
        self.loader = UIAlertController(title: "Loading...", message: "Loading your pokemon!", preferredStyle: .alert)
        self.present(self.loader!, animated: false)
    }
    
    func endLoading() {
        self.loader?.dismiss(animated: true, completion: nil)
    }
    
    func showError(withText text: String) {
        self.loader = UIAlertController(title: "Error!", message: "The app wont work now, sorry. You can come back another time.", preferredStyle: .alert)
        self.present(self.loader!, animated: false)
    }
    
    func refreshView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

