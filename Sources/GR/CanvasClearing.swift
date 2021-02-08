//
//  CanvasClearing.swift
//  GR
//
//  Created by Wolf McNally on 12/12/20.
//

import Foundation
import CoreGraphics

extension Canvas {
    public func clear(to color: Color) {
        invalidateImage()

        let bounds = CGRect(self.bounds)
        context.clear(bounds)

        if(color != .clear) {
            context.setFillColor(color.cgColor)
            context.fill(bounds)
        }
    }

    public func clear() {
        guard let clearColor = clearColor else { return }
        clear(to: clearColor)
    }
}
