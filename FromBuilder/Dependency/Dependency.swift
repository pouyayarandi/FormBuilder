//
//  Dependency.swift
//  FromBuilder
//
//  Created by Ali Moazenzadeh on 7/17/1401 AP.
//

import Foundation
import Combine

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

protocol DependencyPayload {
    var selector: Selector { get set }
    var mode: Mode { get set }
}

struct Dependency {

    let predicate: any Predicatable
    let actions: [any DependencyAction]

    init(predicate: Predicatable, actions: [any DependencyAction]) {
        self.predicate = predicate
        self.actions = actions
    }

    init(predicate: Predicatable, @ActionBuilder actions: () -> [any DependencyAction]) {
        self.predicate = predicate
        self.actions = actions()
    }

    func execute(list: [any FormItem]) -> [any FormItem] {
        var list = list
        if predicate.evaluate(list: list) {
            actions.forEach { action in
                action.execute(list: &list)
            }
        }
        return list
    }
    
    @resultBuilder
    struct ActionBuilder {
        static func buildBlock(_ components: (any DependencyAction)...) -> [any DependencyAction] {
            components
        }
    }
}


#if DEBUG
let leftOperand = Operand(operandValue: .selector(Selector(value: .key("firstname"))))
let rightOperand = Operand(operandValue: .value(.string(value: "Test12")))
let predicate = Predicate(left: leftOperand, operator: .equal, right: rightOperand)

let widgetsToInsert = [TitleRow(key: "success", title: "Success")]
let insertPayload = InsertPayload(mode: .at, selector: .init(value: .key("switch")), widgets: widgetsToInsert)
let action = InsertDependencyAction(payload: insertPayload)
let testDependency = Dependency(predicate: predicate, actions: [action])

let dependencies: [Dependency] = [
    .init(
        predicate: Predicate(
            left: .init(operandValue: .selector(.init(value: .key("switch")))), operator: .equal,
            right: .init(operandValue: .value(.boolean(value: true)))),
        actions: [
            InsertDependencyAction(
                payload: .init(
                    mode: .after,
                    selector: .init(value: .key("switch")),
                    widgets: [
                        SubtitleRow(key: "success_l", text: "A little success"),
                        TextFieldRow(key: "hello")
                    ]
                )
            )
        ]
    ),
    
    .init(
        predicate: Predicate(
            left: .init(operandValue: .selector(.init(value: .keychain("firstname.regex")))), operator: .equal,
            right: .init(operandValue: .value(.boolean(value: true)))),
        actions: [
            InsertDependencyAction(
                payload: .init(
                    mode: .before,
                    selector: .init(value: .key("firstname")),
                    widgets: [
                        TitleRow(key: "success", title: "Success")
                    ]
                )
            ),
            ReplaceDependencyAction(
                payload: .init(
                    mode: .at,
                    selector: .init(value: .key("lastname")),
                    widget: SwitchRow(key: "switch2", text: "There is no textfield", value: true)
                )
            )
        ]
    )
]
#endif
