//
//  Rect.swift
//  GR
//
//  Created by Wolf McNally on 11/15/20.
//

import Foundation
import Interpolate

public struct Rect: Equatable {
    public var origin: Point
    public var size: Size

    @inlinable public init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }

    @inlinable public init<N: BinaryFloatingPoint>(x: N, y: N, width: N, height: N) {
        self.init(origin: Point(x: x, y: y), size: Size(width: width, height: height))
    }

    @inlinable public init<N: BinaryFloatingPoint>(minX: N, minY: N, maxX: N, maxY: N) {
        self.init(origin: Point(x: minX, y: minY), size: Size(width: maxX - minX, height: maxY - minY))
    }

    @inlinable public init<N: BinaryInteger>(x: N, y: N, width: N, height: N) {
        self.init(origin: Point(x: x, y: y), size: Size(width: width, height: height))
    }

    @inlinable public init<N: BinaryInteger>(minX: N, minY: N, maxX: N, maxY: N) {
        self.init(origin: Point(x: minX, y: minY), size: Size(width: maxX - minX, height: maxY - minY))
    }

    public static let zero = Rect(origin: .zero, size: .zero)
    public static let null = Rect(origin: .infinite, size: .zero)
    public static let infinite = Rect(origin: Point(x: -Double.infinity, y: -Double.infinity), size: .infinite)

    public struct IntView {
        public let rect: Rect

        @inlinable init(_ rect: Rect) { self.rect = rect }

        @inlinable public var width: Int { Int(rect.width) }
        @inlinable public var height: Int { Int(rect.width) }

        @inlinable public var minX: Int { Int(rect.minX) }
        @inlinable public var midX: Int { Int(rect.midX - 0.5) }
        @inlinable public var maxX: Int { Int(rect.maxX - 1) }
        @inlinable public var minY: Int { Int(rect.minY) }
        @inlinable public var midY: Int { Int(rect.midY - 0.5) }
        @inlinable public var maxY: Int { Int(rect.maxY - 1) }

        @inlinable public var rangeX: ClosedRange<Int> { minX ... maxX }
        @inlinable public var rangeY: ClosedRange<Int> { minY ... maxY }

        @inlinable public func randomX() -> Int { Int.random(in: rangeX) }
        @inlinable public func randomY() -> Int { Int.random(in: rangeY) }
        @inlinable public func randomPoint() -> Point { Point(x: randomX(), y: randomY()) }

        @inlinable public func isValidPoint(_ p: Point) -> Bool {
            Int(p.x) >= minX && Int(p.y) >= minY && Int(p.x) <= maxX && Int(p.y) <= maxY
        }

        @inlinable public func checkPoint(_ point: Point.IntView) {
            assert(point.x >= minX, "x must be >= \(minX)")
            assert(point.y >= minY, "y must be >= \(minY)")
            assert(point.x <= maxX, "x must be <= \(maxX)")
            assert(point.y <= maxY, "y must be <= \(maxY)")
        }

        @inlinable public func checkPoint(_ point: Point) {
            checkPoint(point.intView)
        }

        @inlinable public func clampPoint(_ point: Point) -> Point {
            return Point(x: min(max(Int(point.x), minX), maxX), y: min(max(Int(point.y), minY), maxY))
        }
    }

    public var intView: IntView { IntView(self) }
}

extension Rect: ExpressibleByArrayLiteral {
    public init(arrayLiteral a: Double...) {
        assert(a.count == 4)
        origin = [a[0], a[1]]
        size = [a[2], a[3]]
    }
}

extension Rect: CustomStringConvertible {
    public var description: String {
        "Rect(\(minX), \(minY), \(width), \(height))"
    }
}

extension Rect {
    @inlinable public func isValidPoint(_ p: Point) -> Bool {
        p.x >= minX && p.y >= minY && p.x <= maxX && p.y <= maxY
    }

    @inlinable public func checkPoint(_ point: Point) {
        assert(point.x >= minX, "x must be >= \(minX)")
        assert(point.y >= minY, "y must be >= \(minY)")
        assert(point.x <= maxX, "x must be <= \(maxX)")
        assert(point.y <= maxY, "y must be <= \(maxY)")
    }

