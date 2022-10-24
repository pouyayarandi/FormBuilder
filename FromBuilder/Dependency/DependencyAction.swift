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
}
