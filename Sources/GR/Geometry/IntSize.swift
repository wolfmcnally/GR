//
//  IntSize.swift
//  
//
//  Created by Wolf McNally on 2/7/21.
//

import Foundation

public struct IntSize: Equatable, Hashable {
    public var width: Int
    public var height: Int
    
    @inlinable public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    @inlinable public init(_ s: Size) {
        self.width = Int(s.width)
        self.height = Int(s.height)
    }

    @inlinable public var maxX: Int { width - 1 }
    @inlinable public var maxY: Int { height - 1 }

    @inlinable public var rangeX: ClosedRange<Int> { 0 ... maxX }
    @inlinable public var rangeY: ClosedRange<Int> { 0 ... maxY }

    public static let none = -1
    public static let zero = IntSize(width: 0, height: 0)
    public static let max = IntSize(width: Int.max, height: Int.max)
}

extension IntSize : ExpressibleByArrayLiteral {
    public init(arrayLiteral a: Int...) {
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

extension IntSize {
    @inlinable public init(both n: Int) {
        self.init(width: n, height: n)
    }

    @inlinable public init(_ vector: IntVector) {
        self.width = vector.dx
        self.height = vector.dy
    }

    @inlinable public var bounds: IntRect {
        IntRect(origin: .zero, size: self)
    }

    @inlinable public var max: Int {
        Swift.max(width, height)
    }

    @inlinable public var min: Int {
        Swift.min(width, height)
    }
}

extension IntSize {
    @inlinable public var aspect: Double {
        Size(self).aspect
    }

    public func scaleForAspectFit(within size: IntSize) -> Double {
        Size(self).scaleForAspectFit(within: Size(size))
    }

    public func scaleForAspectFill(within size: IntSize) -> Double {
        Size(self).scaleForAspectFill(within: Size(size))
    }

    public func aspectFit(within size: IntSize) -> IntSize {
        IntSize(Size(self).aspectFit(within: Size(self)))
    }

    public func aspectFill(within size: IntSize) -> IntSize {
        IntSize(Size(self).aspectFill(within: Size(size)))
    }
}

extension IntSize: CustomDebugStringConvertible {
    public var debugDescription: String {
        return("IntSize(\(width), \(height))")
    }
}

extension IntSize {
    @inlinable public var isEmpty: Bool { width == 0 || height == 0 }
}

#if canImport(CoreGraphics)
import CoreGraphics

extension CGSize {
    public init(_ s: IntSize) {
        self.init(width: CGFloat(s.width), height: CGFloat(s.height))
    }
}
#endif
