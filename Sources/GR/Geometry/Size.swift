//
//  Size.swift
//  GR
//
//  Created by Wolf McNally on 11/15/20.
//

import Foundation
import Interpolate

public struct Size: Equatable, Hashable {
    public var width: Double
    public var height: Double

    @inlinable public init<N: BinaryInteger>(width: N, height: N) {
        self.width = Double(width)
        self.height = Double(height)
    }

    @inlinable public init<N: BinaryFloatingPoint>(width: N, height: N) {
        self.width = Double(width)
        self.height = Double(height)
    }

    @inlinable public init(_ s: SIMD2<Double>) {
        self.width = s.x
        self.height = s.y
    }
    
    @inlinable public init(_ s: IntSize) {
        self.width = Double(s.width)
        self.height = Double(s.height)
    }
    
    public var simd: SIMD2<Double> {
        [width, height]
    }

    @inlinable public var rangeX: ClosedRange<Double> { 0 ... width }
    @inlinable public var rangeY: ClosedRange<Double> { 0 ... height }

    public static let none = -1.0
    public static let zero = Size(width: 0, height: 0)
    public static let infinite = Size(width: Double.infinity, height: Double.infinity)
}

extension Size : ExpressibleByArrayLiteral {
    public init(arrayLiteral a: Double...) {
        if a.isEmpty {
            self.width = 0
            self.height = 0
        } else {
            assert(a.count == 2)
            self.width = a[0]
            self.height = a[1]
        }
    }
}

extension Size {
    @inlinable public init(both n: Double) {
        self.init(width: n, height: n)
    }

    @inlinable public init(_ vector: Vector) {
        self.width = vector.dx
        self.height = vector.dy
    }

    @inlinable public var bounds: Rect {
        Rect(origin: .zero, size: self)
    }

    @inlinable public var max: Double {
        Swift.max(width, height)
    }

    @inlinable public var min: Double {
        Swift.min(width, height)
    }
}

extension Size {
    @inlinable public var aspect: Double {
        width / height
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
}

extension Size: CustomDebugStringConvertible {
    public var debugDescription: String {
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
