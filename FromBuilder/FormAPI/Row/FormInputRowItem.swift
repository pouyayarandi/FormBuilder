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
protocol FormInputRowItem: FormRowItem {

    var value: FormAnyInputValue { get }
}

extension FormInputRowItem {
    var keyValuePair: KeyValuePairs {
        [key: value]
    }
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
