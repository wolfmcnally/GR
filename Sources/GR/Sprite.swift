//
//  Sprite.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import Foundation

public protocol Sprite {
    var shape: Shape { get }
    var position: IntPoint { get }
    var mode: Shape.Mode { get }

    func draw(into canvas: Canvas)
}

extension Sprite {
    public func draw(into canvas: Canvas) {
        shape.draw(into: canvas, position: position, mode: mode)
    }
}

open class SimpleSprite: Sprite {
    public var shape: Shape
    public var position: IntPoint
    public var mode: Shape.Mode

    public init(shape: Shape, position: IntPoint = .zero, mode: Shape.Mode = .fence) {
        self.shape = shape
        self.position = position
        self.mode = mode
    }
}
