//
//  ErrorRow.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/30/22.
//

import Combine
import Foundation

final class ErrorRow: ObservableObject, FormDisplayableRowItem {

    var id: UUID = UUID()
    var type: FormItemType { .row }
    var key: String

    @Published var hasDivider: Bool
    @Published var errors: [String]

    init(key: String, errors: [String]) {
        self.key = key
        self.hasDivider = false
        self.errors = errors
    }
}
