//
//  IntRect.swift
//  
//
//  Created by Wolf McNally on 2/7/21.
//

import Foundation

public struct IntRect: Equatable, Hashable {
    public var origin: IntPoint
    public var size: IntSize

    @inlinable public init(origin: IntPoint, size: IntSize) {
        self.origin = origin
        self.size = size
    }

    @inlinable public init(x: Int, y: Int, width: Int, height: Int) {
        self.init(origin: IntPoint(x: x, y: y), size: IntSize(width: width, height: height))
    }

    @inlinable public init(minX: Int, minY: Int, maxX: Int, maxY: Int) {
        self.init(origin: IntPoint(x: minX, y: minY), size: IntSize(width: maxX - minX, height: maxY - minY))
    }
    
    @inlinable public init(_ r: Rect) {
        self.origin = IntPoint(r.origin)
        self.size = IntSize(r.size)
    }

    public static let zero = IntRect(origin: .zero, size: .zero)
    public static let null = IntRect(origin: .max, size: .zero)
    public static let max = IntRect(origin: IntPoint(x: Int.min, y: Int.min), size: .max)
}

extension IntRect: ExpressibleByArrayLiteral {
    public init(arrayLiteral a: Int...) {
        if a.isEmpty {
            origin = .zero
            size = .zero
        } else {
            assert(a.count == 4)
            origin = [a[0], a[1]]
            size = [a[2], a[3]]
        }
    }
}

extension IntRect: CustomDebugStringConvertible {
    public var debugDescription: String {
        "IntRect(\(minX), \(minY), \(width), \(height))"
    }
}

extension IntRect {
    @inlinable public var width: Int {
        get { size.width }
        set { size.width = newValue }
    }

    @inlinable public var height: Int {
        get { size.height }
        set { size.height = newValue }
    }
}

extension IntRect {
    @inlinable public var minX: Int {
        get { origin.x }
        set { origin.x = newValue }
    }

    @inlinable public var midX: Int {
        get { minX + width / 2 }
        set { origin.x = newValue - width / 2 }
    }

    @inlinable public var maxX: Int {
        get { minX + width - 1 }
        set { origin.x = newValue - width }
    }

    @inlinable public var minY: Int {
        get { origin.y }
        set { origin.y = newValue }
    }

    @inlinable public var midY: Int {
        get { minY + height / 2 }
        set { origin.y = newValue - height / 2 }
    }

    @inlinable public var maxY: Int {
        get { minY + height - 1 }
        set { origin.y = newValue - height }
    }
}

extension IntRect {
    @inlinable public var rangeX: ClosedRange<Int> { minX ... maxX }
    @inlinable public var rangeY: ClosedRange<Int> { minY ... maxY }
}

extension IntRect {
    @inlinable public func randomX() -> Int { Int.random(in: rangeX) }
    @inlinable public func randomY() -> Int { Int.random(in: rangeY) }
    @inlinable public func randomPoint() -> IntPoint { IntPoint(x: randomX(), y: randomY()) }
}

extension IntRect {
    @inlinable public func isValidPoint(_ p: IntPoint) -> Bool {
        p.x >= minX && p.y >= minY && p.x <= maxX && p.y <= maxY
    }

    @inlinable public func checkPoint(_ point: IntPoint) {
        assert(point.x >= minX, "x must be >= \(minX)")
        assert(point.y >= minY, "y must be >= \(minY)")
        assert(point.x <= maxX, "x must be <= \(maxX)")
        assert(point.y <= maxY, "y must be <= \(maxY)")
    }

    @inlinable public func clampPoint(_ point: IntPoint) -> IntPoint {
        return IntPoint(x: min(Swift.max(point.x, minX), maxX), y: min(Swift.max(point.y, minY), maxY))
    }
}

extension IntRect {
    // Corners
    @inlinable public var minXminY: IntPoint {
        get { origin }
        set { origin = newValue }
    }

    @inlinable public var maxXminY: IntPoint {
        get { IntPoint(x: maxX, y: minY) }
        set { maxX = newValue.x; minY = newValue.y }
    }

    @inlinable public var minXmaxY: IntPoint {
        get { IntPoint(x: minX, y: maxY) }
        set { minX = newValue.x; maxY = newValue.y }
    }

    @inlinable public var maxXmaxY: IntPoint {
        get { IntPoint(x: maxX, y: maxY) }
        set { maxX = newValue.x; maxY = newValue.y }
    }

    // Sides
    @inlinable public var midXminY: IntPoint {
        get { IntPoint(x: midX, y: minY) }
        set { midX = newValue.x; minY = newValue.y }
    }

    @inlinable public var midXmaxY: IntPoint {
        get { IntPoint(x: midX, y: maxY) }
        set { midX = newValue.x; maxY = newValue.y }
    }

    @inlinable public var maxXmidY: IntPoint {
        get { IntPoint(x: maxX, y: midY) }
        set { maxX = newValue.x; midY = newValue.y }
    }

    @inlinable public var minXmidY: IntPoint {
        get { IntPoint(x: minX, y: midY) }
        set { minX = newValue.x; midY = newValue.y }
    }

    // Center
    @inlinable public var midXmidY: IntPoint {
        get { IntPoint(x: midX, y: midY) }
        set { midX = newValue.x; midY = newValue.y }
    }
}

