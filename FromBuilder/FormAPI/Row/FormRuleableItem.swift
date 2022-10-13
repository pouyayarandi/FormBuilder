//
//  FormRuleableItem.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/12/22.
//

import Foundation

/// separate rules to avoid dependeing on property which we might not need everywhere
protocol FormRuleableItem {
    var rules: [Rule] { get set }
}
