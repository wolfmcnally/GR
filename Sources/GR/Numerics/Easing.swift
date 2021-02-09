//
//  Easing.swift
//  GR
//
//  Created by Wolf McNally on 11/15/20.
//

import Foundation

public enum Easing {
    private static let kPeriod = 0.3
    private static let twoPi = .pi * 2.0

    // Linear
    case linear

    // Sine
    case easeIn
    case easeOut
    case easeInOut

    // Exponential
    case exponentialIn
    case exponentialOut
    case exponentialInOut

    // Back
    case backIn
    case backOut
    case backInOut

    // Bounce
    case bounceIn
    case bounceOut
    case bounceInOut

    // Elastic
    case elasticIn
    case elasticOut
    case elasticInOut

    public func apply(_ t: Frac) -> Frac {
        switch self {

        // **** Linear ****
        case .linear:
            return t

        // **** Sine ****
        case .easeIn:
            // https://www.wolframalpha.com/input/?i=Plot%5B1+-+Cos%5Bt+*+Pi+%2F+2%5D,+%7Bt,+0,+1%7D%5D
            return 1.0 - cos(t * .pi / 2)

        case .easeOut:
            // https://www.wolframalpha.com/input/?i=Plot%5BSin%5Bt+*+Pi+%2F+2%5D,+%7Bt,+0,+1%7D%5D
            return sin(t * .pi / 2)

        case .easeInOut:
            // https://www.wolframalpha.com/input/?i=Plot%5BSin%5Bt+*+Pi+%2F+2%5D%5E2,+%7Bt,+0,+1%7D%5D
            let a = sin(t * .pi / 2)
            return a * a

        // **** Exponential ****
        case .exponentialIn:
            // https://www.wolframalpha.com/input/?i=Plot%5BPower%5B2.0,+10.0+*+(t%2F1.0+-+1.0)%5D+-+1.0+*+0.001,+%7Bt,+0,+1%7D%5D
            return (t==0.0) ? 0.0 : pow(2.0, 10.0 * (t/1.0 - 1.0)) - 1.0 * 0.001

        case .exponentialOut:
            // https://www.wolframalpha.com/input/?i=Plot%5B-Power%5B2.0,+-10.0+*+t%2F1.0)+%2B+1.0%5D,+%7Bt,+0,+1%7D%5D
            return (t==1.0) ? 1.0 : (-pow(2.0, -10.0 * t/1.0) + 1.0)

        case .exponentialInOut:
            var t = t
            t /= 0.5
            if (t < 1.0) {
                t = 0.5 * pow(2.0, 10.0 * (t - 1.0))
            }
            else {
                t = 0.5 * (-pow(2.0, -10.0 * (t - 1.0) ) + 2.0)
            }
            return t

        // **** Back ****
        case .backIn:
            // https://www.wolframalpha.com/input/?i=Plot%5Bt+*+t+*+((1.70158+%2B+1.0)+*+t+-+1.70158),+%7Bt,+0,+1%7D%5D
            let overshoot = 1.70158
            return t * t * ((overshoot + 1.0) * t - overshoot)

        case .backOut:
            let overshoot = 1.70158
            var t = t
            t = t - 1.0
            return t * t * ((overshoot + 1.0) * t + overshoot) + 1.0

        case .backInOut:
            let overshoot = 1.70158 * 1.525
            var t = t
            t = t * 2.0
            if (t < 1.0) {
                return (t * t * ((overshoot + 1.0) * t - overshoot)) / 2.0
            }
            else {
                t = t - 2.0
                return (t * t * ((overshoot + 1.0) * t + overshoot)) / 2.0 + 1.0
            }

        // **** Bounce ****
        case .bounceIn:
            var newT = t
            if(t != 0.0 && t != 1.0) {
                newT = 1.0 - Self.bounceTime(t: 1.0 - t)
            }
            return newT

        case .bounceOut:
            var newT = t
            if(t != 0.0 && t != 1.0) {
                newT = Self.bounceTime(t: t)
            }
            return newT

        case .bounceInOut:
            let newT: Double
            if( t == 0.0 || t == 1.0) {
                newT = t
            }
            else if (t < 0.5) {
                var t = t
                t = t * 2.0
                newT = (1.0 - Self.bounceTime(t: 1.0-t) ) * 0.5
            } else {
                newT = Self.bounceTime(t: t * 2.0 - 1.0) * 0.5 + 0.5
            }

            return newT

        // **** Elastic ****
        case .elasticIn:
            var newT = 0.0
            if (t == 0.0 || t == 1.0) {
                newT = t
            }
            else {
                var t = t
                let s = Self.kPeriod / 4.0
                t = t - 1
                newT = -pow(2, 10 * t) * sin( (t-s) * Self.twoPi / Self.kPeriod)
            }
            return newT

        case .elasticOut:
            var newT = 0.0
            if (t == 0.0 || t == 1.0) {
                newT = t
            } else {
                let s = Self.kPeriod / 4
                newT = pow(2.0, -10.0 * t) * sin( (t-s) * Self.twoPi / Self.kPeriod) + 1
            }
            return newT

        case .elasticInOut:
            var newT = 0.0

            if( t == 0.0 || t == 1.0 ) {
                newT = t
            }
            else {
                var t = t
                t = t * 2.0
                let s = Self.kPeriod / 4

                t = t - 1.0
                if( t < 0 ) {
                    newT = -0.5 * pow(2, 10.0 * t) * sin((t - s) * Self.twoPi / Self.kPeriod)
                }
                else{
                    newT = pow(2, -10.0 * t) * sin((t - s) * Self.twoPi / Self.kPeriod) * 0.5 + 1.0
                }
            }
            return newT
        }
    }

