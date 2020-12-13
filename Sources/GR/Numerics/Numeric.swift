//
//  Numeric.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import Foundation

extension FloatingPoint {
    /// Returns this value clamped to between 0.0 and 1.0
    @inlinable public var clamped: Self {
        max(min(self, 1), 0)
    }

    @inlinable public func clamped(to r: ClosedRange<Self>) -> Self {
        max(min(self, r.upperBound), r.lowerBound)
    }

    @inlinable public func ledge() -> Bool {
        self < Self(sign: .plus, exponent: -1, significand: 1) // 0.5
    }

    @inlinable public func ledge<T>(_ a: @autoclosure () -> T, _ b: @autoclosure () -> T) -> T {
        self.ledge() ? a() : b()
    }

    @inlinable public var fractionalPart: Self {
        self - rounded(.towardZero)
    }

    @inlinable public var snapped: Self {
        floor(self) + Self(sign: .plus, exponent: -1, significand: 1) // 0.5
    }
}

extension BinaryInteger {
    @inlinable public var isEven: Bool {
        (self & 1) == 0
    }

    @inlinable public var isOdd: Bool {
        (self & 1) == 1
    }
}

public func mod<I: SignedInteger>(_ a: I, _ n: I) -> I {
    precondition(n > 0, "modulus must be positive")
    let r = a % n
    return r >= 0 ? r : r + n
}
