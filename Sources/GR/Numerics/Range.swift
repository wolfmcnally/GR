//
//  Range.swift
//  GR
//
//  Created by Wolf McNally on 11/30/20.
//

import Foundation

extension Range where Bound: FloatingPoint {
    public func strideTo<N>(by stride: N = 1) -> StrideTo<Bound> where N == Bound.Stride {
        return Swift.stride(from: lowerBound, to: upperBound, by: stride)
    }
}

extension ClosedRange where Bound: FloatingPoint {
    public func strideTo<N>(by stride: N = 1) -> StrideTo<Bound> where N == Bound.Stride {
        return Swift.stride(from: lowerBound, to: upperBound, by: stride)
    }

    public func strideThrough<N>(by stride: N = 1) -> StrideThrough<Bound> where N == Bound.Stride {
        return Swift.stride(from: lowerBound, through: upperBound, by: stride)
    }
}
