//
//  PokemonProviderTests.swift
//  MVPokemonTests
//
//  Created by Sam Jarman on 20/08/18.
//  Copyright © 2018 Sam Jarman. All rights reserved.
//

import XCTest
@testable import MVPokemon

class PokemonProviderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testGetPokemonList() {
        // Setup
        let session = URLSessionMock()
        let data = TestsHelper.JSONData(fromFile: "mockList")
        session.data = data
        let delegate = MockPokemonProviderFetchPokemonListDelegate()
        let provider = PokemonProvider()
        provider.listDelegate = delegate
        
        // Run
        provider.getPokemonList(session: session)
        
        // Verify
        
        XCTAssertTrue(delegate.recorder.wasCalled(methodName: "didBeginFetchingPokemonList", args: []))
        XCTAssertTrue(delegate.recorder.wasCalled(methodName: "didFinishFetchingPokemonList", args: []))
        XCTAssertTrue(delegate.recorder.wasCalled(methodName: "didSuccessfullyFetchPokemonList", args: ["bulbasaur", "ivysaur", "venusaur"]))
        XCTAssertFalse(delegate.recorder.wasCalled(methodName: "didFailToFetchPokemonList", args: ["Some error"]))
    }
}

// Code from https://medium.com/@johnsundell/mocking-in-swift-56a913ee7484

// We create a partial mock by subclassing the original class
private class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}

private class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.
    var data: Data?
    var error: Error?
    override func dataTask(
        with url: URL,
        completionHandler: @escaping CompletionHandler
        ) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
}

private class MockPokemonProviderFetchPokemonListDelegate: PokemonProviderFetchPokemonListDelegate {
    let recorder = Recorder()

    
    func didBeginFetchingPokemonList() {
        recorder.record(methodName: "didBeginFetchingPokemonList", args: [])
    }
    
    func didFinishFetchingPokemonList() {
        recorder.record(methodName: "didFinishFetchingPokemonList", args: [])
    }
    
    func didSuccessfullyFetchPokemonList(withList list: [PokemonIndex]) {
        let args = list.map { (pokemon) -> String in
            return pokemon.name!
        }
        
        recorder.record(methodName: "didSuccessfullyFetchPokemonList", args:args)
    }
    
    func didFailToFetchPokemonList(withError error: Error) {
        recorder.record(methodName: "didFailToFetchPokemonList", args: [error.localizedDescription])
    }
}
