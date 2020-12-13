//
//  RandomNumbers.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import Foundation

extension BinaryFloatingPoint where RawSignificand: FixedWidthInteger {
    public static func randomFrac() -> Self {
        random(in: 0 ..< 1)
    }

    public static func randomFrac<G: RandomNumberGenerator>(using generator: inout G) -> Self {
        random(in: 0 ..< 1, using: &generator)
    }
}

extension Collection {
    public func randomIndex() -> Index? {
        guard !isEmpty else { return nil }
        let offset = Int.random(in: 0 ..< count)
        return index(startIndex, offsetBy: offset)
    }

    public func randomIndex<T>(using generator: inout T) -> Index? where T: RandomNumberGenerator {
        guard !isEmpty else { return nil }
        let offset = Int.random(in: 0 ..< count, using: &generator)
        return index(startIndex, offsetBy: offset)
    }

    public func randomChoice() -> Element {
        self[randomIndex()!]
    }

    public func randomChoice<T>(using generator: inout T) -> Element where T: RandomNumberGenerator {
        self[randomIndex(using: &generator)!]
    }
}

public func randomChoice<T>(_ choices: T...) -> T {
    choices.randomElement()!
}

public func randomChoice<G, T>(using generator: inout G, _ choices: T...) -> T where G: RandomNumberGenerator {
    choices.randomElement(using: &generator)!
}

public func randomCount(in i: CountableClosedRange<Int>) -> CountableClosedRange<Int> {
    0 ... Int.random(in: i.lowerBound ..< i.upperBound)
}
