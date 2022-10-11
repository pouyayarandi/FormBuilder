//
//  FormInputRowItem.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/11/22.
//

import Foundation
import Combine

protocol FormInputRowItem: FormRowItem, ObservableObject where ObjectWillChangePublisher == ObservableObjectPublisher {

    associatedtype Value: FormAnyInputValue

    var valueChangePublisher: AnyPublisher<Any, Never> { get }
    
    var rules: [Rule] { get set }

    var value: Value { get set }
}

extension FormInputRowItem {

    var valueChangePublisher: AnyPublisher<Any, Never> {
        self.objectWillChange.map { self.value as Any }.eraseToAnyPublisher()
    }
    
    public func `set`(_ value: Any) {
        self.value = value as! Value
        objectWillChange.send()
    }

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
