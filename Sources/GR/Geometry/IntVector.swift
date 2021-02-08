//
//  IntVector.swift
//  
//
//  Created by Wolf McNally on 2/7/21.
//

import Foundation

public struct IntVector: Equatable, Hashable {
    public var dx: Int
    public var dy: Int
    
    @inlinable public init(dx: Int, dy: Int) {
        self.dx = dx
        self.dy = dy
    }
    
    @inlinable public init(_ v: IntVector) {
        self.dx = Int(v.dx)
        self.dy = Int(v.dy)
    }

    public static let zero = IntVector(dx: 0, dy: 0)
    public static let up = IntVector(dx: 0, dy: -1)
    public static let left = IntVector(dx: -1, dy: 0)
    public static let down = IntVector(dx: 0, dy: 1)
    public static let right = IntVector(dx: 1, dy: 0)
}

extension IntVector: ExpressibleByArrayLiteral {
    public init(arrayLiteral a: Int...) {
        if a.isEmpty {
            self.dx = 0
            self.dy = 0
        } else {
            assert(a.count == 2)
            self.dx = a[0]
            self.dy = a[1]
        }
    }
}

extension IntVector: CustomDebugStringConvertible {
    public var debugDescription: String {
        return("IntVector(\(dx), \(dy))")
    }
}

extension IntVector {
    @inlinable public init(_ point: IntPoint) {
        self.dx = point.x
        self.dy = point.y
    }

    @inlinable public init(_ size: IntSize) {
        self.dx = size.width
        self.dy = size.height
    }
}

extension IntVector {
    public static func min(_ v1: IntVector, _ v2: IntVector) -> IntVector {
        return IntVector(dx: v1.dx < v2.dx ? v1.dx : v2.dx,
                     dy: v1.dy < v2.dy ? v1.dy : v2.dy)
    }

    public static func max(_ v1: IntVector, _ v2: IntVector) -> IntVector {
        return IntVector(dx: v1.dx > v2.dx ? v1.dx : v2.dx,
                     dy: v1.dy > v2.dy ? v1.dy : v2.dy)
    }
}

@inlinable public prefix func - (v: IntVector) -> IntVector {
    return IntVector(dx: -v.dx, dy: -v.dy)
}

@inlinable public func + (lhs: IntVector, rhs: IntVector) -> IntVector {
    return IntVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

@inlinable public func - (lhs: IntVector, rhs: IntVector) -> IntVector {
    return IntVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
}
