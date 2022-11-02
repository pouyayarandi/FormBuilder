//
//  TitleRow.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/30/22.
//

import Foundation
import Combine

final class TitleRow: FormItem, ObservableObject {
    
    var type: FormItemType { .row }

    var id: UUID = UUID()
    var key: String
    
    @Published var title: String
    @Published var hasDivider: Bool = false
    
    init(key: String, title: String) {
        self.key = key
        self.title = title
    }
}
