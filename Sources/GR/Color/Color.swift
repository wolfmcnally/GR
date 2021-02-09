//
//  Color.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import Foundation
import Interpolate

public struct Color: Equatable {
    public var simd: SIMD4<Frac>

    @inlinable public var red: Frac {
        get { simd[0] }
        set { simd[0] = newValue }
    }

    @inlinable public var green: Frac {
        get { simd[1] }
        set { simd[1] = newValue }
    }

    @inlinable public var blue: Frac {
        get { simd[2] }
        set { simd[2] = newValue }
    }

    @inlinable public var alpha: Frac {
        get { simd[3] }
        set { simd[3] = newValue }
    }

    @inlinable public init(simd: SIMD4<Frac>) {
        self.simd = simd
    }

    @inlinable public init(red: Frac, green: Frac, blue: Frac, alpha: Frac = 1) {
        simd = [red, green, blue, alpha]
    }

    @inlinable public init(redByte: UInt8, greenByte: UInt8, blueByte: UInt8, alphaByte: UInt8 = 255) {
        let red = Frac(redByte) / 255.0
        let green = Frac(greenByte) / 255.0
        let blue = Frac(blueByte) / 255.0
        let alpha = Frac(alphaByte) / 255.0
        simd = [red, green, blue, alpha]
    }

    @inlinable public init(color: Color, alpha: Frac) {
        simd = [color.red, color.green, color.blue, alpha]
    }

    @inlinable public init(white: Frac, alpha: Frac = 1) {
        simd = [white, white, white, alpha]
    }

    public static func random(alpha: Frac = 1) -> Color {
        Color(
            red: Double.randomFrac(),
            green: Double.randomFrac(),
            blue: Double.randomFrac(),
            alpha: alpha
        )
    }

    public static func random<G: RandomNumberGenerator>(alpha: Frac = 1, using generator: inout G) -> Color {
        Color(
            red: Double.randomFrac(using: &generator),
            green: Double.randomFrac(using: &generator),
            blue: Double.randomFrac(using: &generator),
            alpha: alpha
        )
    }

    public func withAlphaComponent(_ alpha: Frac) -> Color {
        Color(color: self, alpha: alpha)
    }

