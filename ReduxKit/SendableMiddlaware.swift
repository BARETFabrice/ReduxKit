//
//  SendableMiddlaware.swift
//  ReduxKit
//
//  Created by BARET Fabrice on 03/02/2023.
//

import Foundation

struct SendableMiddlaware<Action>: Middleware {
    let closure: @Sendable (Action) async -> Action?

    func process(with action: Action) async -> Action? {
        await closure(action)
    }
}
