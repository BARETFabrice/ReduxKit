//
//  Store.swift
//  ReduxKit
//
//  Created by BARET Fabrice on 03/02/2023.
//

import Foundation

@MainActor
public final class Store<State, Action>: ObservableObject {
    @Published public private(set) var state: State

    private let reducer: any Reducer<State, Action>
    private let middlewares: any Collection<any Middleware<Action>>

    public init(state: State, reducer: some Reducer<State, Action>, middlewares: some Collection<any Middleware<Action>>) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
    }

    public func send(_ action: Action) async {
        state = reducer.reduce(oldState: state, with: action)

        await withTaskGroup(of: Optional<Action>.self) { group in
            middlewares.forEach { middleware in
                _ = group.addTaskUnlessCancelled {
                    await middleware.process(with: action)
                }
            }

            for await case let nextAction? in group where !Task.isCancelled {
                await send(nextAction)
            }
        }
    }
}

extension Store {
    public func derived<DerivedState: Equatable, DerivedAction: Equatable>(
        deriveState: @escaping (State) -> DerivedState,
        deriveAction: @escaping (DerivedAction) -> Action
    ) -> Store<DerivedState, DerivedAction> {
        let derived = Store<DerivedState, DerivedAction>(
            state: deriveState(state),
            reducer: IdentityReducer(),
            middlewares: [
                SendableMiddlaware { action in
                    await self.send(deriveAction(action))
                    return .none
                }
            ]
        )

        $state
            .map(deriveState)
            .removeDuplicates()
            .assign(to: &derived.$state)

        return derived
    }
}
