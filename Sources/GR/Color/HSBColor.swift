//
//  HSBColor.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import Foundation

public struct HSBColor: Equatable {
    public var c: SIMD4<Frac>

    @inlinable public var hue: Frac {
        get { c[0] }
        set { c[0] = newValue }
    }

    @inlinable public var saturation: Frac {
        get { c[1] }
        set { c[1] = newValue }
    }

    @inlinable public var brightness: Frac {
        get { c[2] }
        set { c[2] = newValue }
    }

    @inlinable public var alpha: Frac {
        get { c[3] }
        set { c[3] = newValue }
    }

    @inlinable public init(c: SIMD4<Frac>) {
        self.c = c
    }

    @inlinable public init(hue: Frac, saturation: Frac, brightness: Frac, alpha: Frac = 1) {
        c = [hue, saturation, brightness, alpha]
    }
}

extension HSBColor: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Frac

    public init(arrayLiteral elements: Frac...) {
        precondition(elements.count >= 4)
        c = SIMD4<Frac>(elements[0], elements[1], elements[2], elements[3])
    }
}

extension HSBColor: CustomStringConvertible {
    public var description: String {
        "HSBColor\(debugSummary)"
    }
}

extension HSBColor {
    public var debugSummary: String {
        let joiner = Joiner(left: "HSBColor(", right: ")")
        joiner += "h:\(hue %% 2) s:\(saturation %% 2) b:\(brightness %% 2)"
        if alpha < 1.0 {
            joiner += "a: \(alpha %% 2)"
        }
        return joiner.result
    }
}

extension HSBColor {
    public init(_ color: Color) {
        let r = color.red
        let g = color.green
        let b = color.blue
        let alpha = color.alpha

        let maxValue = max(r, g, b)
        let minValue = min(r, g, b)

        let brightness = maxValue

        let d = maxValue - minValue;
        let saturation = maxValue == 0 ? 0 : d / maxValue

        let hue: Frac
        if (maxValue == minValue) {
            hue = 0 // achromatic
        } else {
            switch maxValue {
            case r: hue = ((g - b) / d + (g < b ? 6 : 0)) / 6
            case g: hue = ((b - r) / d + 2) / 6
            case b: hue = ((r - g) / d + 4) / 6
            default: fatalError()
            }
        }
        c = [hue, saturation, brightness, alpha]
    }
}

extension HSBColor {
    public var toColor: Color {
        Color(self)
    }
}

extension Color {
    public init(_ hsb: HSBColor) {
        let v = hsb.brightness.clamped
        let s = hsb.saturation.clamped
        let red: Frac
        let green: Frac
        let blue: Frac
        let alpha = hsb.alpha
        if s <= 0.0 {
            red = v
            green = v
            blue = v
        } else {
            var h = hsb.hue.truncatingRemainder(dividingBy: 1.0)
            if h < 0.0 { h += 1.0 }
            h *= 6.0
            let i = Int(floor(h))
            let f = h - Double(i)
            let p = v * (1.0 - s)
            let q = v * (1.0 - (s * f))
            let t = v * (1.0 - (s * (1.0 - f)))
            switch i {
            case 0: red = v; green = t; blue = p
            case 1: red = q; green = v; blue = p
            case 2: red = p; green = v; blue = t
            case 3: red = p; green = q; blue = v
            case 4: red = t; green = p; blue = v
            case 5: red = v; green = p; blue = q
            default: red = 0; green = 0; blue = 0; assert(false, "unknown hue sector")
            }
        }
        simd = [red, green, blue, alpha]
    }

    public init(hue: Frac, saturation: Frac, brightness: Frac, alpha: Frac = 1) {
        self.init(HSBColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha))
    }
}
