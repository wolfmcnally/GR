//
//  Frac.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import Foundation

/// `Frac` represents a `Double` value that should always be constrained to the closed interval `0.0 .. 1.0`. Although it is a simple typealias and therefore cannot do bounds checking, it is quite useful as a way to document a value as being fractional in nature. Within WolfNumerics it is often used for values like color components or interpolation amounts.
public typealias Frac = Double

/// Asserts that the value is in the closed interval `0.0 .. 1.0`. As this function is generic, it can be used with the `Frac` typealias or any other floating-point type.
public func assertFrac<T: FloatingPoint>(_ n: T) {
    assert(0 <= n && n <= 1)
}
