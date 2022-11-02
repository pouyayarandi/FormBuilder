//
//  TextFieldRowView.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/30/22.
//

import SwiftUI

struct TextFieldRowView: View {

    @ObservedObject var row: TextFieldRow
    @State private var errors: [String] = []

    var body: some View {
        Group {
            TextField(row.placeholder ?? "", text: $row.textFieldText)
                .preference(
                    key: FormInputRowKeyValuePairsPreferenceKey.self,
                    value: row.keyValuePair
                )
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(.secondary, lineWidth: 0.5)
                )
            ForEach(self.errors) { error in
                HStack {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .transition(.move(edge: .top))
                    Spacer()
                }
            }
        }
        .onReceive(row.error) { errors in
            withAnimation {
                self.errors = errors
            }
        }
    }
}
