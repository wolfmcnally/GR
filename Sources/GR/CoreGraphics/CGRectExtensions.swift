//
//  CGRectExtensions.swift
//  GR
//
//  Created by Wolf McNally on 11/15/20.
//

import Foundation
import CoreGraphics

extension CGRect {
    // Corners
    var minXminY: CGPoint { CGPoint(x: minX, y: minY) }
    var maxXminY: CGPoint { CGPoint(x: maxX, y: minY) }
    var maxXmaxY: CGPoint { CGPoint(x: maxX, y: maxY) }
    var minXmaxY: CGPoint { CGPoint(x: minX, y: maxY) }

    // Sides
    var midXminY: CGPoint { CGPoint(x: midX, y: minY) }
    var midXmaxY: CGPoint { CGPoint(x: midX, y: maxY) }
    var maxXmidY: CGPoint { CGPoint(x: maxX, y: midY) }
    var minXmidY: CGPoint { CGPoint(x: minX, y: midY) }

    // Already provided by CGRect:
    //  var minX
    //  var midX
    //  var maxX
    //  var minY
    //  var midY
    //  var maxY

    // Center
    var midXmidY: CGPoint { CGPoint(x: midX, y: midY) }

    // Dimensions

    // Already provided by CGRect:
    //  var width
    //  var height
}

extension CGRect {
    // Corners
    func settingMinXminY(_ p: CGPoint) -> CGRect { CGRect(origin: p, size: size) }
    func settingMaxXminY(_ p: CGPoint) -> CGRect { CGRect(origin: CGPoint(x: p.x - size.width, y: p.y), size: size) }
    func settingMaxXmaxY(_ p: CGPoint) -> CGRect { CGRect(origin: CGPoint(x: p.x - size.width, y: p.y - size.height), size: size) }
    func settingMinXmaxY(_ p: CGPoint) -> CGRect { CGRect(origin: CGPoint(x: p.x, y: p.y - size.height), size: size) }

    // Sides
    func settingMinX(_ x: CGFloat) -> CGRect { CGRect(origin: CGPoint(x: x, y: origin.y), size: size) }
    func settingMaxX(_ x: CGFloat) -> CGRect { CGRect(origin: CGPoint(x: x - size.width, y: origin.y), size: size) }
    func settingMidX(_ x: CGFloat) -> CGRect { CGRect(origin: CGPoint(x: x - size.width / 2, y: origin.y), size: size) }

    func settingMinY(_ y: CGFloat) -> CGRect { CGRect(origin: CGPoint(x: origin.x, y: y), size: size) }
    func settingMaxY(_ y: CGFloat) -> CGRect { CGRect(origin: CGPoint(x: origin.x, y: y - size.height), size: size) }
    func settingMidY(_ y: CGFloat) -> CGRect { CGRect(origin: CGPoint(x: origin.x, y: y - size.height / 2), size: size) }

    func settingMidXminY(_ p: CGPoint) -> CGRect { CGRect(origin: CGPoint(x: p.x - size.width / 2, y: p.y), size: size) }
    func settingMidXmaxY(_ p: CGPoint) -> CGRect { CGRect(origin: CGPoint(x: p.x - size.width / 2, y: p.y - size.height), size: size) }
    func settingMaxXmidY(_ p: CGPoint) -> CGRect { CGRect(origin: CGPoint(x: p.x - size.width, y: p.y - size.height / 2), size: size) }
    func settingMinXmidY(_ p: CGPoint) -> CGRect { CGRect(origin: CGPoint(x: p.x, y: p.y - size.height / 2), size: size) }

    // Center
    func settingMidXmidY(_ p: CGPoint) -> CGRect { CGRect(origin: CGPoint(x: p.x - size.width / 2, y: p.y - size.height / 2), size: size) }

    // Dimensions
    func settingWidth(_ w: CGFloat) -> CGRect { CGRect(origin: origin, size: CGSize(width: w, height: size.height)) }
    func settingHeight(_ h: CGFloat) -> CGRect { CGRect(origin: origin, size: CGSize(width: size.width, height: h)) }
}

extension CGRect {
    // These functions can produce rectangles that have a different size.

