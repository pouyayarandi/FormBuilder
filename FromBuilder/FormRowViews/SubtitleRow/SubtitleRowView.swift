//
//  SubtitleRowView.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/30/22.
//

import SwiftUI

struct SubtitleRowView: View {
    @ObservedObject var row: SubtitleRow
    
    var body: some View {
        HStack {
            Text(row.text)
                .font(.body)
                .foregroundColor(.secondary)
                .animation(.easeInOut(duration: 1))
            Spacer()
        }
    }
}