    @inlinable public func clampPoint(_ point: Point) -> Point {
        return Point(x: min(max(point.x, minX), maxX), y: min(max(point.y, minY), maxY))
    }
}

extension Rect {
    @inlinable public var width: Double {
        get { size.width }
        set { size.width = newValue }
    }

    @inlinable public var height: Double {
        get { size.height }
        set { size.height = newValue }
    }
}

extension Rect {
    @inlinable public var rangeX: ClosedRange<Double> { minX ... maxX }
    @inlinable public var rangeY: ClosedRange<Double> { minY ... maxY }
}

extension Rect {
    @inlinable public func randomX() -> Double { Double.random(in: rangeX) }
    @inlinable public func randomY() -> Double { Double.random(in: rangeY) }
    @inlinable public func randomPoint() -> Point { Point(x: randomX(), y: randomY()) }
}

extension Rect {
    @inlinable public var minX: Double {
        get { origin.x }
        set { origin.x = newValue }
    }

    @inlinable public var midX: Double {
        get { minX + width / 2.0 }
        set { origin.x = newValue - width / 2.0 }
    }

    @inlinable public var maxX: Double {
        get { minX + width }
        set { origin.x = newValue - width }
    }

    @inlinable public var minY: Double {
        get { origin.y }
        set { origin.y = newValue }
    }

    @inlinable public var midY: Double {
        get { minY + height / 2.0 }
        set { origin.y = newValue - height / 2.0 }
    }

    @inlinable public var maxY: Double {
        get { minY + height }
        set { origin.y = newValue - height }
    }
}

extension Rect {
    // Corners
    @inlinable public var minXminY: Point {
        get { origin }
        set { origin = newValue }
    }

    @inlinable public var maxXminY: Point {
        get { Point(x: maxX, y: minY) }
        set { maxX = newValue.x; minY = newValue.y }
    }

    @inlinable public var minXmaxY: Point {
        get { Point(x: minX, y: maxY) }
        set { minX = newValue.x; maxY = newValue.y }
    }

    @inlinable public var maxXmaxY: Point {
        get { Point(x: maxX, y: maxY) }
        set { maxX = newValue.x; maxY = newValue.y }
    }

    // Sides
    @inlinable public var midXminY: Point {
        get { Point(x: midX, y: minY) }
        set { midX = newValue.x; minY = newValue.y }
    }

    @inlinable public var midXmaxY: Point {
        get { Point(x: midX, y: maxY) }
        set { midX = newValue.x; maxY = newValue.y }
    }

    @inlinable public var maxXmidY: Point {
        get { Point(x: maxX, y: midY) }
        set { maxX = newValue.x; midY = newValue.y }
    }

    @inlinable public var minXmidY: Point {
        get { Point(x: minX, y: midY) }
        set { minX = newValue.x; midY = newValue.y }
    }

    // Center
    @inlinable public var midXmidY: Point {
        get { Point(x: midX, y: midY) }
        set { midX = newValue.x; midY = newValue.y }
    }
}

extension Rect {
    @inlinable public var isNull: Bool { self.origin == .infinite }
    @inlinable public var isEmpty: Bool { self.isNull || size.isEmpty }
    @inlinable public var isInfinite: Bool { self == .infinite }
}

extension Rect {
    public var standardized: Rect {
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

    @inlinable public var integral: Rect {
        guard !isNull else { return self }
        return Rect(x: floor(minX), y: floor(minY), width: ceil(width), height: ceil(width))
    }

    @inlinable public mutating func makeIntegral() {
        self = self.integral
    }
}

extension Rect {
    @inlinable public func offset(dx: Double, dy: Double) -> Rect {
        guard !isNull else { return self }
        return Rect(x: minX + dx, y: minY + dy, width: width, height: height)
    }

