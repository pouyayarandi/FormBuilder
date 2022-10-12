//
//  Predicate.swift
//  FromBuilder
//
//  Created by Ali Moazenzadeh on 7/17/1401 AP.
//

import Foundation

protocol Predicatable {
    associatedtype Value: Comparable
    
    func evaluate(list: [any FormItem]) -> Bool
}

struct Predicate<Value: Comparable>: Predicatable {
    typealias Value = Value
    
    enum Operator {
        case and
        case or
        case not
        case equal
        case greaterThan
        case lowerThan
        case greaterThanEqual
        case lowerThanEqual
        case `in`
        case unknown
        
        func evaluate<Value: Comparable>(lhs: Value?, rhs: Value?) -> Bool {
            guard let lhs = lhs, let rhs = rhs else { return false }
            switch self {
            case .and: return (lhs as? Bool ?? false) && (rhs as? Bool ?? false)
            case .or: return (lhs as? Bool ?? false) || (rhs as? Bool ?? false)
            case .not: return lhs != rhs
            case .equal: return lhs == rhs
            case .greaterThan: return lhs > rhs
            case .lowerThan: return lhs < rhs
            case .greaterThanEqual: return lhs >= rhs
            case .lowerThanEqual: return lhs <= rhs
            default: return false
            }
        }
    }
        
    let `operator`: Operator
    let left: Operand<Value>
    let right: Operand<Value>
    
    func evaluate(list: [any FormItem]) -> Bool {
        return `operator`.evaluate(lhs: left.finalValue(list), rhs: right.finalValue(list))
    }
}
