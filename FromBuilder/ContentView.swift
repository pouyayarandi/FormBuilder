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
        self.hasDivider = false
        self.textFieldText = ""
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
        self.hasDivider = true
        self.switchInOn = false
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
                FormItemView(row: item)
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                    .modifier(Divider(hasDivider: item.hasDivider))
            }
        }
    }
}

struct Divider: ViewModifier {
    var hasDivider: Bool
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            if hasDivider {
                Rectangle()
                    .foregroundColor(.secondary)
                    .frame(height: 0.2)
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
                .onPreferenceChange(FormInputRowKeyValuePairsPreferenceKey.self) { values in
                    print("collected values with prefernces \(values)")
                    print()
                    print("collected values from viewModels \(viewModel.data)")
                }
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
