//
//  Connector.swift
//  ReduxKit
//
//  Created by BARET Fabrice on 03/02/2023.
//

import Foundation

public struct Connector<Source, Target> {
    public let embed: (Target) -> Source
    public let extract: (Source) -> Target?

    public init(embed: @escaping (Target) -> Source, extract: @escaping (Source) -> Target?) {
        self.embed = embed
        self.extract = extract
    }
}
