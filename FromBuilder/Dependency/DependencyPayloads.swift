//
//  DependencyPayloads.swift
//  FromBuilder
//
//  Created by Ali Moazenzadeh on 7/17/1401 AP.
//

import Foundation

struct InsertPayload: DependencyPayload {
    var selector: Selector
    let widgets: [any FormItem]
}

struct RemovePayload: DependencyPayload {
    var selector: Selector
}

struct ReplacePayload: DependencyPayload {
    var selector: Selector
    let widget: any FormItem
}

struct AddErrorPayload: DependencyPayload {
    var selector: Selector
    let message: String
}

struct AddWarningPayload: DependencyPayload {
    var selector: Selector
    let message: String
}

struct SetValuePayload: DependencyPayload {
    var selector: Selector
    let value: Any
}
