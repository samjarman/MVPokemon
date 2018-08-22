//
//  PokemonPresenterTests.swift
//  MVPokemonTests
//
//  Created by Sam Jarman on 20/08/18.
//  Copyright © 2018 Sam Jarman. All rights reserved.
//

import XCTest
@testable import MVPokemon

class PokemonPresenterTests: XCTestCase {
    var presenter: PokemonPresenter! = nil
    
    override func setUp() {
        super.setUp()
        self.presenter = PokemonPresenter()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchPokemonList_noError() {
        // Setup
        let provider = MockProvider()
        let mockView = MockView()
        presenter.view = mockView
        // Run
        presenter.fetchPokemonList(provider)
        
        //Verify
        XCTAssertTrue(mockView.recorder.wasCalled(methodName: "beginLoading", args: ["Loading..."]))
        XCTAssertTrue(mockView.recorder.wasCalled(methodName: "endLoading", args: []))
        XCTAssertTrue(mockView.recorder.wasCalled(methodName: "refreshView", args: []))
    }
    
    func testFetchPokemonList_Error() {
        // Setup
        let provider = MockProvider()
        provider.pokemonListError = NSError(domain: "POKEMON", code: 500, userInfo: [NSLocalizedDescriptionKey: "Test Error"])
        let mockView = MockView()
        presenter.view = mockView
        // Run
        presenter.fetchPokemonList(provider)
        
        //Verify
        XCTAssertTrue(mockView.recorder.wasCalled(methodName: "beginLoading", args: ["Loading..."]))
        XCTAssertTrue(mockView.recorder.wasCalled(methodName: "endLoading", args: []))
        XCTAssertTrue(mockView.recorder.wasCalled(methodName: "showError", args: ["Test Error"]))
    }
    
    func testPokemonName_before_load() {
        // Setup
        let indexPath = IndexPath(row: 0, section: 0)
        
        // Run
        let result = presenter.pokemonName(forIndexPath: indexPath)

        // Verify
        XCTAssertEqual(result, nil)
    }
    
    func testPokemonName() {
        // Setup
        let indexPath1 = IndexPath(row: 0, section: 0)
        let indexPath2 = IndexPath(row: 1, section: 0)
        let indexPath3 = IndexPath(row: 2, section: 0)
        let provider = MockProvider()
        presenter.fetchPokemonList(provider)

        // Run
        let result1 = presenter.pokemonName(forIndexPath: indexPath1)
        let result2 = presenter.pokemonName(forIndexPath: indexPath2)
        let result3 = presenter.pokemonName(forIndexPath: indexPath3)

        // Verify
        XCTAssertEqual(result1, "Test 1")
        XCTAssertEqual(result2, "Test 2")
        XCTAssertEqual(result3, "Test 3")
    }
    
    func testNumberOfPokemon_before_load() {
        // Run
        let result = presenter.numberOfPokemon()
        
        // Verify
        XCTAssertEqual(result, 0)
    }
    
    func testNumberOfPokemon() {
        // Setup
        let provider = MockProvider()
        presenter.fetchPokemonList(provider)

        // Run
        let result = presenter.numberOfPokemon()
        
        // Verify
        XCTAssertEqual(result, 3)
    }
}

class MockProvider: PokemonProvider {
    
    let pokemon = [PokemonIndex(name: "Test 1", detailsURL: URL(string: "testing.com/pokemon/1")),
                   PokemonIndex(name: "Test 2", detailsURL: URL(string: "testing.com/pokemon/2")),
                   PokemonIndex(name: "Test 3", detailsURL: URL(string: "testing.com/pokemon/3"))]
    
    var pokemonListError: Error? = nil
    
    override func getPokemonList(session: URLSession = .shared) {
        listDelegate?.didBeginFetchingPokemonList()
        listDelegate?.didFinishFetchingPokemonList()
        if let error = pokemonListError {
            listDelegate?.didFailToFetchPokemonList(withError: error)
        } else {
            listDelegate?.didSuccessfullyFetchPokemonList(withList: pokemon)
        }
    }
}

class MockView: PokemonPresenterView {
    let recorder = Recorder()
    func beginLoading(withText text: String) {
        recorder.record(methodName: "beginLoading", args: [text])
    }
    
    func endLoading() {
        recorder.record(methodName: "endLoading", args: [])
    }
    
    func showError(withText text: String) {
        recorder.record(methodName: "showError", args: [text])
    }
    
    func refreshView() {
        recorder.record(methodName: "refreshView", args: [])
    }
}
