//
//  Selector.swift
//  FromBuilder
//
//  Created by Ali Moazenzadeh on 7/17/1401 AP.
//

import Foundation

struct Selector {
    
//    enum Mode {
//        case before
//        case at
//        case after
//
//        func modify(key: String) -> Int {
//            switch self {
//            case .before: return max(0, index - 1)
//            case .at: return index
//            case .after: return index + 1
//            }
//        }
//    }
    
    enum SelectorValue {
        /*
         selecting by index is not safe and is not guranteed to be the same with each response
         as each dependency can be applied to list.
         more explanation is available on slite doc.
         
         case index(Int)
         */
        case key(String)
        case keychain(String)
    }

    /*
     Mode is also removed as the index was removed, Mode can only be used on `ActionPayload`
     */
//    var mode: Mode
    var value: SelectorValue

//    var index: Int? {
//        get {
//            guard case .index(let int) = value else {
//                return nil
//            }
//            return int
//        } set {
//            guard let newValue = newValue else { return }
//            value = .index(newValue)
//        }
//    }
    
    var name: String? {
        get {
            guard case .key(let string) = value else {
                return nil
            }
            return string
        } set {
            guard let newValue = newValue else { return }
            value = .key(newValue)
        }
    }

    func select(_ list: [any FormItem]) -> FormAnyInputValue? {
        switch value {
        case .key(let key):
            return extractValue(from: list, with: key)
        case .keychain(let array):
            return extractValue(from: list, by: array.split(separator: ".").map { String($0) })
        }
    }

    private func extractValue(from list: [any FormItem], with key: String) -> FormAnyInputValue? {
        let formInput = self.flattenInputRows(in: list).first(where: { $0.key == key })
        return formInput?.value
    }

    private func extractValue(from list: [any FormItem], by keyChain: [String]) -> FormAnyInputValue? {
        precondition(keyChain.isEmpty == false && keyChain.count > 1)

        var keyChain = keyChain
        let rowKey = keyChain.removeFirst() // find the rows first

        guard let formInput = self.flattenInputRows(in: list).first(where: { $0.key == rowKey }) else { return nil }
        switch formInput.value {
        case .int, .double, .string, .boolean:
            fatalError("selection with keychain is only acceptable on rows which has several keys")
        case .nested(let values):
            return searchRecursivley(on: values, keyChain: &keyChain)
        }
        
    }
    
    private func flattenInputRows(in list: [any FormItem]) -> [any FormInputRowItem] {
        let sectionInputRowItems = list.compactMap { $0 as? FormSectionItem }.flatMap { $0.rowItems }.compactMap { $0 as? FormInputRowItem }
        let inputItems = list.compactMap { $0 as? FormInputRowItem }
        return sectionInputRowItems + inputItems
    }

    private func searchRecursivley(on json: [String: FormAnyInputValue], keyChain: inout [String]) -> FormAnyInputValue? {
        let key = keyChain.removeFirst()
        if let value = json[key] {
            switch value {
            case .int where keyChain.isEmpty == true,
                    .double where keyChain.isEmpty == true,
                    .string where keyChain.isEmpty == true,
                    .boolean where keyChain.isEmpty == true:
                return value
            case .nested(let values):
                return searchRecursivley(on: values, keyChain: &keyChain)
            default: fatalError("No value Found")
            }
        } else {
            fatalError("No value Found with \(key) on \(json)")
        }
    }
}
