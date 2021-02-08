//
//  CanvasPixelDrawing.swift
//  GR
//
//  Created by Wolf McNally on 12/12/20.
//

import Foundation

extension Canvas {
    public subscript(point: Point) -> Color {
        get { colorAtPoint(point) }
        set { setPoint(point, to: newValue) }
    }

    public subscript(point: IntPoint) -> Color {
        get { colorAtPoint(point) }
        set { setPoint(point, to: newValue) }
    }

    public subscript(x: Double, y: Double) -> Color {
        get { colorAtPoint(Point(x: x, y: y)) }
        set { setPoint(Point(x: x, y: y), to: newValue) }
    }

    public subscript(x: Int, y: Int) -> Color {
        get { colorAtPoint(Point(x: x, y: y)) }
        set { setPoint(Point(x: x, y: y), to: newValue) }
    }

    public func drawHorizontalLine(in xRange: Range<Double>, at y: Double, color: Color) {
        drawLine(from: Point(x: floor(xRange.lowerBound), y: y.snapped), to: Point(x: ceil(xRange.upperBound), y: y.snapped), color: color)
    }

    public func drawVerticalLine(in yRange: Range<Double>, at x: Double, color: Color) {
        drawLine(from: Point(x: x.snapped, y: floor(yRange.lowerBound)), to: Point(x: x.snapped, y: ceil(yRange.upperBound)), color: color)
    }

    public func drawHorizontalLine(in xRange: ClosedRange<Double>, at y: Double, color: Color) {
        drawLine(from: Point(x: floor(xRange.lowerBound), y: y.snapped), to: Point(x: ceil(xRange.upperBound + 1), y: y.snapped), color: color)
    }

    public func drawVerticalLine(in yRange: ClosedRange<Double>, at x: Double, color: Color) {
        drawLine(from: Point(x: x.snapped, y: floor(yRange.lowerBound)), to: Point(x: x.snapped, y: ceil(yRange.upperBound + 1)), color: color)
    }

    public func drawHorizontalLine(in xRange: ClosedRange<Int>, at y: Int, color: Color) {
        drawLine(from: Point(x: Double(xRange.lowerBound), y: Double(y) + 0.5), to: Point(x: Double(xRange.upperBound) + 1, y: Double(y) + 0.5), color: color)
    }

    public func drawVerticalLine(in yRange: ClosedRange<Int>, at x: Int, color: Color) {
        drawLine(from: Point(x: Double(x) + 0.5, y: Double(yRange.lowerBound)), to: Point(x: Double(x) + 0.5, y: Double(yRange.upperBound) + 1), color: color)
    }
}
