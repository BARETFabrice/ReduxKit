//
//  Middleware.swift
//  ReduxKit
//
//  Created by BARET Fabrice on 03/02/2023.
//

import Foundation

public protocol Middleware<Action> {
    associatedtype Action

    func process(with action: Action) async -> Action?
}
