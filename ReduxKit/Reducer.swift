//
//  Reducer.swift
//  ReduxKit
//
//  Created by BARET Fabrice on 03/02/2023.
//

import Foundation

public protocol Reducer<State, Action> {
    associatedtype State
    associatedtype Action

    func reduce(oldState: State, with action: Action) -> State
}
