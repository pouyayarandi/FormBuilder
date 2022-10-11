//
//  Dependency.swift
//  FromBuilder
//
//  Created by Ali Moazenzadeh on 7/17/1401 AP.
//

import Foundation
import Combine

protocol DependencyPayload {
    var selector: Selector { get set }
}

class Dependency {
    let predicate: any Predicatable
    let actions: [any DependencyAction]
    
    init(predicate: any Predicatable, actions: [any DependencyAction]) {
        self.predicate = predicate
        self.actions = actions
    }
    
    func execute(list: inout [any FormItem]) {
        if predicate.evaluate() {
            actions.forEach { action in
                action.execute(list: &list)
            }
        }
    }
}


#if DEBUG
let leftOperand = Operand<String>(operandValue: .selector(Selector(mode: .at, value: .key("firstname"))))
let rightOperand = Operand<String>(operandValue: .value("test12"))
let predicate = Predicate(operator: .equal, left: leftOperand, right: rightOperand)

let widgetsToInsert = [TitleRow(key: "success", title: "Success")]
let insertPayload = InsertPayload(selector: .init(mode: .after, value: .key("switch")), widgets: widgetsToInsert)
let action = InsertDependencyAction(payload: insertPayload)
let testDependency = Dependency(predicate: predicate, actions: [action])
#endif
