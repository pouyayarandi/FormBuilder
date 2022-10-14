//
//  Selector.swift
//  FromBuilder
//
//  Created by Ali Moazenzadeh on 7/17/1401 AP.
//

import Foundation

struct Selector {
    
    enum Mode {
        case before
        case at
        case after
        
        func modify(index: Int) -> Int {
            switch self {
            case .before: return max(0, index - 1)
            case .at: return index
            case .after: return index + 1
            }
        }
    }
    
    enum SelectorValue {
        case index(Int)
        case key(String)
    }

    var mode: Mode
    var value: SelectorValue
    
    var index: Int? {
        get {
            guard case .index(let int) = value else {
                return nil
            }
            return int
        } set {
            guard let newValue = newValue else { return }
            value = .index(newValue)
        }
    }
    
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

    func select(_ list: [any FormItem]) -> FormItem? {
        guard var index = index ?? list.firstIndex(where: { $0.key == name }) else { return nil }
        index = mode.modify(index: index)
        return list[index]
    }
}
