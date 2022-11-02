//
//  TitleRowView.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/30/22.
//

import SwiftUI

struct TitleRowView: View {
    @ObservedObject var row: TitleRow
    
    var body: some View {
        HStack {
            Text(row.title).font(.title)
            Spacer()
        }
    }
}
