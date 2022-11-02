//
//  ContentView.swift
//  FromBuilder
//
//  Created by Pouya on 7/12/1401 AP.
//

import SwiftUI
import Combine

struct FormItemView: View {
    var row: any FormItem
    
    var body: some View {
        switch row {
        case let row as TitleRow: TitleRowView(row: row)
        case let row as SubtitleRow: SubtitleRowView(row: row)
        case let row as TextFieldRow: TextFieldRowView(row: row)
        case let row as SwitchRow: SwitchRowView(row: row)
        case let row as SectionRow: SectionWidgetView(viewModel: row)
        case let row as ErrorRow: ErrorRowView(row: row)
        default: EmptyView()
        }
    }
}

extension String: Identifiable {
    public var id: Int { self.hashValue }
}

struct FormBodyView: View {
    
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        ScrollView {
            ForEach(viewModel.list, id: \.id) { item in
                if item.type == .section {
                    FormItemView(row: item)
                        .padding(.vertical, 4)
                        .modifier(Divider(hasDivider: item.hasDivider))
                } else {
                    FormItemView(row: item)
                        .padding(.vertical, 4)
                        .padding(.horizontal)
                        .modifier(Divider(hasDivider: item.hasDivider))
                }
            }
        }
    }
}

struct Divider: ViewModifier {
    var hasDivider: Bool
    func body(content: Content) -> some View {
        VStack {
            content
            if hasDivider {
                Rectangle()
                    .foregroundColor(.secondary)
                    .frame(height: 0.5)
                    .padding(.leading)
            }
        }
    }
}

struct StickyWidgetView: View {
    @ObservedObject var viewModel: ContentViewModel
    var body: some View {
        Button("Submit") {
            viewModel.buttonTapped()
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .padding()
        .background(.red)
        .cornerRadius(3)
        .padding()
    }
}

final class SectionRow: FormSectionItem, ObservableObject {
    
    let id: UUID = UUID()
    let type: FormItemType = .section
    var key: String
    var hasDivider: Bool = false
    @Published var sectionTitle: String
    @Published var rowItems: [FormItem]
    
    init(key: String, sectionTitle: String, rowItems: [FormItem]) {
        self.key = key
        self.sectionTitle = sectionTitle
        self.rowItems = rowItems
    }
}

struct SectionWidgetView: View {

    @ObservedObject var viewModel: SectionRow

    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.sectionTitle.isEmpty == false {
                Text(viewModel.sectionTitle)
                    .font(.title2)
                    .bold()
                    .padding(.leading, 8)
            }
            ForEach(viewModel.rowItems, id: \.id) { item in
                FormItemView(row: item)
                    .padding(.vertical, 4)
                    .modifier(
                        Divider(hasDivider: item.hasDivider)
                    )
            }
        }
    }
}


//var list: [FormItem] = [
//    TitleRow(key: "rent_title", title: "Rent"),
//    TextFieldRow(key: "rent", rules: []),
//    TitleRow(key: "credit_title", title: "Credit"),
//    TextFieldRow(key: "credit", rules: []),
//    SwitchRow(key: "transform_switch", text: "Transform it", value: false),
////    SubtitleRow(key: "subtitle_2", text: "Some other text goes here"),
////    TextFieldRow(key: "lastname"),
////    SubtitleRow(key: "subtitle_3", text: "")
////    SectionRow(
////        key: "section_1",
////        sectionTitle: "Hiiiiii",
////        rowItems: [
////            SwitchRow(key: "switch", text: "Toggle it", value: false),
////            SubtitleRow(key: "subtitle_2", text: "Some other text goes here"),
////            TextFieldRow(key: "lastname"),
////            SubtitleRow(key: "subtitle_3", text: "")
////        ]
////    )
//]

class ContentViewModel: ObservableObject, Dependable {
    var dependencies: [Dependency]
    
    init(list: [FormItem], dependencies: [Dependency] = []) {
        self.dependencies = dependencies
        self.set(list)
    }
    
    private var snapshot: [FormItem] = []
    @Published var list: [FormItem] = []
    
    func `set`(_ list: [FormItem]) {
        self.list = list
        self.snapshot = list
    }
    
    func dataDidChanged() {
        var list = snapshot
        for dependency in dependencies {
            list = dependency.execute(list: list)
        }
        withAnimation {
            self.list = list
        }
    }
    
    var data: KeyValuePairs {
        Dictionary(
            uniqueKeysWithValues: list
                .compactMap { $0 as? FormInputRowItem }
                .flatMap { $0.keyValuePair }
        )
    }
    
    func buttonTapped() {
        
        let encodedData = try! JSONEncoder().encode(data)
        let json = String(data: encodedData, encoding: .utf8) ?? ""
        (list[list.count - 1] as! SubtitleRow).text = json
    }
}

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            FormBodyView(viewModel: viewModel)
                .onPreferenceChange(FormInputRowKeyValuePairsPreferenceKey.self) { _ in
                    viewModel.dataDidChanged()
                }
            StickyWidgetView(viewModel: viewModel)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView(viewModel: .init(list: tList, dependencies: dependencies))
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Example")
        }
    }
}
