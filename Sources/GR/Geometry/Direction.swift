//
//  Direction.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import Foundation

public enum Direction: CaseIterable {
    case up
    case left
    case down
    case right

    public var offset: Vector {
        switch self {
        case .up:
            return Vector.up
        case .left:
            return Vector.left
        case .down:
            return Vector.down
        case .right:
            return Vector.right
        }
    }

    public var intOffset: IntVector {
        switch self {
        case .up:
            return IntVector.up
        case .left:
            return IntVector.left
        case .down:
            return IntVector.down
        case .right:
            return IntVector.right
        }
    }

    public var opposite: Direction {
        switch self {
        case .up:
            return .down
        case .left:
            return .right
        case .down:
            return .up
        case .right:
            return .left
        }
    }

    public static var random: Direction {
        return allCases.randomChoice()
    }
}
