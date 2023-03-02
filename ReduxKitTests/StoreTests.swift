//
//  StoreTests.swift
//  ReduxKitTests
//
//  Created by BARET Fabrice on 03/02/2023.
//

import XCTest
import ReduxKit

@MainActor
final class StoreTests: XCTestCase {

    func testStore_deliversTheCorrectStateUpdateOnNonSideEffectActions() async {
        let sut = makeSUT()

        XCTAssertEqual(sut.state.counter, 0)
        await sut.send(.increment)
        XCTAssertEqual(sut.state.counter, 1)
        await sut.send(.decrement)
        XCTAssertEqual(sut.state.counter, 0)
    }

    func testStore_deliversTheCorrectStateUpdateOnSideEffectAction() async {
        let counterValue = 10
        let sut = makeSUT(with: counterValue)

        XCTAssertEqual(sut.state.counter, 0)
        await sut.send(.sideEffect)
        XCTAssertEqual(sut.state.counter, 10)
    }

    func testDerivedStore_deliverrsTheCorrectStateUpdateOnNonSideEffectActions() async {
        let sut = makeSUT()
        let derivedSut = sut.derived(deriveState: { $0 }, deriveAction: { $0 })

        XCTAssertEqual(sut.state.counter, 0)
        XCTAssertEqual(derivedSut.state.counter, 0)

        await sut.send(.increment)
        XCTAssertEqual(sut.state.counter, 1)
        XCTAssertEqual(derivedSut.state.counter, 1)

        await derivedSut.send(.decrement)
        XCTAssertEqual(sut.state.counter, 0)
        XCTAssertEqual(derivedSut.state.counter, 0)
    }

    func testDerivedStore_deliverrsTheCorrectStateUpdateOnSideEffectAction() async {
        let counterValue = 10
        let sut = makeSUT(with: counterValue)
        let derivedSut = sut.derived(deriveState: { $0 }, deriveAction: { $0 })

        XCTAssertEqual(sut.state.counter, 0)
        XCTAssertEqual(derivedSut.state.counter, 0)

        await sut.send(.sideEffect)
        XCTAssertEqual(sut.state.counter, 10)
        XCTAssertEqual(derivedSut.state.counter, 10)

        await sut.send(.set(0))
        XCTAssertEqual(sut.state.counter, 0)
        XCTAssertEqual(derivedSut.state.counter, 0)

        await derivedSut.send(.sideEffect)
        XCTAssertEqual(sut.state.counter, 10)
        XCTAssertEqual(derivedSut.state.counter, 10)
    }

    // MARK: - Helpers

    private func makeSUT(with sideEffectCounterValue: Int = 0) -> Store<CounterState, CounterAction> {
        let state = CounterState()
        let reducer = ReducerStub()
        let middleware = MiddlewareStub(counterValue: sideEffectCounterValue)
        return Store<CounterState, CounterAction>(state: state, reducer: reducer, middlewares: [middleware])
    }

    private struct CounterState: Equatable {
        var counter: Int = 0
    }

    private enum CounterAction: Equatable {
        case increment
        case decrement
        case sideEffect
        case set(Int)
    }

    private struct MiddlewareStub: Middleware {

        let counterValue: Int

        func process(with action: CounterAction) async -> CounterAction? {
            guard action == .sideEffect else { return .none }
            return .set(counterValue)
        }
    }

    private struct ReducerStub: Reducer {

        func reduce(oldState: CounterState, with action: CounterAction) -> CounterState {
            var state = oldState

            switch action {
            case .increment: state.counter += 1
            case .decrement: state.counter -= 1
            case let .set(value): state.counter = value
            default: break
            }

            return state
        }
    }
}
