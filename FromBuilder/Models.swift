//
//  Models.swift
//  FromBuilder
//
//  Created by Pouya on 7/12/1401 AP.
//

import Foundation

struct MinLengthRule: Rule {
    
    var minLength: Int

    func validate(_ value: FormAnyInputValue) -> RuleAction {
        guard case let .string(stringValue) = value else { return .noAction }
        return stringValue.count >= minLength ? .noAction : .showError(message: "Value should have at least \(minLength) characters")
    }
    
    var errorMessage: String {
        "Value should have at least \(minLength) characters"
    }
}

struct MaxLengthRule: Rule {
    var maxLength: Int


    func validate(_ value: FormAnyInputValue) -> RuleAction {
        guard case let .string(stringValue) = value else { return .noAction }
        return stringValue.count < maxLength ? .noAction : .showError(message: "Value should have at most \(maxLength) characters")
    }
    
    var errorMessage: String {
        "Value should have at most \(maxLength) characters"
    }
}

protocol Dependable {
    var dependency: Dependency? { get set }
}