    public static let black = Color(red: 0, green: 0, blue: 0, alpha: 1)
    public static let darkGray = Color(red: 0.2509803922, green: 0.2509803922, blue: 0.2509803922, alpha: 1)
    public static let lightGray = Color(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
    public static let white = Color(red: 1, green: 1, blue: 1, alpha: 1)
    public static let gray = Color(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
    public static let red = Color(red: 1, green: 0, blue: 0, alpha: 1)
    public static let green = Color(red: 0, green: 1, blue: 0, alpha: 1)
    public static let darkGreen = Color(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    public static let blue = Color(red: 0, green: 0, blue: 1, alpha: 1)
    public static let cyan = Color(red: 0, green: 1, blue: 1, alpha: 1)
    public static let yellow = Color(red: 1, green: 1, blue: 0, alpha: 1)
    public static let magenta = Color(red: 1, green: 0, blue: 1, alpha: 1)
    public static let orange = Color(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    public static let purple = Color(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    public static let brown = Color(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
    public static let clear = Color(red: 0, green: 0, blue: 0, alpha: 0)
    public static let pink = Color(red: 1, green: 0.75294118, blue: 0.79607843)
//    public static let chartreuse = blend(from: .yellow, to: .green, at: 0.5)
    public static let gold = Color(redByte: 251, greenByte: 212, blueByte: 55)
    public static let blueGreen = Color(redByte: 0, greenByte: 169, blueByte: 149)
    public static let mediumBlue = Color(redByte: 0, greenByte: 110, blueByte: 185)
    public static let deepBlue = Color(redByte: 60, greenByte: 55, blueByte: 149)
}

extension Color {
    // NOTE: Not gamma-corrected
    public var luminance: Frac {
        red * 0.2126 + green * 0.7152 + blue * 0.0722
    }

    public func multiplied(by rhs: Frac) -> Color {
        Color(red: red * rhs, green: green * rhs, blue: blue * rhs, alpha: alpha)
    }

    public func added(to rhs: Color) -> Color {
        Color(red: red + rhs.red, green: green + rhs.green, blue: blue + rhs.blue, alpha: alpha)
    }

    public func lightened(by frac: Frac) -> Color {
        Color(
            red: red.interpolate(to: 1, at: frac),
            green: green.interpolate(to: 1, at: frac),
            blue: blue.interpolate(to: 1, at: frac),
            alpha: alpha)
    }

    public static func lightened(by frac: Frac) -> (Color) -> Color {
        { $0.lightened(by: frac) }
    }

    public func darkened(by frac: Frac) -> Color {
        Color(
            red: red.interpolate(to: 0, at: frac),
            green: green.interpolate(to: 0, at: frac),
            blue: blue.interpolate(to: 0, at: frac),
            alpha: alpha)
    }

    public static func darkened(by frac: Frac) -> (Color) -> Color {
        { $0.darkened(by: frac) }
    }

    /// Identity fraction is 0.0
    public func dodged(by frac: Frac) -> Color {
        let f = max(1.0 - frac, 1.0e-7)
        return Color(
            red: min(red / f, 1.0),
            green: min(green / f, 1.0),
            blue: min(blue / f, 1.0),
            alpha: alpha)
    }

    public static func dodged(by frac: Frac) -> (Color) -> Color {
        { $0.dodged(by: frac) }
    }

    /// Identity fraction is 0.0
    public func burned(by frac: Frac) -> Color {
        let f = max(1.0 - frac, 1.0e-7)
        return Color(
            red: min(1.0 - (1.0 - red) / f, 1.0),
            green: min(1.0 - (1.0 - green) / f, 1.0),
            blue: min(1.0 - (1.0 - blue) / f, 1.0),
            alpha: alpha)
    }

    public static func burned(by frac: Frac) -> (Color) -> Color {
        { $0.burned(by: frac) }
    }
}

extension Color: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Frac

    public init(arrayLiteral elements: Frac...) {
        precondition(elements.count >= 4)
        simd = SIMD4<Frac>(elements[0], elements[1], elements[2], elements[3])
    }
}

extension Color: CustomStringConvertible {
    public var description: String {
        debugSummary
    }
}

extension Color {
    public var debugSummary: String {
        let joiner = Joiner(left: "Color(", right: ")")
        var needAlpha = true
        
        switch (red, green, blue, alpha) {
        case (0, 0, 0, 0):
            joiner += "clear"
            needAlpha = false
        case (0, 0, 0, _):
            joiner += "black"
        case (1, 1, 1, _):
            joiner += "white"
        case (0.5, 0.5, 0.5, _):
            joiner += "gray"
        case (1, 0, 0, _):
            joiner += "red"
        case (0, 1, 0, _):
            joiner += "green"
        case (0, 0, 1, _):
            joiner += "blue"
        case (0, 1, 1, _):
            joiner += "cyan"
        case (1, 0, 1, _):
            joiner += "magenta"
        case (1, 1, 0, _):
            joiner += "yellow"
        default:
            joiner += "r:\(red %% 2) g:\(green %% 2) b:\(blue %% 2)"
        }
        if needAlpha && alpha < 1.0 {
            joiner += "a: \(alpha %% 2)"
        }
        return joiner.result
    }
}

@inlinable public func * (lhs: Color, rhs: Frac) -> Color {
    lhs.multiplied(by: rhs)
}

@inlinable public func + (lhs: Color, rhs: Color) -> Color {
    lhs.added(to: rhs)
}

extension Color: ForwardInterpolable {
    public func interpolate(to other: Color, at t: Double) -> Color {
        Color(simd: simd.interpolate(to: other.simd, at: t))
    }
}

#if canImport(CoreGraphics)
import CoreGraphics

extension Color {
    public var cgColor: CGColor {
        CGColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
}
#endif
