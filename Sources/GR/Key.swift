//
//  Key.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import UIKit

public enum KeyType {
    case arrow(Direction)
}

public struct Key {
    public let type: KeyType

    public init(type: KeyType) {
        self.type = type
    }

    public var direction: Direction? {
        switch type {
        case .arrow(let direction):
            return direction
        }
    }

    public var offset: Vector? {
        direction?.offset
    }
}
