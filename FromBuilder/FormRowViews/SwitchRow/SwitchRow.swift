//
//  SwitchRow.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/30/22.
//

import Foundation
import Combine

final class SwitchRow: FormInputRowItem, ObservableObject {

    var type: FormItemType { .row }
    var id: UUID = .init()
    var key: String
    var rules: [Rule] = []

    @Published var text: String
    @Published var switchInOn: Bool
    @Published var disabled: Bool
    @Published var hasDivider: Bool

//    var value: FormAnyInputValue {
//        get {
//            .nested(
//                values: [
//                    "switch_value": .boolean(value: switchInOn),
//                    "switch_disabled": .boolean(value: disabled)
//                ]
//            )
//        } set {
//            self.objectWillChange.send()
//            guard let nested = newValue.nested else { return }
//            switchInOn = nested["switch_value"]?.boolean ?? false
//            disabled = nested["switch_disabled"]?.boolean ?? false
//        }
//    }
    
    func set(value: FormAnyInputValue, for selectorValue: Selector.SelectionStrategy?) {
        if let selectorValue {
            let helper = SelectorHelper(strategy: selectorValue, value: value)
            helper.setIf(on: self, keyPath: \.switchInOn, key: "switch_value") { $0.boolean }
            helper.setIf(on: self, keyPath: \.disabled, key: "switch_disabled") { $0.boolean }
        }
    }
    
    func getValues() -> FormAnyInputValue {
        .nested(
            values: [
                "switch_value": .boolean(value: switchInOn),
                "switch_disabled": .boolean(value: disabled)
            ]
        )
    }

    init(key: String, text: String, value: Bool = false, disabled: Bool = false) {
        self.key = key
        self.text = text
        self.disabled = disabled
        self.hasDivider = false
        self.switchInOn = value
    }
}

/*
 protocol PublishedProperty {
     var anyPublisher: AnyPublisher<Void, Never> { get }
 }

 protocol SettableProperty: PublishedProperty {

     mutating func set(value: FormAnyInputValue, for key: String)
 }

 @propertyWrapper
 struct BoolSettableProperty: SettableProperty {

     var wrappedValue: Bool {
         get {
             value.value
         } set {
             value.value = newValue
         }
     }

     private let value: CurrentValueSubject<Bool, Never>
     private let key: String
     
     var anyPublisher: AnyPublisher<Void, Never> { value.map { _ in () }.eraseToAnyPublisher() }
     var publisher: AnyPublisher<Bool, Never> { value.eraseToAnyPublisher() }
     
     var projectedValue: BoolSettableProperty { self }

     init(wrappedValue: Bool = false, key: String) {
         self.value = CurrentValueSubject<Bool, Never>(wrappedValue)
         self.key = key
     }

     mutating func set(value: FormAnyInputValue, for key: String) {
         if case .boolean(let boolValue) = value, self.key == key {
             self.wrappedValue = boolValue
         }
     }
 }

 protocol ObservableRow: ObservableObject where Self.ObjectWillChangePublisher == ObservableObjectPublisher {
     var cancelables: Set<AnyCancellable> { get set }
 }

 extension ObservableRow {
     func observeAllPublisher() {
         let mirror = Mirror(reflecting: self)
         cancelables = cancelables.union(mirror
             .children
             .compactMap { $0.value as? PublishedProperty }
             .map {
                 $0.anyPublisher.sink { [weak self] _ in
                     self?.objectWillChange.send()
                 }
             }
         )
     }
 }

 final class SwitchRow: FormInputRowItem, ObservableRow {
     
     var cancelables: Set<AnyCancellable>
     var type: FormItemType { .row }
     var id: UUID = .init()
     var key: String
     var rules: [Rule] = []

     @Published var text: String
     @BoolSettableProperty(key: "dsada") var switchInOn: Bool
     @Published var disabled: Bool
     @Published var hasDivider: Bool

     var value: FormAnyInputValue {
         get {
             .nested(
                 values: [
                     "switch_value": .boolean(value: switchInOn),
                     "switch_disabled": .boolean(value: disabled)
                 ]
             )
         } set {
             guard let nested = newValue.nested else { return }
 //            switchInOn = nested["switch_value"]?.boolean ?? false
             disabled = nested["switch_disabled"]?.boolean ?? false
         }
     }

     init(key: String, text: String, value: Bool = false, disabled: Bool = false) {
         self.key = key
         self.text = text
         self.disabled = disabled
         self.hasDivider = false
         self.cancelables = Set<AnyCancellable>()
         self.switchInOn = value
         self.observeAllPublisher()
     }
 }
 */
