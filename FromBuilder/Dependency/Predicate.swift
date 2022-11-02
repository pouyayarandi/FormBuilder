//
//  Predicate.swift
//  FromBuilder
//
//  Created by Ali Moazenzadeh on 7/17/1401 AP.
//

import Foundation

protocol Predicatable {
    func evaluate(list: [any FormItem]) -> Bool
}

struct Predicate: Predicatable {
    
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
        
        func evaluate(lhs: FormAnyInputValue?, rhs: FormAnyInputValue?) -> Bool {
            guard let lhs = lhs, let rhs = rhs else { return false }
            switch self {
            case .and: return (lhs.boolean ?? false) && (rhs.boolean ?? false)
            case .or: return (lhs.boolean ?? false) || (rhs.boolean ?? false)
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
        
    let left: Operand
    let `operator`: Operator
    let right: Operand
    
    func evaluate(list: [any FormItem]) -> Bool {
        return `operator`.evaluate(lhs: left.finalValue(list), rhs: right.finalValue(list))
    }
}

// binary
func ==(lhs: Operand, rhs: Operand) -> Predicate {
    Predicate(left: lhs, operator: .equal, right: rhs)
}

func <(lhs: Operand, rhs: Operand) -> Predicate {
    Predicate(left: lhs, operator: .lowerThan, right: rhs)
}

func >(lhs: Operand, rhs: Operand) -> Predicate {
    Predicate(left: lhs, operator: .greaterThan, right: rhs)
}

func <=(lhs: Operand, rhs: Operand) -> Predicate {
    Predicate(left: lhs, operator: .lowerThanEqual, right: rhs)
}

func >=(lhs: Operand, rhs: Operand) -> Predicate {
    Predicate(left: lhs, operator: .greaterThanEqual, right: rhs)
}

// bitwise

func &(lhs: Operand, rhs: Operand) -> Predicate {
    Predicate(left: lhs, operator: .and, right: rhs)
}

func |(lhs: Operand, rhs: Operand) -> Predicate {
    Predicate(left: lhs, operator: .or, right: rhs)
}

infix operator ! : DefaultPrecedence
func !(lhs: Operand, rhs: Operand) -> Predicate {
    Predicate(left: lhs, operator: .not, right: rhs)
}
