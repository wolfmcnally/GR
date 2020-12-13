//
//  CanvasDrawing.swift
//  GR
//
//  Created by Wolf McNally on 12/12/20.
//

import Foundation
import CoreGraphics

public enum LineJoin: Int {
    case miter
    case round
    case bevel

    @inlinable public var cgLineJoin: CGLineJoin {
        CGLineJoin(rawValue: Int32(rawValue))!
    }
}

public enum LineCap: Int {
    case butt
    case round
    case square

    @inlinable public var cgLineCap: CGLineCap {
        CGLineCap(rawValue: Int32(rawValue))!
    }
}

extension Canvas {
    public func drawLine(from p1: Point, to p2: Point, color: Color, lineWidth: Double = 1, lineCap: LineCap = .butt) {
        invalidateImage()

        context.move(to: CGPoint(p1))
        context.addLine(to: CGPoint(p2))
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(CGFloat(lineWidth))
        context.setLineCap(lineCap.cgLineCap)
        context.drawPath(using: .stroke)
    }

    public func draw(path: Path, color: Color, lineWidth: Double = 1, lineJoin: LineJoin = .miter, lineCap: LineCap = .butt) {
        invalidateImage()

        context.addPath(path.cgPath)
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(CGFloat(lineWidth))
        context.setLineJoin(lineJoin.cgLineJoin)
        context.setLineCap(lineCap.cgLineCap)
        context.strokePath()
    }
}
