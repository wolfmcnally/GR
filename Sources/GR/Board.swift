//
//  Board.swift
//  GR
//
//  Created by Wolf McNally on 11/15/20.
//

import Foundation

public protocol TileValue {
    var shape: Shape { get }
}

public class Board<TileValueType: TileValue> {
    public var cells = [[TileValueType?]]()

    public init(size: Size, tileSize: Size) {
        self.size = size.intView
        self.bounds = size.bounds.intView
        self.tileSize = tileSize.intView
        syncBoard()
    }

    public var tileSize: Size.IntView
    public var size: Size.IntView
    public var bounds: Rect.IntView

    public var canvasSize: Size {
        Size(width: tileSize.width * size.width, height: tileSize.height * size.height)
    }

    private func syncBoard() {
        cells = Array(repeating: Array(repeating: nil, count: bounds.width), count: bounds.height)
    }

    private func offsetForPoint(_ point: Point.IntView) -> Point.IntView {
        Point(x: point.x * tileSize.width, y: point.y * tileSize.height).intView
    }

    public func valueAtPoint(_ point: Point.IntView) -> TileValueType? {
        bounds.checkPoint(point)
        return cells[Int(point.y)][Int(point.x)]
    }

    public func setPoint(_ point: Point.IntView, to value: TileValueType?) {
        bounds.checkPoint(point)
        cells[Int(point.y)][Int(point.x)] = value
    }

    public subscript(point: Point.IntView) -> TileValueType? {
        get { valueAtPoint(point) }
        set { setPoint(point, to: newValue) }
    }

    public subscript(x: Int, y: Int) -> TileValueType? {
        get { valueAtPoint(Point(x: x, y: y).intView) }
        set { setPoint(Point(x: x, y: y).intView, to: newValue) }
    }

    public func draw(into canvas: Canvas) {
        for y in bounds.rangeY {
            for x in bounds.rangeX {
                let point = Point(x: x, y: y).intView
                let offset = offsetForPoint(point)
                if let value = cells[y][x] {
                    let shape = value.shape
                    shape.draw(into: canvas, position: offset)
                } else {
                    let clearColor = canvas.clearColor ?? .clear
                    for py in tileSize.rangeY {
                        for px in tileSize.rangeX {
                            let p = offset.p + Vector(dx: px, dy: py)
                            canvas[p] = clearColor
                        }
                    }
                }
            }
        }
    }
}
