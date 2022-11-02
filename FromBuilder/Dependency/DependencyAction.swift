//
//  DependencyAction.swift
//  FromBuilder
//
//  Created by Ali Moazenzadeh on 7/17/1401 AP.
//

import Foundation

enum DependencyActionType {
    case insert
    case remove
    case replace
    case modal
    case snack
    case addError
    case addWarning
    case setValue
    case unknown
}

protocol DependencyAction {

    associatedtype Payload: DependencyPayload
    
    init(payload: Payload)
    
    var payload: Payload { get set }
    
    func execute(list: inout [any FormItem])
}

struct SetValueDependencyAction: DependencyAction {
    var payload: SetValuePayload
    
    func execute(list: inout [any FormItem]) {
        list.modify(using: payload)
    }
}

struct AddErrorDependencyAction: DependencyAction {
    var payload: AddErrorPayload
    
    func execute(list: inout [any FormItem]) {
        list.insert(payload: payload)
    }
}

struct InsertDependencyAction: DependencyAction {
    var payload: InsertPayload
    
    func execute(list: inout [any FormItem]) {
        list.insert(payload: payload)
    }
}

struct RemoveDependencyAction: DependencyAction {
    var payload: RemovePayload
    
    func execute(list: inout [any FormItem]) {
        list.remove(using: payload)
    }
}

struct ReplaceDependencyAction: DependencyAction {
    var payload: ReplacePayload
    
    func execute(list: inout [any FormItem]) {
        list.replace(using: payload)
    }
}

extension Array where Element == (any FormItem) {

    mutating func insert(payload: InsertPayload) {
        guard var index = firstIndex(where: { $0.key == payload.selector.name }) else { return }
        index = payload.mode.modify(index: index)
        insert(contentsOf: payload.widgets, at: index)
    }

    mutating func insert(payload: AddErrorPayload) {
        guard var index = firstIndex(where: { $0.key == payload.selector.name }) else { return }
        index = payload.mode.modify(index: index)
        insert(payload.widget, at: index)
    }

    mutating func remove(using payload: RemovePayload) {
        guard var index = firstIndex(where: { $0.key == payload.selector.name }) else { return }
        index = payload.mode.modify(index: index)
        remove(at: index)
    }

    mutating func replace(using payload: ReplacePayload) {
        guard var index = firstIndex(where: { $0.key == payload.selector.name }) else { return }
        index = payload.mode.modify(index: index)
        self[index] = payload.widget
    }

    mutating func modify(using payload: SetValuePayload) {
        let parser = SelectionStrategyParser(strategy: payload.selector.value)
        guard var index = firstIndex(where: { $0.key == parser.rowKey }) else { return }
        index = payload.mode.modify(index: index)
        guard let valueRow = self[index] as? SettableRow else { return }
        valueRow.set(value: payload.value, for: payload.selector.value)
    }
}
