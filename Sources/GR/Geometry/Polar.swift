//
//  Polar.swift
//  GR
//
//  Created by Wolf McNally on 12/1/20.
//

import Foundation

public struct Polar {
    public var magnitude: Double
    public var angle: Angle

    public init(magnitude: Double, angle: Angle) {
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
