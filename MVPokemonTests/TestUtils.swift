//
//  TestUtils.swift
//  MVPokemonTests
//
//  Created by Sam Jarman on 20/08/18.
//  Copyright © 2018 Sam Jarman. All rights reserved.
//

import Foundation

class Recorder {
    private struct Method {
        let name: String
        let args: [String]
    }
    
    private var methodsCalled: [Method] = []
    
    func record(methodName: String, args: [String]) {
        methodsCalled.append(Method(name: methodName, args: args))
    }
    
    func wasCalled(methodName: String, args: [String]) -> Bool {
        return methodsCalled.contains(where: { (method) -> Bool in
            return method.name == methodName && method.args == args
        })
    }
}

class TestsHelper {
    static func JSONData(fromFile file: String) -> Data? {
        do {
            let testBundle = Bundle(for: TestsHelper.self)// TODO: Fix this
            let fileURL = testBundle.url(forResource: file, withExtension: "json")
            let text = try String(contentsOf: fileURL!, encoding: .utf8)
            return text.data(using: .utf8)
        }
        catch {
            return nil
        }
    }
}
