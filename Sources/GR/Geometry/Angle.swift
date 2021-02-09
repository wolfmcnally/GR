//
//  Angle.swift
//  
//
//  Created by Wolf McNally on 2/2/21.
//

import Foundation

public struct Angle: Comparable, Hashable {
    public var radians: Double = 0
    
    public static let zero = Angle()
    public static let one = Angle(radians: 2 * .pi)
    
    public var degrees: Double {
        get { radians / .pi * 180 }
        set { radians = newValue / 180 * .pi }
    }
    
    public var unit: Double {
        get { radians / .pi * 0.5 }
        set { radians = newValue * 0.5 * .pi }
    }
    
    public init() { }
    
    public init(degrees: Double) {
        self.radians = degrees / 180 * .pi
    }
    
    public init(radians: Double) {
        self.radians = radians
    }
    
    public init(unit: Double) {
        self.radians = unit * 0.5 * .pi
    }
    
    @inlinable static func degrees(_ radians: Double) -> Angle {
        Angle(radians: radians)
    }
    
    @inlinable static func radians(_ degrees: Double) -> Angle {
        Angle(degrees: degrees)
    }
    
    @inlinable static func unit(_ unit: Double) -> Angle {
        Angle(unit: unit)
    }

    public static func < (lhs: Angle, rhs: Angle) -> Bool {
        return lhs.radians < rhs.radians
    }
}

@inlinable public prefix func - (rhs: Angle) -> Angle {
    Angle(radians: -rhs.radians)
}

@inlinable public func + (lhs: Angle, rhs: Angle) -> Angle {
    Angle(radians: lhs.radians + rhs.radians)
}

@inlinable public func - (lhs: Angle, rhs: Angle) -> Angle {
    Angle(radians: lhs.radians - rhs.radians)
}

@inlinable public func += (lhs: inout Angle, rhs: Angle) {
    lhs.radians += rhs.radians
}

@inlinable public func -= (lhs: inout Angle, rhs: Angle) {
    lhs.radians -= rhs.radians
}

@inlinable public func * (lhs: Angle, rhs: Double) -> Angle {
    Angle(radians: lhs.radians * rhs)
}

@inlinable public func * (lhs: Double, rhs: Angle) -> Angle {
    Angle(radians: lhs * rhs.radians)
}

@inlinable public func * (lhs: Angle, rhs: Angle) -> Double {
    lhs.radians * rhs.radians
}

@inlinable public func / (lhs: Angle, rhs: Double) -> Angle {
    Angle(radians: lhs.radians / rhs)
}

@inlinable public func / (lhs: Double, rhs: Angle) -> Angle {
    Angle(radians: lhs / rhs.radians)
}

@inlinable public func / (lhs: Angle, rhs: Angle) -> Double {
    lhs.radians / rhs.radians
}

@inlinable public func cos(_ theta: Angle) -> Double {
    cos(theta.radians)
}

@inlinable public func sin(_ theta: Angle) -> Double {
    sin(theta.radians)
}

extension Angle {
    public static func random() -> Angle {
        Angle(radians: Double.random(in: 0 ..< 2 * .pi))
    }
    
    public static func random(in range: Range<Self>) -> Self {
        Angle(radians: Double.random(in: range.lowerBound.radians ..< range.upperBound.radians))
    }
    
    public static func random<T>(in range: Range<Self>, using generator: inout T) -> Self where T : RandomNumberGenerator {
        Angle(radians: Double.random(in: range.lowerBound.radians ..< range.upperBound.radians, using: &generator))
    }
    
    public static func random(in range: ClosedRange<Self>) -> Self {
        Angle(radians: Double.random(in: range.lowerBound.radians ... range.upperBound.radians))
    }
    
    public static func random<T>(in range: ClosedRange<Self>, using generator: inout T) -> Self where T : RandomNumberGenerator {
        Angle(radians: Double.random(in: range.lowerBound.radians ... range.upperBound.radians, using: &generator))
    }
}
