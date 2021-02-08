//
//  IntPoint.swift
//  
//
//  Created by Wolf McNally on 2/7/21.
//

import Foundation

/// Represents a 2-dimensional point, with Int precision.
public struct IntPoint: Equatable, Hashable {
    public var x: Int
    public var y: Int
    
    @inlinable public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    @inlinable public init(_ p: Point) {
        self.x = Int(p.x)
        self.y = Int(p.y)
    }

    public static let zero = IntPoint(x: 0, y: 0)
    public static let max = IntPoint(x: Int.max, y: Int.max)
}

extension IntPoint : ExpressibleByArrayLiteral {
    public init(arrayLiteral a: Int...) {
        if a.isEmpty {
            self.x = 0
            self.y = 0
        } else {
            assert(a.count == 2)
            self.x = a[0]
            self.y = a[1]
        }
    }
}

extension Array where Element == IntPoint {
    public init(arrayLiteral a: IntPoint...) {
        self = a
    }
}

extension IntPoint: CustomDebugStringConvertible {
    public var debugDescription: String {
        return("IntPoint(\(x), \(y))")
    }
}

extension IntPoint {
    @inlinable public static func min(_ p1: IntPoint, _ p2: IntPoint) -> IntPoint {
        return IntPoint(x: p1.x < p2.x ? p1.x : p2.x,
                     y: p1.y < p2.y ? p1.y : p2.y)
    }

    @inlinable public static func max(_ p1: IntPoint, _ p2: IntPoint) -> IntPoint {
        return IntPoint(x: p1.x > p2.x ? p1.x : p2.x,
                     y: p1.y > p2.y ? p1.y : p2.y)
    }
}

@inlinable public prefix func - (rhs: IntPoint) -> IntPoint {
    return IntPoint(x: -rhs.x, y: -rhs.y)
}

@inlinable public func - (lhs: IntPoint, rhs: IntPoint) -> IntVector {
    return IntVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
}

@inlinable public func + (lhs: IntPoint, rhs: IntVector) -> IntPoint {
    return IntPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}

@inlinable public func += (lhs: inout IntPoint, rhs: IntVector) {
    lhs = lhs + rhs
}

@inlinable public func - (lhs: IntPoint, rhs: IntVector) -> IntPoint {
    return IntPoint(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
}

@inlinable public func -= (lhs: inout IntPoint, rhs: IntVector) {
    lhs = lhs - rhs
}

@inlinable public func + (lhs: IntVector, rhs: IntPoint) -> IntPoint {
    return IntPoint(x: lhs.dx + rhs.x, y: lhs.dy + rhs.y)
}

@inlinable public func - (lhs: IntVector, rhs: IntPoint) -> IntPoint {
    return IntPoint(x: lhs.dx - rhs.x, y: lhs.dy - rhs.y)
}

@inlinable public func + (lhs: IntPoint, rhs: IntPoint) -> IntPoint {
    return IntPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

#if canImport(CoreGraphics)
import CoreGraphics

extension CGPoint {
    @inlinable public init(_ p: IntPoint) {
        self.init(x: CGFloat(p.x), y: CGFloat(p.y))
    }
}
#endif
