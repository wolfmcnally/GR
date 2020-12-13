//
//  CGVectorExtensions.swift
//  GR
//
//  Created by Wolf McNally on 11/15/20.
//

import CoreGraphics

extension CGVector {
    init(angle theta: CGFloat, magnitude: CGFloat) {
        self.init(dx: cos(theta) * magnitude, dy: sin(theta) * magnitude)
    }

    init(_ point1: CGPoint, _ point2: CGPoint) {
        self.init(dx: point2.x - point1.x, dy: point2.y - point1.y)
    }

    init(point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }

    init(size: CGSize) {
        self.init(dx: size.width, dy: size.height)
    }

    var magnitude: CGFloat {
        hypot(dx, dy)
    }

    var angle: CGFloat {
        atan2(dy, dx)
    }

    func normalized() -> CGVector {
        let m = magnitude
        assert(m > 0.0)
        return self / m
    }

    func rotated(by theta: CGFloat) -> CGVector {
        let sinTheta = sin(theta)
        let cosTheta = cos(theta)
        return CGVector(dx: dx * cosTheta - dy * sinTheta, dy: dx * sinTheta + dy * cosTheta)
    }

    static var unit = CGVector(dx: 1, dy: 0)
}

func - (lhs: CGVector, rhs: CGVector) -> CGVector {
    CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
}

func + (lhs: CGVector, rhs: CGVector) -> CGVector {
    CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

func / (lhs: CGVector, rhs: CGFloat) -> CGVector {
    CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
}

func / (lhs: CGVector, rhs: CGVector) -> CGVector {
    CGVector(dx: lhs.dx / rhs.dx, dy: lhs.dy / rhs.dy)
}

func * (lhs: CGVector, rhs: CGFloat) -> CGVector {
    CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
}

func * (lhs: CGVector, rhs: CGVector) -> CGVector {
    CGVector(dx: lhs.dx * rhs.dx, dy: lhs.dy * rhs.dy)
}

func dot(v1: CGVector, _ v2: CGVector) -> CGFloat {
    v1.dx * v2.dx + v1.dy * v2.dy
}

func cross(v1: CGVector, _ v2: CGVector) -> CGFloat {
    v1.dx * v2.dy - v1.dy * v2.dx
}