    public func inset(dx: Double, dy: Double) -> Rect {
        guard !isNull else { return self }
        var r = self.standardized
        r.minX += dx
        r.width -= dx * 2
        r.minY += dy
        r.height -= dy * 2
        if r.width < 0.0 || r.height < 0.0 {
            r = .null
        }
        return r
    }
}

extension Rect {
    public func union(_ other: Rect) -> Rect {
        guard !self.isNull else { return other }
        guard !other.isNull else { return self }
        let r1 = self.standardized
        let r2 = other.standardized
        let x1 = min(r1.minX, r2.minX)
        let x2 = max(r1.maxX, r2.maxX)
        let y1 = min(r1.minY, r2.minY)
        let y2 = max(r1.maxY, r2.maxY)
        return Rect(x: x1, y: y1, width: x2 - x1, height: y2 - y1)
    }

    public func intersection(_ other: Rect) -> Rect {
        guard !self.isNull else { return .null }
        guard !other.isNull else { return .null }
        let r1 = self.standardized
        let r2 = other.standardized
        guard r1.maxX > r2.minX else { return .null }
        guard r1.maxY > r2.minY else { return .null }
        guard r1.minX < r2.maxX else { return .null }
        guard r1.minY < r2.minY else { return .null }
        let x1 = max(r1.minX, r2.minX)
        let x2 = min(r1.maxX, r2.maxX)
        let y1 = max(r1.minY, r2.minY)
        let y2 = min(r1.maxY, r2.maxY)
        return Rect(x: x1, y: y1, width: x2 - x1, height: y2 - y1)
    }

    public func intersects(_ other: Rect) -> Bool {
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

extension Rect {
    public func contains(_ point: Point) -> Bool {
        guard !self.isNull else { return false }
        guard !self.isEmpty else { return false }
        let r = self.standardized
        guard point.x >= r.minX else { return false }
        guard point.y >= r.minY else { return false }
        guard point.x < r.maxX else { return false }
        guard point.y < r.maxY else { return false }
        return true
    }

    public func contains(_ other: Rect) -> Bool {
        guard !self.isNull else { return false }
        guard !other.isNull else { return false }
        return self.union(other) == self
    }
}

public enum RectEdge {
    case minX
    case minY
    case maxX
    case maxY
}

extension Rect {
    public func divide(at distance: Double, from edge: RectEdge) -> (slice: Rect, remainder: Rect) {
        guard !self.isNull else { return (.null, .null) }
        guard distance > 0.0 else { return (.null, self) }
        let slice: Rect
        let remainder: Rect
        switch edge {
        case .minX:
            guard distance < width else { return (self, .null) }
            let x1 = minX
            let x2 = x1 + distance
            let x3 = maxX
            let y1 = minY
            let y2 = maxY
            slice = Rect(minX: x1, minY: y1, maxX: x2, maxY: y2)
            remainder = Rect(minX: x2, minY: y1, maxX: x3, maxY: y2)
        case .minY:
            guard distance < height else { return (self, .null) }
            let y1 = minY
            let y2 = y1 + distance
            let y3 = maxY
            let x1 = minX
            let x2 = maxX
            slice = Rect(minX: x1, minY: y1, maxX: x2, maxY: y2)
            remainder = Rect(minX: x1, minY: y2, maxX: x2, maxY: y3)
        case .maxX:
            guard distance < width else { return (self, .null) }
            let x3 = maxX
            let x2 = x3 - distance
            let x1 = minX
            let y1 = minY
            let y2 = maxY
            slice = Rect(minX: x2, minY: y1, maxX: x3, maxY: y2)
            remainder = Rect(minX: x1, minY: y1, maxX: x2, maxY: y2)
        case .maxY:
            guard distance < height else { return (self, .null) }
            let y3 = maxY
            let y2 = y3 - distance
            let y1 = minY
            let x1 = minX
            let x2 = maxX
            slice = Rect(minX: x1, minY: y2, maxX: x2, maxY: y3)
            remainder = Rect(minX: x1, minY: y1, maxX: x2, maxY: y2)
        }
        return (slice, remainder)
    }
}

extension Rect: ForwardInterpolable {
    public func interpolate(to other: Rect, at frac: Frac) -> Rect {
        return Rect(origin: origin.interpolate(to: other.origin, at: frac),
                    size: size.interpolate(to: other.size, at: frac))
    }
}

#if canImport(CoreGraphics)
import CoreGraphics

extension CGRect {
    public init(_ r: Rect) {
        self.init(origin: CGPoint(r.origin), size: CGSize(r.size))
    }
}
#endif
