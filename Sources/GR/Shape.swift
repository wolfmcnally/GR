//
//  Shape.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import Foundation

public struct Shape {
    public var colors: ColorTable {
        didSet {
            syncToColorTable()
        }
    }
    public var offset: IntVector
    public let size: IntSize
    public private(set) var rows: [String]
    private var unpackedRows: [[Color?]] = [[]]

    public init(colors: ColorTable = .standardColors, offset: IntVector = IntVector.zero, rows: [String] = []) {
        self.colors = colors
        self.offset = offset
        self.rows = rows
        self.size = IntSize(width: rows[0].count, height: rows.count)
        syncToColorTable()
    }

    private mutating func syncToColorTable() {
        unpackedRows = rows.map { row in
            row.map { c in
                colors[c]
            }
        }
    }

    public enum Mode {
        case fence  // abort if pixels are drawn outside of canvas
        case wrap   // pixels drawn off one side of the canvas are drawn on the other
        case clip   // pixles drawn off the side of the canvas are clipped
    }

    public func draw(into canvas: Canvas, position: IntPoint, mode: Mode = .fence) {
        let bounds = canvas.bounds
        for rowIndex in 0 ..< unpackedRows.count {
            var y = Int(position.y) - Int(offset.dy) + rowIndex
            switch mode {
            case .fence:
                break
            case .wrap:
                y = mod(y, bounds.maxY)
            case .clip:
                guard canvas.bounds.rangeY.contains(y) else { continue }
            }
            let row = unpackedRows[rowIndex]
            for (columnIndex, c) in row.enumerated() {
                guard let color = c else { continue }
                var x = Int(position.x) - Int(offset.dx) + columnIndex
                switch mode {
                case .fence:
                    break
                case .wrap:
                    x = mod(x, bounds.maxX)
                case .clip:
                    guard canvas.bounds.rangeX.contains(x) else { continue }
                }
                canvas[x, y] = color
            }
        }
    }
}
