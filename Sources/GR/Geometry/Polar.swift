//
//  Polar.swift
//  GR
//
//  Created by Wolf McNally on 12/1/20.
//

import Foundation

public struct Polar: Equatable, Hashable {
    public var magnitude: Double
    public var angle: Angle

    public init(magnitude: Double, angle: Angle) {
        self.magnitude = magnitude
        self.angle = angle
    }
    
    public static func ==(lhs: Polar, rhs: Polar) -> Bool {
        lhs.magnitude == rhs.magnitude && lhs.angle == rhs.angle
    }
}

extension Vector {
    public init(_ p: Polar) {
        self.init(dx: cos(p.angle) * p.magnitude, dy: sin(p.angle) * p.magnitude)
    }
}

public func + (lhs: Point, rhs: Polar) -> Point {
    lhs + Vector(rhs)
}

public func += (lhs: inout Point, rhs: Polar) {
    lhs += Vector(rhs)
}
