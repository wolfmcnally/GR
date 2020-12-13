//
//  Vector.swift
//  GR
//
//  Created by Wolf McNally on 11/15/20.
//

import Foundation
import Interpolate

public struct Vector {
    public var simd: SIMD2<Double>

    @inlinable public init<N: BinaryInteger>(dx: N, dy: N) {
        simd = [Double(dx), Double(dy)]
    }

    @inlinable public init<N: BinaryFloatingPoint>(dx: N, dy: N) {
        simd = [Double(dx), Double(dy)]
    }

    @inlinable public init(_ v: SIMD2<Double>) {
        self.simd = v
    }

    @inlinable public var dx: Double {
        get { simd.x }
        set { simd.x = newValue }
    }

    @inlinable public var dy: Double {
        get { simd.y }
        set { simd.y = newValue }
    }

    @inlinable public init(angle theta: Double, magnitude: Double) {
        simd = [
            cos(theta) * magnitude,
            sin(theta) * magnitude
        ]
    }

    public static let zero = Vector(dx: 0, dy: 0)
    public static let up = Vector(dx: 0, dy: -1)
    public static let left = Vector(dx: -1, dy: 0)
    public static let down = Vector(dx: 0, dy: 1)
    public static let right = Vector(dx: 1, dy: 0)

    public struct IntView {
        public let v: Vector

        @inlinable init(_ v: Vector) { self.v = v }

        @inlinable public var dx: Int { Int(v.dx) }
        @inlinable public var dy: Int { Int(v.dy) }
    }

    public var intView: IntView { IntView(self) }
}

extension Vector: ExpressibleByArrayLiteral {
    public init(arrayLiteral a: Double...) {
        assert(a.count == 2)
        simd = [a[0], a[1]]
    }
}

extension Vector: CustomStringConvertible {
    public var description: String {
        return("Vector(\(dx), \(dy))")
    }
}

extension Vector {
    @inlinable public init(_ point: Point) {
        simd = point.simd
    }

    @inlinable public init(_ size: Size) {
        simd = size.simd
    }

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

extension Vector: Equatable {
}

@inlinable public func == (lhs: Vector, rhs: Vector) -> Bool {
    return lhs.dx == rhs.dx && lhs.dy == rhs.dy
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
