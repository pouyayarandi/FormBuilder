//
//  Operand.swift
//  FromBuilder
//
//  Created by Ali Moazenzadeh on 7/17/1401 AP.
//

import Foundation

struct Operand {
    enum OperandValue {
        case value(FormAnyInputValue)
        case selector(Selector)
        case predicate(any Predicatable)
    }

    var operandValue: OperandValue

    // this method should be fixed, in order to support KeyValuePairs for aech row
    func finalValue(_ list: [any FormItem]) -> FormAnyInputValue? {
        if let value {
            return value
        } else if let selector {
            return (selector.select(list) as? (any FormInputRowItem))?.value
        } else if let predicate {
            return .boolean(value: predicate.evaluate(list: list))
        }

        return nil
    }
    
    var value: FormAnyInputValue? {
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
