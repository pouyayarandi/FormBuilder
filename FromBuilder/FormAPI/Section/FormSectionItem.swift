//
//  FormSectionItem.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/11/22.
//

import Foundation

protocol FormSectionItem: FormItem {

    var sectionTitle: String { get }

    var rowItems: [FormItem] { get set }
}
