//
//  FormInputRowItem.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/11/22.
//

import Foundation
import Combine
import SwiftUI

/// we do not need `ObservableObject where ObjectWillChangePublisher == ObservableObjectPublisher`,
/// because we are using PreferenceKey to collect data from children whenever each view is rerendered
protocol FormInputRowItem: FormRowItem, SettableRow, GettableRow {

//    var value: FormAnyInputValue { get set }
}

extension FormInputRowItem {

    var keyValuePair: KeyValuePairs {
        [key: getValues()]
    }
}

protocol SettableRow {
    func set(value: FormAnyInputValue, for selectorValue: Selector.SelectionStrategy?)
}

protocol GettableRow {
    func getValues() -> FormAnyInputValue
}

/// all row has an `KeyValuePair` to store their final datas
/// This type is modeled after JSON's representation and supported data types.
typealias KeyValuePairs = [String: FormAnyInputValue]

enum FormAnyInputValue: Equatable, Codable {

    case int(value: Int)
    case double(value: Double)
    case string(value: String)
    case boolean(value: Bool)

    /// also known as `object` in JSON
    case nested(values: KeyValuePairs)

    var value: Any {
        switch self {
        case .int(let value): return value
        case .double(let value): return value
        case .string(let value): return value
        case .boolean(let value): return value
        case .nested(let values): return values
        }
    }
}

extension FormAnyInputValue {
    
    var nested: KeyValuePairs? {
        switch self {
        case .nested(let values):
            return values
        default:
            return nil
        }
    }
    
    var boolean: Bool? {
        switch self {
        case .boolean(let value):
            return value
        default:
            return nil
        }
    }
    
    var int: Int? {
        switch self {
        case .int(let value):
            return value
        default:
            return nil
        }
    }
    
    var double: Double? {
        switch self {
        case .double(let value):
            return value
        default:
            return nil
        }
    }
    
    var string: String? {
        switch self {
        case .string(let value):
            return value
        default:
            return nil
        }
    }
}

extension FormAnyInputValue: Comparable {
    static func < (lhs: FormAnyInputValue, rhs: FormAnyInputValue) -> Bool {
        switch (lhs, rhs) {
        case (.int(value: let left), .int(value: let right)): return left < right
        case (.double(value: let left), .double(value: let right)): return left < right
        default: return false
        }
    }
    
    static func <= (lhs: FormAnyInputValue, rhs: FormAnyInputValue) -> Bool {
        switch (lhs, rhs) {
        case (.int(value: let left), .int(value: let right)): return left <= right
        case (.double(value: let left), .double(value: let right)): return left <= right
        default: return false
        }
    }
    
    static func > (lhs: FormAnyInputValue, rhs: FormAnyInputValue) -> Bool {
        switch (lhs, rhs) {
        case (.int(value: let left), .int(value: let right)): return left > right
        case (.double(value: let left), .double(value: let right)): return left > right
        default: return false
        }
    }
    
    static func >= (lhs: FormAnyInputValue, rhs: FormAnyInputValue) -> Bool {
        switch (lhs, rhs) {
        case (.int(value: let left), .int(value: let right)): return left >= right
        case (.double(value: let left), .double(value: let right)): return left >= right
        default: return false
        }
    }
}
