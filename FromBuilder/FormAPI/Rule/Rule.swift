//
//  Rule.swift
//  FromBuilder
//
//  Created by Kiarash Vosough on 10/11/22.
//

import Foundation

enum RuleAction {

    case showError(message: String)
    case noAction

    var errorMessage: String? {
        switch self {
        case .showError(let message): return message
        case .noAction: return nil
        }
    }
}

protocol Rule {

    var errorMessage: String { get }

    func validate(_ value: any FormAnyInputValue) -> RuleAction
}
