//
//  Gradient.swift
//  GR
//
//  Created by Wolf McNally on 11/15/20.
//

import Foundation
import CoreGraphics

public typealias GradientDrawingOptions = CGGradientDrawingOptions

public struct Gradient {
    public var stops: [(Color, Frac)]

    public init(_ stops: [(Color, Frac)]) {
        self.stops = stops
    }
    
    public init(_ color1: Color, _ color2: Color) {
        self.init([(color1, 0), (color2, 1)])
    }
}

extension Gradient {
    var cgGradient: CGGradient {
        let locations: [CGFloat] = stops.map { CGFloat($0.1) }
        let colors: [CGColor] = stops.map { $0.0.cgColor }
        return CGGradient(colorsSpace: nil, colors: colors as CFArray, locations: locations)!
    }
}
