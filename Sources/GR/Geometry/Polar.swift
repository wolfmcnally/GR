//
//  Polar.swift
//  GR
//
//  Created by Wolf McNally on 12/1/20.
//

import Foundation

public struct Polar {
    public var magnitude: Double
    public var angle: Double // radians

    public init(magnitude: Double, angle: Double) {
        self.magnitude = magnitude
        self.angle = angle
    }

    public var vector: Vector { Vector(dx: cos(angle) * magnitude, dy: sin(angle) * magnitude) }
}

public func + (lhs: Point, rhs: Polar) -> Point {
    lhs + rhs.vector
}

public func += (lhs: inout Point, rhs: Polar) {
    lhs += rhs.vector
}

extension Polar: ExpressibleByArrayLiteral {
    public init(arrayLiteral a: Double...) {
        assert(a.count == 2)
        magnitude = a[0]
        angle = a[1]
    }
}
