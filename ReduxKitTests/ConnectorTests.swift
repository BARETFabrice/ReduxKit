//
//  ConnectorTests.swift
//  ReduxKitTests
//
//  Created by BARET Fabrice on 03/02/2023.
//

import XCTest
import ReduxKit

final class ConnectorTests: XCTestCase {
    func testConnector_deliversTheCorrectEmbededAction() {
        let leftAction = Action.left(.action)
        let actionEmbededWithConnector = Action.leftConnector.embed(.action)

        XCTAssertEqual(actionEmbededWithConnector, leftAction)
    }

    func testConnector_deliversTheCorrectExtractedAction() {
        let rightActionExtractedByConnector = Action.leftConnector.extract(Action.right(.action))
        let leftActionExtractedByConnector = Action.leftConnector.extract(Action.left(.action))

        XCTAssertNil(rightActionExtractedByConnector)
        XCTAssertEqual(leftActionExtractedByConnector, LeftAction.action)
    }

    // MARK: - Helpers

    private enum Action: Equatable {
        case left(LeftAction)
        case right(RightAction)

        static var leftConnector: Connector<Action, LeftAction> {
            Connector(embed: Action.left) {
                guard case let Action.left(action) = $0 else { return .none }
                return action
            }
        }
    }

    private enum LeftAction: Equatable {
        case action
    }

    private enum RightAction: Equatable {
        case action
    }
}
