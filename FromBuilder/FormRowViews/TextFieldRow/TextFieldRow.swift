//
//  TextFieldRow.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/30/22.
//

import Foundation
import Combine

class TextFieldRow: FormInputRowItem, ObservableObject {

    var type: FormItemType { .row }
    
    var id: UUID = UUID()
    var key: String
    var rules: [Rule] = []
    
    @Published var placeholder: String?
    @Published var hasDivider: Bool

    // use specific PW for each value in row
    
    @Published var textFieldText: String
    
    var value: FormAnyInputValue {
        get {
            .double(value: Double(textFieldText) ?? 0.0)
        } set {
            switch newValue {
            case let .double(value): textFieldText = "\(value)"
            case let .int(value): textFieldText = "\(value)"
            case let .string(value): textFieldText = "\(value)"
            case let .boolean(value): textFieldText = "\(value)"
            default: break
            }
        }
    }
    
    func set(value: FormAnyInputValue, for selectorValue: Selector.SelectionStrategy?) {
        if let selectorValue {
            let helper = SelectorHelper(strategy: selectorValue, value: value)
            helper.setIf(on: self, keyPath: \.textFieldText) { $0.string }
        }
    }
    
    func getValues() -> FormAnyInputValue {
        .double(value: Double(textFieldText) ?? 0.0)
    }

    var error: AnyPublisher<[String], Never> {
        $textFieldText.map { [weak self] value in
            guard let strongSelf = self else { return [] }
            return strongSelf
                .rules
                .reduce(into: [String?]()) { partialResult, rule in
                    let message = rule.validate(strongSelf.value).errorMessage
                    partialResult.append(message)
                }
                .compactMap { $0 }
        }.eraseToAnyPublisher()
    }
    
    init(key: String, rules: [Rule] = [], value: String = "") {
        self.key = key
        self.rules = rules
        self.placeholder = "Enter..."
        self.hasDivider = false
        self.textFieldText = value
    }
}
