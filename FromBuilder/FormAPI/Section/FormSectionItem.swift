//
//  FormSectionItem.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/11/22.
//

import Foundation

protocol FormSectionItem: FormItem {

    var rowItems: [any FormRowItem] { get }

}
