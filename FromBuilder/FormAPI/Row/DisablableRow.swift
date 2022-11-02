//
//  DisablableRow.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/30/22.
//

import Foundation

protocol DisablableRow: FormRowItem {
    var disabled: Bool { get set }
}
