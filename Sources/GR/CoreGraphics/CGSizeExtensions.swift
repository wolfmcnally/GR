//
//  CGSizeExtensions.swift
//  GR
//
//  Created by Wolf McNally on 11/15/20.
//

import CoreGraphics
import UIKit

let noSize = UIView.noIntrinsicMetric

extension CGSize {
    init(both n: CGFloat) {
        self.init(width: n, height: n)
    }

    init(vector: CGVector) {
        self.init(width: vector.dx, height: vector.dy)
    }

    var aspect: CGFloat {
        width / height
    }

    func scaleForAspectFit(within size: CGSize) -> CGFloat {
        if size.width != noSize && size.height != noSize {
            return Swift.min(size.width / width, size.height / height)
        } else if size.width != noSize {
            return size.width / width
        } else {
            return size.height / height
        }
    }

    func scaleForAspectFill(within size: CGSize) -> CGFloat {
        if size.width != noSize && size.height != noSize {
            return Swift.max(size.width / width, size.height / height)
        } else if size.width != noSize {
            return size.width / width
        } else {
            return 1.0
        }
    }

    func aspectFit(within size: CGSize) -> CGSize {
        let scale = scaleForAspectFit(within: size)
        return CGSize(vector: CGVector(size: self) * scale)
    }

    func aspectFill(within size: CGSize) -> CGSize {
        let scale = scaleForAspectFill(within: size)
        return CGSize(vector: CGVector(size: self) * scale)
    }

    var max: CGFloat {
        Swift.max(width, height)
    }

    var min: CGFloat {
        Swift.min(width, height)
    }

    func swapped() -> CGSize {
        CGSize(width: height, height: width)
    }

    var bounds: CGRect {
        CGRect(origin: .zero, size: self)
    }

    var asPoint: CGPoint {
        CGPoint(x: width, y: height)
    }
}

func + (left: CGSize, right: CGSize) -> CGVector {
    CGVector(dx: left.width + right.width, dy: left.height + right.height)
}

func - (left: CGSize, right: CGSize) -> CGVector {
    CGVector(dx: left.width - right.width, dy: left.height - right.height)
}

func + (left: CGSize, right: CGVector) -> CGSize {
    CGSize(width: left.width + right.dx, height: left.height + right.dy)
}

func - (left: CGSize, right: CGVector) -> CGSize {
    CGSize(width: left.width - right.dx, height: left.height - right.dy)
}

func + (left: CGVector, right: CGSize) -> CGSize {
    CGSize(width: left.dx + right.width, height: left.dy + right.height)
}

func - (left: CGVector, right: CGSize) -> CGSize {
    CGSize(width: left.dx - right.width, height: left.dy - right.height)
}

func * (left: CGSize, right: CGFloat) -> CGSize {
    CGSize(width: left.width * right, height: left.height * right)
}
