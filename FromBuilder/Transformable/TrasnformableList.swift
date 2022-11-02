//
//  TrasnformableList.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/30/22.
//

import Foundation

var tList: [FormItem] = [
    TitleRow(key: "rent_title", title: "Rent"),
    TextFieldRow(key: "rent", rules: []),
    TitleRow(key: "credit_title", title: "Credit"),
    TextFieldRow(key: "credit", rules: []),
    SwitchRow(key: "transform_switch", text: "Transform it", value: false, disabled: true),
]