    // Helpers

    static func bounceTime(t: Double) -> Double {
        var t = t

        if (t < 1.0 / 2.75) {
            return 7.5625 * t * t
        }
        else if (t < 2.0 / 2.75) {
            t -= 1.5 / 2.75
            return 7.5625 * t * t + 0.75
        }
        else if (t < 2.5 / 2.75) {
            t -= 2.25 / 2.75
            return 7.5625 * t * t + 0.9375
        }

        t -= 2.625 / 2.75
        return 7.5625 * t * t + 0.984375
    }

//    // These versions use parabola segments (hermite curves)
//    public static func easeOutFaster(_ t: Frac) -> Frac { return 2 * t - t * t }
//    public static func easeInFaster(_ t: Frac) -> Frac { return t * t }
//    public static func easeInAndOutFaster(_ t: Frac) -> Frac { return t * t * (3.0 - 2.0 * t) }
//
//    // These versions use sine curve segments, and are more computationally intensive
//    public static func easeOut(_ t: Frac) -> Frac { return sin(t * .pi / 2) }
//    public static func easeIn(_ t: Frac) -> Frac { return 1.0 - cos(t * .pi / 2) }
//    public static func easeInAndOut(_ t: Frac) -> Frac { return 0.5 * (1 + sin(.pi * (t - 0.5))) }
//
//    public static func triangleUpThenDown(_ t: Frac) -> Frac {
//        return t < 0.5 ? t.lerped(from: 0.0..0.5, to: 0.0..1.0) : t.lerped(from: 0.5..1.0, to: 1.0..0.0)
//    }
//
//    public static func triangleDownThenUp(_ t: Frac) -> Frac {
//        return t < 0.5 ? t.lerped(from: 0.0..0.5, to: 1.0..0.0) : t.lerped(from: 0.5..1.0, to: 0.0..1.0)
//    }
//
//    public static func sawtoothUp(_ t: Frac) -> Frac { return t }
//    public static func sawtoothDown(_ t: Frac) -> Frac { return 1.0 - t }
//
//    public static func sineUpThenDown(_ t: Frac) -> Frac { return sin(t * .pi * 2) * 0.5 + 0.5 }
//    public static func sineDownThenUp(_ t: Frac) -> Frac { return 1.0 - sin(t * .pi * 2) * 0.5 + 0.5 }
//    public static func cosineUpThenDown(_ t: Frac) -> Frac { return 1.0 - cos(t * .pi * 2) * 0.5 + 0.5 }
//    public static func cosineDownThenUp(_ t: Frac) -> Frac { return cos(t * .pi * 2) * 0.5 + 0.5 }
}
