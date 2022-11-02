//
//  ErrorRowView.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/30/22.
//

import SwiftUI

struct ErrorRowView: View {

    @ObservedObject var row: ErrorRow

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(row.errors) { error in
                HStack {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .transition(.move(edge: .top))
                    Spacer()
                }
            }
        }
    }
}
