//
//  TransformableDependencies.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/30/22.
//

import Foundation

#if DEBUG

// rent max min
func rentMinValue() -> Dependency {
    let predicate = Operand(operandValue: .selector(Selector(value: .key("rent")))) < Operand(operandValue: .value(.double(value: 100)))
    return Dependency(predicate: predicate) {
        AddErrorDependencyAction(
            payload: .init(mode: .after, selector: Selector(value: .key("rent")), messages: ["less than 100 is free!! seriously?"])
        )
    }
}

func rentMaxValue() -> Dependency {
    let predicate = Operand(operandValue: .selector(Selector(value: .key("rent")))) >= Operand(operandValue: .value(.double(value: 1200)))
    return Dependency(predicate: predicate) {
        AddErrorDependencyAction(
            payload: .init(mode: .after, selector: Selector(value: .key("rent")), messages: ["Bro decrease rent we are in iran"])
        )
    }
}

// credit max min
func creditMinValue() -> Dependency {
    let predicate = Operand(operandValue: .selector(Selector(value: .key("credit")))) < Operand(operandValue: .value(.double(value: 1000)))
    return Dependency(predicate: predicate) {
        AddErrorDependencyAction(
            payload: .init(mode: .after, selector: Selector(value: .key("credit")), messages: ["less than 100 is free!! seriously?"])
        )
    }
}

func creditMaxValue() -> Dependency {
    let predicate = Operand(operandValue: .selector(Selector(value: .key("credit")))) >= Operand(operandValue: .value(.double(value: 12000)))
    return Dependency(predicate: predicate) {
        AddErrorDependencyAction(
            payload: .init(mode: .after, selector: Selector(value: .key("credit")), messages: ["Bro decrease credit we are in iran"])
        )
    }
}

// switch

func enableSwitch() -> Dependency {
    let predicate = Operand(operandValue: .selector(Selector(value: .key("credit")))) > Operand(operandValue: .value(.double(value: 500)))
    return Dependency(predicate: predicate) {
        SetValueDependencyAction(
            payload: SetValuePayload(
                mode: .at,
                selector: Selector(value: .key("transform_switch")),
                value: .nested(
                    values: [
                        "switch_value": .boolean(value: false),
                        "switch_disabled": .boolean(value: false)
                    ]
                )
            )
        )
    }
}

func disableSwitch() -> Dependency {
    let predicate = Operand(operandValue: .selector(Selector(value: .key("credit")))) < Operand(operandValue: .value(.double(value: 500)))
    return Dependency(predicate: predicate) {
        SetValueDependencyAction(
            payload: SetValuePayload(
                mode: .at,
                selector: Selector(value: .key("transform_switch")),
                value: .nested(
                    values: [
                        "switch_disabled": .boolean(value: true)
                    ]
                )
            )
        )
    }
}

//let leftOperand = Operand(operandValue: .selector(Selector(value: .key("firstname"))))
//let rightOperand = Operand(operandValue: .value(.string(value: "Test12")))
//let predicate = Predicate(operator: .equal, left: leftOperand, right: rightOperand)
//
//let widgetsToInsert = [TitleRow(key: "success", title: "Success")]
//let insertPayload = InsertPayload(mode: .at, selector: .init(value: .key("switch")), widgets: widgetsToInsert)
//let action = InsertDependencyAction(payload: insertPayload)
//let testDependency = Dependency(predicate: predicate, actions: [action])
//
//let dependencies: [Dependency] = [
//    .init(
//        predicate: Predicate(
//            operator: .equal,
//            left: .init(operandValue: .selector(.init(value: .key("switch")))),
//            right: .init(operandValue: .value(.boolean(value: true)))),
//        actions: [
//            InsertDependencyAction(
//                payload: .init(
//                    mode: .after,
//                    selector: .init(value: .key("switch")),
//                    widgets: [
//                        SubtitleRow(key: "success_l", text: "A little success"),
//                        TextFieldRow(key: "hello")
//                    ]
//                )
//            )
//        ]
//    ),
//    
//    .init(
//        predicate: Predicate(
//            operator: .equal,
//            left: .init(operandValue: .selector(.init(value: .keychain("firstname.regex")))),
//            right: .init(operandValue: .value(.boolean(value: true)))),
//        actions: [
//            InsertDependencyAction(
//                payload: .init(
//                    mode: .before,
//                    selector: .init(value: .key("firstname")),
//                    widgets: [
//                        TitleRow(key: "success", title: "Success")
//                    ]
//                )
//            ),
//            ReplaceDependencyAction(
//                payload: .init(
//                    mode: .at,
//                    selector: .init(value: .key("lastname")),
//                    widget: SwitchRow(key: "switch2", text: "There is no textfield", value: true)
//                )
//            )
//        ]
//    )
//]
#endif
