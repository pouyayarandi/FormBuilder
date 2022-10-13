//
//  FormInputRowKeyValuePairsPreferenceKey.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/13/22.
//

import SwiftUI

struct FormInputRowKeyValuePairsPreferenceKey: PreferenceKey {

    static var defaultValue: KeyValuePairs = [:]

    /// this method is called whenever a view is rerendered,
    ///  it will collect all the prferences that is defined by views and reduce them into `value`.
    /// each parent view which declared `onPreferencesChange` modifier will get the reduced value.
    static func reduce(value: inout KeyValuePairs, nextValue: () -> KeyValuePairs) {
        value = value.merging(nextValue()) { (_, new) in new }
    }
}
