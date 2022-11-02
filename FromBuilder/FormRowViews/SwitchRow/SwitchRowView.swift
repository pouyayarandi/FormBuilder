//
//  SwitchRowView.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/30/22.
//

import SwiftUI

struct SwitchRowView: View {

    @ObservedObject var row: SwitchRow
    
    var body: some View {
        Toggle(row.text, isOn: $row.switchInOn)
            .disabled(row.disabled)
            .preference(
                key: FormInputRowKeyValuePairsPreferenceKey.self,
                value: row.keyValuePair)
            .padding(.vertical, 8)
    }
}
