//
//  DependencyPayloads.swift
//  FromBuilder
//
//  Created by Ali Moazenzadeh on 7/17/1401 AP.
//

import Foundation

struct InsertPayload: DependencyPayload {
    var mode: Mode
    var selector: Selector
    let widgets: [any FormItem]
    
}

struct RemovePayload: DependencyPayload {
    var mode: Mode
    var selector: Selector
}

struct ReplacePayload: DependencyPayload {
    var mode: Mode
    var selector: Selector
    let widget: any FormItem
}

struct AddErrorPayload: DependencyPayload {
    var mode: Mode
    var selector: Selector
    let messages: [String]

    var widget: any FormItem {
        ErrorRow(key: "\(messages.hashValue)", errors: messages)
    }
}

struct AddWarningPayload: DependencyPayload {
    var mode: Mode
    var selector: Selector
    let message: String
}

struct SetValuePayload: DependencyPayload {
    var mode: Mode
    var selector: Selector
    let value: FormAnyInputValue
}
