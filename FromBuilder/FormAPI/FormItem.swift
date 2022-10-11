//
//  FormItem.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/10/22.
//

import Foundation

enum FormItemType {
    case row
    case section
}

protocol FormItem {

    var id: UUID { get }

    var type: FormItemType { get }

    var key: String { get set }

    var hasDivider: Bool { get set }
}
