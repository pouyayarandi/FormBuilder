//
//  SubtitleRow.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/30/22.
//

import Foundation
import Combine

class SubtitleRow: FormItem, ObservableObject {
    
    var type: FormItemType { .row }
    
    var id: UUID = UUID()
    var key: String
    
    @Published var text: String
    @Published var hasDivider: Bool = false
    
    init(key: String, text: String) {
        self.key = key
        self.text = text
    }
}
