//
//  Models.swift
//  FromBuilder
//
//  Created by Pouya on 7/12/1401 AP.
//

import Foundation

struct MinLengthRule: Rule {
    
    var minLength: Int

    func validate(_ value: any FormAnyInputValue) -> RuleAction {
        guard let value: String = value.asValue() else { return .noAction }
        return value.count >= minLength ? .noAction : .showError(message: "Value should have at least \(minLength) characters")
    }
    
    var errorMessage: String {
        "Value should have at least \(minLength) characters"
    }
}

struct MaxLengthRule: Rule {
    var maxLength: Int

    func validate(_ value: any FormAnyInputValue) -> RuleAction {
        guard let value: String = value.asValue() else { return .noAction }
        return value.count < maxLength ? .noAction : .showError(message: "Value should have at most \(maxLength) characters")
    }
    
    var errorMessage: String {
        "Value should have at most \(maxLength) characters"
    }
}

protocol Dependable {
    var dependency: Dependency? { get set }
}
