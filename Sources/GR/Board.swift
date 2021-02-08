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

    public init(size: IntSize, tileSize: IntSize) {
        self.size = size
        self.bounds = size.bounds
        self.tileSize = tileSize
        syncBoard()
    }

    public var tileSize: IntSize
    public var size: IntSize
    public var bounds: IntRect

    public var canvasSize: IntSize {
        IntSize(width: tileSize.width * size.width, height: tileSize.height * size.height)
    }

    private func syncBoard() {
        cells = Array(repeating: Array(repeating: nil, count: bounds.width), count: bounds.height)
    }

    private func offsetForPoint(_ point: IntPoint) -> IntPoint {
        IntPoint(x: point.x * tileSize.width, y: point.y * tileSize.height)
    }

    public func valueAtPoint(_ point: IntPoint) -> TileValueType? {
        bounds.checkPoint(point)
        return cells[Int(point.y)][Int(point.x)]
    }

    public func setPoint(_ point: IntPoint, to value: TileValueType?) {
        bounds.checkPoint(point)
        cells[Int(point.y)][Int(point.x)] = value
    }

    public subscript(point: IntPoint) -> TileValueType? {
        get { valueAtPoint(point) }
        set { setPoint(point, to: newValue) }
    }

    public subscript(x: Int, y: Int) -> TileValueType? {
        get { valueAtPoint(IntPoint(x: x, y: y)) }
        set { setPoint(IntPoint(x: x, y: y), to: newValue) }
    }

    public func draw(into canvas: Canvas) {
        for y in bounds.rangeY {
            for x in bounds.rangeX {
                let point = IntPoint(x: x, y: y)
                let offset = offsetForPoint(point)
                if let value = cells[y][x] {
                    let shape = value.shape
                    shape.draw(into: canvas, position: offset)
                } else {
                    let clearColor = canvas.clearColor ?? .clear
                    for py in tileSize.rangeY {
                        for px in tileSize.rangeX {
                            let p = offset + IntVector(dx: px, dy: py)
                            canvas[p] = clearColor
                        }
                    }
                }
            }
        }
    }
}
