//
//  HSBColor.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import Foundation

public struct HSBColor: Equatable {
    public var hue: Angle
    public var saturation: Frac
    public var brightness: Frac
    public var alpha: Frac

    @inlinable public init(hue: Angle, saturation: Frac, brightness: Frac, alpha: Frac = 1) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
    }
}

extension HSBColor: ExpressibleByArrayLiteral {
    public init(arrayLiteral a: Frac...) {
        if a.isEmpty {
            self.hue = 0°
            self.saturation = 0
            self.brightness = 0
            self.alpha = 1
        } else {
            precondition((3...4).contains(a.count))
            self.hue = Angle(unit: a[0])
            self.saturation = a[1]
            self.brightness = a[2]
            self.alpha = a.count == 4 ? a[3] : 1
        }
    }
}

extension HSBColor: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugSummary
    }
}

extension HSBColor {
    public var debugSummary: String {
        let joiner = Joiner(left: "HSBColor(", right: ")")
        joiner += "h:\(hue.unit %% 2) s:\(saturation %% 2) b:\(brightness %% 2)"
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
        self.hue = .unit(hue)
        self.saturation = saturation
        self.brightness = brightness
        self.alpha = alpha
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
            var h = mod(hsb.hue.unit, 1)
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
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    public init(hue: Angle, saturation: Frac, brightness: Frac, alpha: Frac = 1) {
        self.init(HSBColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha))
    }
}
