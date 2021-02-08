//
//  Point.swift
//  GR
//
//  Created by Wolf McNally on 11/15/20.
//

import Foundation
import Interpolate

/// Represents a 2-dimensional point, with Double precision.
public struct Point: Equatable, Hashable {
    public var x: Double
    public var y: Double

    @inlinable public init<N: BinaryInteger>(x: N, y: N) {
        self.x = Double(x)
        self.y = Double(y)
    }

    @inlinable public init<N: BinaryFloatingPoint>(x: N, y: N) {
        self.x = Double(x)
        self.y = Double(y)
    }
    
    @inlinable public init(_ p: IntPoint) {
        self.x = Double(p.x)
        self.y = Double(p.y)
    }

    @inlinable public init(_ simd: SIMD2<Double>) {
        self.x = simd.x
        self.y = simd.y
    }
    
    public var simd: SIMD2<Double> {
        [x, y]
    }

    public static let zero = Point(x: 0, y: 0)
    public static let infinite = Point(x: Double.infinity, y: Double.infinity)
}

extension Point {
    /// Provides conversion from Vector.
    @inlinable public init(_ vector: Vector) {
        self.x = vector.dx
        self.y = vector.dy
    }

    /// Provides conversion from polar coordinates.
    ///
    /// - Parameter center: The `Point` to be considered as the origin.
    ///
    /// - Parameter angle: The angle from the angular origin, in radians.
    ///
    /// - Parameter radius: The distance from the origin, as scalar units.
    @inlinable public init(center: Point, angle theta: Double, radius: Double) {
        self.x = center.x + cos(theta) * radius
        self.y = center.y + sin(theta) * radius
    }

    @inlinable public var magnitude: Double {
        return hypot(x, y)
    }

    @inlinable public var angle: Double {
        return atan2(y, x)
    }

    @inlinable public func distance(to point: Point) -> Double {
        return (point - self).magnitude
    }

    @inlinable public func rotated(by theta: Double, aroundCenter center: Point) -> Point {
        let v = center - self
        let v2 = v.rotated(by: theta)
        let p = center + v2
        return p
    }
}

extension Point : ExpressibleByArrayLiteral {
    public init(arrayLiteral a: Double...) {
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

extension Array where Element == Point {
    public init(arrayLiteral a: Point...) {
        self = a
    }
}

extension Point {
    @inlinable public var snapped: Point {
        Point(x: x.snapped, y: y.snapped)
    }
}

extension Point: CustomDebugStringConvertible {
    public var debugDescription: String {
        return("Point(\(x), \(y))")
    }
}

extension Point {
    @inlinable public static func min(_ p1: Point, _ p2: Point) -> Point {
        return Point(x: p1.x < p2.x ? p1.x : p2.x,
                     y: p1.y < p2.y ? p1.y : p2.y)
    }

    @inlinable public static func max(_ p1: Point, _ p2: Point) -> Point {
        return Point(x: p1.x > p2.x ? p1.x : p2.x,
                     y: p1.y > p2.y ? p1.y : p2.y)
    }
}

extension Point {
    public func toNormalizedCoordinates(fromSize size: Size) -> Point {
        let nx = x.interpolate(from: (0, size.width), to: (-1, 1))
        let ny = y.interpolate(from: (0, size.height), to: (-1, 1))
        return Point(x: nx, y: ny)
    }

    public func fromNormalizedCoordinates(toSize size: Size) -> Point {
        let nx = x.interpolate(from: (-1, 1), to: (0, size.width))
        let ny = y.interpolate(from: (-1, 1), to: (0, size.height))
        return Point(x: nx, y: ny)
    }

    public func transformCoordinates(fromSize: Size, toSize: Size) -> Point {
        let nx = x.interpolate(from: (0, fromSize.width), to: (0, toSize.width))
        let ny = y.interpolate(from: (0, fromSize.height), to: (0, toSize.height))
        return Point(x: nx, y: ny)
    }
}

extension Point: ForwardInterpolable {
    public func interpolate(to other: Point, at frac: Frac) -> Point {
        return Point(x: x.interpolate(to: other.x, at: frac),
                     y: y.interpolate(to: other.y, at: frac))
    }
}

@inlinable public prefix func - (rhs: Point) -> Point {
    return Point(x: -rhs.x, y: -rhs.y)
}

@inlinable public func - (lhs: Point, rhs: Point) -> Vector {
    return Vector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
}

@inlinable public func + (lhs: Point, rhs: Vector) -> Point {
    return Point(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}

@inlinable public func += (lhs: inout Point, rhs: Vector) {
    lhs = lhs + rhs
}

@inlinable public func - (lhs: Point, rhs: Vector) -> Point {
    return Point(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
}

@inlinable public func -= (lhs: inout Point, rhs: Vector) {
    lhs = lhs - rhs
}

@inlinable public func + (lhs: Vector, rhs: Point) -> Point {
    return Point(x: lhs.dx + rhs.x, y: lhs.dy + rhs.y)
}

@inlinable public func - (lhs: Vector, rhs: Point) -> Point {
    return Point(x: lhs.dx - rhs.x, y: lhs.dy - rhs.y)
}

@inlinable public func + (lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

@inlinable public func * (lhs: Point, rhs: Double) -> Point {
    return Point(x: lhs.x * rhs, y: lhs.y * rhs)
}

@inlinable public func * (lhs: Double, rhs: Point) -> Point {
    return Point(x: lhs * rhs.x, y: lhs * rhs.y)
}

@inlinable public func / (lhs: Point, rhs: Double) -> Point {
    return Point(x: lhs.x / rhs, y: lhs.y / rhs)
}

#if canImport(CoreGraphics)
import CoreGraphics

extension CGPoint {
    @inlinable public init(_ p: Point) {
        self.init(x: CGFloat(p.x), y: CGFloat(p.y))
    }
}
#endif
