//
//  IdentityReducer.swift
//  ReduxKit
//
//  Created by BARET Fabrice on 03/02/2023.
//

import Foundation

struct IdentityReducer<State, Action>: Reducer {
    func reduce(oldState: State, with action: Action) -> State {
        oldState
    }
}
