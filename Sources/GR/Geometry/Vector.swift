//
//  Vector.swift
//  GR
//
//  Created by Wolf McNally on 11/15/20.
//

import Foundation
import Interpolate

public struct Vector: Equatable, Hashable {
    public var dx: Double
    public var dy: Double
    
    @inlinable public init<N: BinaryInteger>(dx: N, dy: N) {
        self.dx = Double(dx)
        self.dy = Double(dy)
    }

    @inlinable public init<N: BinaryFloatingPoint>(dx: N, dy: N) {
        self.dx = Double(dx)
        self.dy = Double(dy)
    }

    @inlinable public init(_ v: SIMD2<Double>) {
        self.dx = v.x
        self.dy = v.y
    }

    @inlinable public init(angle theta: Double, magnitude: Double) {
        self.dx = cos(theta) * magnitude
        self.dy = sin(theta) * magnitude
    }
    
    @inlinable public init(_ v: IntVector) {
        self.dx = Double(v.dx)
        self.dy = Double(v.dy)
    }
    
    public var simd: SIMD2<Double> {
        [dx, dy]
    }

    public static let zero = Vector(dx: 0, dy: 0)
    public static let up = Vector(dx: 0, dy: -1)
    public static let left = Vector(dx: -1, dy: 0)
    public static let down = Vector(dx: 0, dy: 1)
    public static let right = Vector(dx: 1, dy: 0)
}

extension Vector: ExpressibleByArrayLiteral {
    public init(arrayLiteral a: Double...) {
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

extension Vector: CustomDebugStringConvertible {
    public var debugDescription: String {
        return("Vector(\(dx), \(dy))")
    }
}

extension Vector {
    @inlinable public init(_ point: Point) {
        self.dx = point.x
        self.dy = point.y
    }

    @inlinable public init(_ size: Size) {
        self.dx = size.width
        self.dy = size.height
    }
}

extension Vector {
    @inlinable public var magnitude: Double {
        return hypot(dx, dy)
    }

    @inlinable public var angle: Double {
        return atan2(dy, dx)
    }

    @inlinable public var normalized: Vector {
        let m = magnitude
        assert(m > 0.0)
        return self / m
    }

    @inlinable public mutating func normalize() {
        self = self.normalized
    }

    @inlinable public func rotated(by theta: Double) -> Vector {
        let sinTheta = sin(theta)
        let cosTheta = cos(theta)
        return Vector(dx: dx * cosTheta - dy * sinTheta, dy: dx * sinTheta + dy * cosTheta)
    }

    @inlinable public mutating func rotate(byAngle theta: Double) {
        self = rotated(by: theta)
    }

    @inlinable public var swapped: Vector {
        return Vector(dx: dy, dy: dx)
    }

    @inlinable public mutating func swap() {
        self = swapped
    }

    public static var unit = Vector(dx: 1, dy: 0)
}

extension Vector {
    public static func min(_ v1: Vector, _ v2: Vector) -> Vector {
        return Vector(dx: v1.dx < v2.dx ? v1.dx : v2.dx,
                     dy: v1.dy < v2.dy ? v1.dy : v2.dy)
    }

    public static func max(_ v1: Vector, _ v2: Vector) -> Vector {
        return Vector(dx: v1.dx > v2.dx ? v1.dx : v2.dx,
                     dy: v1.dy > v2.dy ? v1.dy : v2.dy)
    }
}

@inlinable public prefix func - (v: Vector) -> Vector {
    return Vector(dx: -v.dx, dy: -v.dy)
}

@inlinable public func + (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

@inlinable public func - (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
}

@inlinable public func / (lhs: Vector, rhs: Double) -> Vector {
    return Vector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
}

@inlinable public func / (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(dx: lhs.dx / rhs.dx, dy: lhs.dy / rhs.dy)
}

@inlinable public func * (lhs: Vector, rhs: Double) -> Vector {
    return Vector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
}

@inlinable public func * (lhs: Double, rhs: Vector) -> Vector {
    return Vector(dx: lhs * rhs.dx, dy: lhs * rhs.dy)
}

@inlinable public func * (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(dx: lhs.dx * rhs.dx, dy: lhs.dy * rhs.dy)
}

@inlinable public func dot(_ v1: Vector, _ v2: Vector) -> Double {
    return v1.dx * v2.dx + v1.dy * v2.dy
}

@inlinable public func cross(_ v1: Vector, _ v2: Vector) -> Double {
    return v1.dx * v2.dy - v1.dy * v2.dx
}

extension Vector: ForwardInterpolable {
    public func interpolate(to other: Vector, at frac: Frac) -> Vector {
        return Vector(dx: dx.interpolate(to: other.dx, at: frac),
                        dy: dy.interpolate(to: other.dy, at: frac))
    }
}

#if canImport(CoreGraphics)
import CoreGraphics

extension CGVector {
    public init(_ v: Vector) {
        self.init(dx: CGFloat(v.dx), dy: CGFloat(v.dy))
    }
}
#endif
