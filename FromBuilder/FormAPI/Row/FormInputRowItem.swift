//
//  FormInputRowItem.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/11/22.
//

import Foundation

protocol FormInputRowItem: FormRowItem {

    associatedtype Value: FormAnyInputValue

    var rules: [Rule] { get set }

    var value: Value { get set }
}

extension FormInputRowItem {

    var anyFormInputValue: FormAnyInputValue {
        self.value
    }
}

protocol FormAnyInputValue: Codable {}

extension FormAnyInputValue {

    func asValue<T: Codable>() -> T? {
        self as? T
    }
}

extension String: FormAnyInputValue {}
extension Bool: FormAnyInputValue {}
