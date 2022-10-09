//
//  ContentView.swift
//  FromBuilder
//
//  Created by Pouya on 7/12/1401 AP.
//

import SwiftUI
import Combine

class TitleRow: FormItem, ObservableObject {
    
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
    
    var id: UUID = UUID()
    var key: String
    
    @Published var text: String
    @Published var hasDivider: Bool = false
    
    init(key: String, text: String) {
        self.key = key
        self.text = text
    }
}

class TextFieldRow: FormInputItem, ObservableObject {
    
    var id: UUID = UUID()
    var key: String
    var rules: [Rule] = []
    
    @Published var placeholder: String? = "Enter..."
    @Published var hasDivider: Bool = false
    @Published var value: String = ""
    
    var error: AnyPublisher<String?, Never> {
        $value.map { [weak self] value in
            self?.rules
                .first { !$0.validate(value) }?
                .errorMessage
        }.eraseToAnyPublisher()
    }
    
    init(key: String, rules: [Rule] = [], value: String = "") {
        self.key = key
        self.rules = rules
        self.value = value
    }
}

class SwitchRow: FormInputItem, ObservableObject {
    
    var id: UUID = .init()
    var key: String
    var rules: [Rule] = []
    
    @Published var text: String
    @Published var value: Bool
    @Published var hasDivider: Bool = true
    
    init(key: String, text: String, value: Bool) {
        self.key = key
        self.text = text
        self.value = value
    }
}

struct FormItemView: View {
    var row: FormItem
    
    var body: some View {
        switch row {
        case let row as TitleRow: TitleRowView(row: row)
        case let row as SubtitleRow: SubtitleRowView(row: row)
        case let row as TextFieldRow: TextFieldRowView(row: row)
        case let row as SwitchRow: SwitchRowView(row: row)
        default: EmptyView()
        }
    }
}

struct TextFieldRowView: View {
    @ObservedObject var row: TextFieldRow
    @State private var error: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(row.placeholder ?? "", text: $row.value)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(.secondary, lineWidth: 0.5))
            
            if let error = error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .animation(.default, value: row.value)
            }
        }
        .onReceive(row.error) { error in
            self.error = error
        }
    }
}

struct TitleRowView: View {
    @ObservedObject var row: TitleRow
    
    var body: some View {
        Text(row.title).font(.title)
    }
}

struct SubtitleRowView: View {
    @ObservedObject var row: SubtitleRow
    
    var body: some View {
        Text(row.text)
            .font(.body)
            .foregroundColor(.secondary)
    }
}

struct SwitchRowView: View {
    @ObservedObject var row: SwitchRow
    
    var body: some View {
        Toggle(row.text, isOn: $row.value)
            .padding(.vertical, 8)
    }
}

struct FormBodyView: View {
    var viewModel: ContentViewModel
    var body: some View {
        List {
            ForEach(viewModel.list, id: \.id) { item in
                FormItemView(row: item)
                    .listRowSeparator(item.hasDivider ? .visible : .hidden)
            }
        }
        .listStyle(.plain)
    }
}

struct StickyWidgetView: View {
    var viewModel: ContentViewModel
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

class ContentViewModel: ObservableObject, Dependable {
    var dependency: Dependency?
    
    init(dependency: Dependency? = nil) {
        self.dependency = dependency
    }
    
    @Published var list: [FormItem] = [
        TitleRow(key: "title_1", title: "Name"),
        SubtitleRow(key: "subtitle_1", text: "Enter your name here as first step"),
        TextFieldRow(key: "firstname", rules: [MinLengthRule(minLength: 3)]),
        SwitchRow(key: "switch", text: "Toggle it", value: false),
        SubtitleRow(key: "subtitle_2", text: "Some other text goes here"),
        TextFieldRow(key: "lastname"),
        SubtitleRow(key: "subtitle_3", text: "")
    ]
    
    var data: [String: Any] {
        Dictionary(uniqueKeysWithValues: list.compactMap({ $0 as? (any FormInputItem) }).map({ ($0.key, $0.anyValue) }))
    }
    
    func buttonTapped() {
        let json = String(data: try! JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed), encoding: .utf8) ?? ""
        (list[list.count - 1] as! SubtitleRow).text = json
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            FormBodyView(viewModel: viewModel)
            StickyWidgetView(viewModel: viewModel)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView(viewModel: .init(dependency: testDependency))
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Example")
        }
    }
}