extension IntRect {
    @inlinable public var isNull: Bool { self.origin == .max }
    @inlinable public var isEmpty: Bool { self.isNull || size.isEmpty }
    @inlinable public var isMax: Bool { self == .max }
}

extension IntRect {
    public var standardized: IntRect {
        guard !isNull else { return self }
        var r = self
        if width < 0 {
            r.width = -r.width
            r.minX -= r.width
        }
        if height < 0 {
            r.height = -r.height
            r.minY -= r.height
        }
        return r
    }

    @inlinable public mutating func standardize() {
        self = self.standardized
    }
}

extension IntRect {
    @inlinable public func offset(dx: Int, dy: Int) -> IntRect {
        guard !isNull else { return self }
        return IntRect(x: minX + dx, y: minY + dy, width: width, height: height)
    }

    public func inset(dx: Int, dy: Int) -> IntRect {
        guard !isNull else { return self }
        var r = self.standardized
        r.minX += dx
        r.width -= dx * 2
        r.minY += dy
        r.height -= dy * 2
        if r.width < 0 || r.height < 0 {
            r = .null
        }
        return r
    }
}

extension IntRect {
    public func union(_ other: IntRect) -> IntRect {
        guard !self.isNull else { return other }
        guard !other.isNull else { return self }
        let r1 = self.standardized
        let r2 = other.standardized
        let x1 = min(r1.minX, r2.minX)
        let x2 = Swift.max(r1.maxX, r2.maxX)
        let y1 = min(r1.minY, r2.minY)
        let y2 = Swift.max(r1.maxY, r2.maxY)
        return IntRect(x: x1, y: y1, width: x2 - x1, height: y2 - y1)
    }

    public func intersection(_ other: IntRect) -> IntRect {
        guard !self.isNull else { return .null }
        guard !other.isNull else { return .null }
        let r1 = self.standardized
        let r2 = other.standardized
        guard r1.maxX > r2.minX else { return .null }
        guard r1.maxY > r2.minY else { return .null }
        guard r1.minX < r2.maxX else { return .null }
        guard r1.minY < r2.minY else { return .null }
        let x1 = Swift.max(r1.minX, r2.minX)
        let x2 = min(r1.maxX, r2.maxX)
        let y1 = Swift.max(r1.minY, r2.minY)
        let y2 = min(r1.maxY, r2.maxY)
        return IntRect(x: x1, y: y1, width: x2 - x1, height: y2 - y1)
    }

    public func intersects(_ other: IntRect) -> Bool {
        guard !self.isNull else { return false }
        guard !other.isNull else { return false }
        let r1 = self.standardized
        let r2 = other.standardized
        guard r1.maxX > r2.minX else { return false }
        guard r1.maxY > r2.minY else { return false }
        guard r1.minX < r2.maxX else { return false }
        guard r1.minY < r2.minY else { return false }
        return true
    }
}

extension IntRect {
    public func contains(_ point: IntPoint) -> Bool {
        guard !self.isNull else { return false }
        guard !self.isEmpty else { return false }
        let r = self.standardized
        guard point.x >= r.minX else { return false }
        guard point.y >= r.minY else { return false }
        guard point.x < r.maxX else { return false }
        guard point.y < r.maxY else { return false }
        return true
    }

    public func contains(_ other: IntRect) -> Bool {
        guard !self.isNull else { return false }
        guard !other.isNull else { return false }
        return self.union(other) == self
    }
}

extension IntRect {
    public func divide(at distance: Int, from edge: RectEdge) -> (slice: IntRect, remainder: IntRect) {
        guard !self.isNull else { return (.null, .null) }
        guard distance > 0 else { return (.null, self) }
        let slice: IntRect
        let remainder: IntRect
        switch edge {
        case .minX:
            guard distance < width else { return (self, .null) }
            let x1 = minX
            let x2 = x1 + distance
            let x3 = maxX
            let y1 = minY
            let y2 = maxY
            slice = IntRect(minX: x1, minY: y1, maxX: x2, maxY: y2)
            remainder = IntRect(minX: x2, minY: y1, maxX: x3, maxY: y2)
        case .minY:
            guard distance < height else { return (self, .null) }
            let y1 = minY
            let y2 = y1 + distance
            let y3 = maxY
            let x1 = minX
            let x2 = maxX
            slice = IntRect(minX: x1, minY: y1, maxX: x2, maxY: y2)
            remainder = IntRect(minX: x1, minY: y2, maxX: x2, maxY: y3)
        case .maxX:
            guard distance < width else { return (self, .null) }
            let x3 = maxX
            let x2 = x3 - distance
            let x1 = minX
            let y1 = minY
            let y2 = maxY
            slice = IntRect(minX: x2, minY: y1, maxX: x3, maxY: y2)
            remainder = IntRect(minX: x1, minY: y1, maxX: x2, maxY: y2)
        case .maxY:
            guard distance < height else { return (self, .null) }
            let y3 = maxY
            let y2 = y3 - distance
            let y1 = minY
            let x1 = minX
            let x2 = maxX
            slice = IntRect(minX: x1, minY: y2, maxX: x2, maxY: y3)
            remainder = IntRect(minX: x1, minY: y1, maxX: x2, maxY: y2)
        }
        return (slice, remainder)
    }
}

#if canImport(CoreGraphics)
import CoreGraphics

extension CGRect {
    public init(_ r: IntRect) {
        self.init(origin: CGPoint(r.origin), size: CGSize(r.size))
    }
}
#endif