    // Corners
    func settingMinXminYIndependent(_ p: CGPoint) -> CGRect { settingMinXIndependent(p.x).settingMinYIndependent(p.y) }
    func settingMaxXminYIndependent(_ p: CGPoint) -> CGRect { settingMaxXIndependent(p.x).settingMinYIndependent(p.y) }
    func settingMaxXmaxYIndependent(_ p: CGPoint) -> CGRect { settingMaxXIndependent(p.x).settingMaxYIndependent(p.y) }
    func settingMinXmaxYIndependent(_ p: CGPoint) -> CGRect { settingMinXIndependent(p.x).settingMaxYIndependent(p.y) }

    // Sides
    func settingMinXIndependent(_ x: CGFloat) -> CGRect { let dx = minX - x; return settingMinX(x).settingWidth(width + dx).standardized }
    func settingMaxXIndependent(_ x: CGFloat) -> CGRect { let dx = maxX - x; return settingMaxX(x).settingWidth(width + dx).standardized }

    func settingMinYIndependent(_ y: CGFloat) -> CGRect { let dy = minY - y; return settingMinY(y).settingHeight(height + dy).standardized }
    func settingMaxYIndependent(_ y: CGFloat) -> CGRect { let dy = maxY - y; return settingMaxY(y).settingHeight(height + dy).standardized }
}

extension CGRect {
    // Corners
    mutating func setMinXminY(_ p: CGPoint) { origin = p }
    mutating func setMaxXminY(_ p: CGPoint) { origin.x = p.x - size.width; origin.y = p.y }
    mutating func setMaxXmaxY(_ p: CGPoint) { origin.x = p.x - size.width; origin.y = p.y - size.height }
    mutating func setMinXmaxY(_ p: CGPoint) { origin.x = p.x; origin.y = p.y - size.height }

    // Sides
    mutating func setMinX(_ x: CGFloat) { origin.x = x }
    mutating func setMaxX(_ x: CGFloat) { origin.x = x - size.width }
    mutating func setMidX(_ x: CGFloat) { origin.x = x - size.width / 2 }

    mutating func setMinY(_ y: CGFloat) { origin.y = y }
    mutating func setMaxY(_ y: CGFloat) { origin.y = y - size.height }
    mutating func setMidY(_ y: CGFloat) { origin.y = y - size.height / 2 }

    mutating func setMidXminY(_ p: CGPoint) { origin.x = p.x - size.width / 2; origin.y = p.y }
    mutating func setMidXmaxY(_ p: CGPoint) { origin.x = p.x - size.width / 2; origin.y = p.y - size.height }
    mutating func setMaxXmidY(_ p: CGPoint) { origin.x = p.x - size.width; origin.y = p.y - size.height / 2 }
    mutating func setMinXmidY(_ p: CGPoint) { origin.x = p.x; origin.y = p.y - size.height / 2 }

    // Dimensions
    mutating func setWidth(_ w: CGFloat) { size.width = w }
    mutating func setHeight(_ h: CGFloat) { size.height = h }
}

extension CGRect {
    // These functions can produce rectangles that have a different size.

    // Corners
    mutating func setMinXminYIndependent(_ p: CGPoint) { setMinXIndependent(p.x); setMinYIndependent(p.y) }
    mutating func setMaxXminYIndependent(_ p: CGPoint) { setMaxXIndependent(p.x); setMinYIndependent(p.y) }
    mutating func setMaxXmaxYIndependent(_ p: CGPoint) { setMaxXIndependent(p.x); setMaxYIndependent(p.y) }
    mutating func setMinXmaxYIndependent(_ p: CGPoint) { setMinXIndependent(p.x); setMaxYIndependent(p.y) }

    // Sides
    mutating func setMinXIndependent(_ x: CGFloat) { let dx = minX - x; setMinX(x); size.width += dx; self = standardized }
    mutating func setMaxXIndependent(_ x: CGFloat) { let dx = maxX - x; /*setMaxX(x);*/ size.width -= dx; self = standardized }

    mutating func setMinYIndependent(_ y: CGFloat) { let dy = minY - y; setMinY(y); size.height += dy; self = standardized }
    mutating func setMaxYIndependent(_ y: CGFloat) { let dy = maxY - y; setMaxY(y); size.height += dy; self = standardized }
}

extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let o = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
        self.init(origin: o, size: size)
    }

    init(center: CGPoint, size: CGFloat) {
        self.init(center: center, size: CGSize(width: size, height: size))
    }
}
