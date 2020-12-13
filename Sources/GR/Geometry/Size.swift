//
//  Size.swift
//  GR
//
//  Created by Wolf McNally on 11/15/20.
//

import Foundation
import Interpolate

public struct Size: Equatable {
    public var simd: SIMD2<Double>

    @inlinable public init<N: BinaryInteger>(width: N, height: N) {
        simd = [Double(width), Double(height)]
    }

    @inlinable public init<N: BinaryFloatingPoint>(width: N, height: N) {
        simd = [Double(width), Double(height)]
    }

    @inlinable public init(_ s: SIMD2<Double>) {
        self.simd = s
    }

    @inlinable public var width: Double {
        get { simd.x }
        set { simd.x = newValue }
    }

    @inlinable public var height: Double {
        get { simd.y }
        set { simd.y = newValue }
    }

    @inlinable public var rangeX: ClosedRange<Double> { 0 ... width }
    @inlinable public var rangeY: ClosedRange<Double> { 0 ... height }

    public static let none = -1.0
    public static let zero = Size(width: 0, height: 0)
    public static let infinite = Size(width: Double.infinity, height: Double.infinity)

    public struct IntView {
        public let s: Size

        @inlinable init(_ s: Size) { self.s = s }

        @inlinable public var width: Int { Int(s.width) }
        @inlinable public var height: Int { Int(s.height) }

        @inlinable public var maxX: Int { width - 1 }
        @inlinable public var maxY: Int { height - 1 }

        @inlinable public var rangeX: ClosedRange<Int> { 0 ... maxX }
        @inlinable public var rangeY: ClosedRange<Int> { 0 ... maxY }
    }

    public var intView: IntView { IntView(self) }
}

extension Size : ExpressibleByArrayLiteral {
    public init(arrayLiteral a: Double...) {
        assert(a.count == 2)
        simd = [a[0], a[1]]
    }
}

extension Size {
//    @inlinable public init(_ other: ISize) {
//        self.init([Double(other.width), Double(other.height)])
//    }

    @inlinable public init(both n: Double) {
        self.init(width: n, height: n)
    }

    @inlinable public init(_ vector: Vector) {
        simd = vector.simd
    }

    @inlinable public var aspect: Double {
        width / height
    }

    @inlinable public var bounds: Rect {
        Rect(origin: .zero, size: self)
    }

    public func scaleForAspectFit(within size: Size) -> Double {
        if size.width != Size.none && size.height != Size.none {
            return Swift.min(size.width / width, size.height / height)
        } else if size.width != Size.none {
            return size.width / width
        } else {
            return size.height / height
        }
    }

    public func scaleForAspectFill(within size: Size) -> Double {
        if size.width != Size.none && size.height != Size.none {
            return Swift.max(size.width / width, size.height / height)
        } else if size.width != Size.none {
            return size.width / width
        } else {
            return size.height / height
        }
    }

    public func aspectFit(within size: Size) -> Size {
        let scale = scaleForAspectFit(within: size)
        return Size(Vector(self) * scale)
    }

    public func aspectFill(within size: Size) -> Size {
        let scale = scaleForAspectFill(within: size)
        return Size(Vector(self) * scale)
    }

    @inlinable public var max: Double {
        Swift.max(width, height)
    }

    @inlinable public var min: Double {
        Swift.min(width, height)
    }
}

extension Size: CustomStringConvertible {
    public var description: String {
        return("Size(\(width), \(height))")
    }
}

extension Size {
    @inlinable public var isEmpty: Bool { width == 0.0 || height == 0.0 }
}

@inlinable public func * (lhs: Size, rhs: Double) -> Size {
    Size(lhs.simd * rhs)
}

@inlinable public func / (lhs: Size, rhs: Double) -> Size {
    Size(lhs.simd / rhs)
}

extension Size: ForwardInterpolable {
    public func interpolate(to other: Size, at frac: Frac) -> Size {
        Size(width: width.interpolate(to: other.width, at: frac),
                    height: height.interpolate(to: other.height, at: frac))
    }
}

#if canImport(CoreGraphics)
import CoreGraphics

extension CGSize {
    public init(_ s: Size) {
        self.init(width: CGFloat(s.width), height: CGFloat(s.height))
    }
}
#endif
