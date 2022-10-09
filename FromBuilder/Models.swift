//
//  Models.swift
//  FromBuilder
//
//  Created by Pouya on 7/12/1401 AP.
//

import Foundation

protocol Rule {
    var errorMessage: String { get }
    func validate(_ value: Any) -> Bool
}

struct MinLengthRule: Rule {
    var minLength: Int
    
    func validate(_ value: Any) -> Bool {
        guard let value = value as? String else { return false }
        return value.count >= minLength
    }
    
    var errorMessage: String {
        "Value should have at least \(minLength) characters"
    }
}

struct MaxLengthRule: Rule {
    var maxLength: Int
    
    func validate(_ value: Any) -> Bool {
        guard let value = value as? String else { return false }
        return value.count < maxLength
    }
    
    var errorMessage: String {
        "Value should have at most \(maxLength) characters"
    }
}

protocol Dependable {
    var dependency: Dependency? { get set }
}

protocol FormItem {
    var id: UUID { get }
    var key: String { get set }
    var hasDivider: Bool { get set }
}

protocol FormInputItem: FormItem {
    associatedtype Value
    var rules: [Rule] { get set }
    var value: Value { get set }
}

extension FormInputItem {
    var anyValue: Any {
        value as Any
    }
}
