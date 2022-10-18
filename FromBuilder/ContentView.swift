//
//  ContentView.swift
//  FromBuilder
//
//  Created by Pouya on 7/12/1401 AP.
//

import SwiftUI
import Combine

class TitleRow: FormItem, ObservableObject {
    
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

class TextFieldRow: FormInputRowItem, ObservableObject {

    var type: FormItemType { .row }
    
    var id: UUID = UUID()
    var key: String
    var rules: [Rule] = []
    
    @Published var placeholder: String?
    @Published var hasDivider: Bool

    @Published var textFieldText: String
    
    var value: FormAnyInputValue {
        .string(value: textFieldText)
    }
    
    var error: AnyPublisher<[String], Never> {
        $textFieldText.map { [weak self] value in
            guard let strongSelf = self else { return [] }
            return strongSelf
                .rules
                .reduce(into: [String?]()) { partialResult, rule in
                    let message = rule.validate(strongSelf.value).errorMessage
                    partialResult.append(message)
                }
                .compactMap { $0 }
        }.eraseToAnyPublisher()
    }
    
    init(key: String, rules: [Rule] = [], value: String = "") {
        self.key = key
        self.rules = rules
        self.placeholder = "Enter..."
        self.hasDivider = true
        self.textFieldText = value
    }
}

class SwitchRow: FormInputRowItem, ObservableObject {
    
    var type: FormItemType { .row }
    
    var id: UUID = .init()
    var key: String
    var rules: [Rule] = []
    
    @Published var text: String
    @Published var switchInOn: Bool
    @Published var hasDivider: Bool
    
    var value: FormAnyInputValue {
        .boolean(value: switchInOn)
    }
    
    init(key: String, text: String, value: Bool) {
        self.key = key
        self.text = text
        self.hasDivider = false
        self.switchInOn = value
    }
}

struct FormItemView: View {
    var row: any FormItem
    
    var body: some View {
        switch row {
        case let row as TitleRow: TitleRowView(row: row)
        case let row as SubtitleRow: SubtitleRowView(row: row)
        case let row as TextFieldRow: TextFieldRowView(row: row)
        case let row as SwitchRow: SwitchRowView(row: row)
        case let row as SectionRow: SectionWidgetView(viewModel: row)
        default: EmptyView()
        }
    }
}

extension String: Identifiable {
    public var id: Int { self.hashValue }
}

struct TextFieldRowView: View {
    @ObservedObject var row: TextFieldRow
    @State private var errors: [String] = []
    
    var body: some View {
        Group {
            TextField(row.placeholder ?? "", text: $row.textFieldText)
                .preference(
                    key: FormInputRowKeyValuePairsPreferenceKey.self,
                    value: row.keyValuePair)
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

struct TitleRowView: View {
    @ObservedObject var row: TitleRow
    
    var body: some View {
        HStack {
            Text(row.title).font(.title)
            Spacer()
        }
    }
}

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

struct SwitchRowView: View {
    @ObservedObject var row: SwitchRow
    
    var body: some View {
        Toggle(row.text, isOn: $row.switchInOn)
            .preference(
                key: FormInputRowKeyValuePairsPreferenceKey.self,
                value: row.keyValuePair)
            .padding(.vertical, 8)
    }
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


var list: [FormItem] = [
    TitleRow(key: "title_1", title: "Name"),
    SubtitleRow(key: "subtitle_1", text: "Enter your name here as first step"),
    TextFieldRow(key: "firstname", rules: [MinLengthRule(minLength: 3)]),
    SectionRow(
        key: "section_1",
        sectionTitle: "Hiiiiii",
        rowItems: [
            SwitchRow(key: "switch", text: "Toggle it", value: false),
            SubtitleRow(key: "subtitle_2", text: "Some other text goes here"),
            TextFieldRow(key: "lastname"),
            SubtitleRow(key: "subtitle_3", text: "")
        ]
    )
]

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
            ContentView(viewModel: .init(list: list, dependencies: dependencies))
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Example")
        }
    }
}
