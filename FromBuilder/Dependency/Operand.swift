//
//  Operand.swift
//  FromBuilder
//
//  Created by Ali Moazenzadeh on 7/17/1401 AP.
//

import Foundation

struct Operand<Value: Comparable> {
    enum OperandValue {
        case value(Value)
        case selector(Selector)
        case predicate(any Predicatable)
    }

    var operandValue: OperandValue

    // this method should be fixed, in order to support KeyValuePairs for aech row
    func finalValue(_ list: [any FormItem]) -> Value? {
        if let value {
            return value
        } else if let selector {
            return nil
//            return (selector.select(list) as? any FormInputRowItem)?.anyFormInputValue as? Value
        } else if let predicate {
            return predicate.evaluate(list: list) as? Value
        }

        return nil
    }
    
    var value: Value? {
        get {
            guard case .value(let val) = operandValue else {
                return nil
            }
            return val
        } set {
            guard let newValue = newValue else { return }
            operandValue = .value(newValue)
        }
    }
    
    var selector: Selector? {
        get {
            guard case .selector(let sel) = operandValue else {
                return nil
            }
            return sel
        } set {
            guard let newValue = newValue else { return }
            operandValue = .selector(newValue)
        }
    }
    
    var predicate: (any Predicatable)? {
        get {
            guard case .predicate(let pre) = operandValue else {
                return nil
            }
            return pre
        } set {
            guard let newValue = newValue else { return }
            operandValue = .predicate(newValue)
        }
    }
}
