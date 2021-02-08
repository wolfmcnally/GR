//
//  ScreenSpec.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import Foundation

public struct ScreenSpec {
    public var canvasSize: IntSize
    public var mainLayer: Int
    public var layerSpecs: [LayerSpec]

    public init(canvasSize: IntSize = IntSize(width: 40, height: 40), mainLayer: Int, layerSpecs: [LayerSpec]) {
        self.canvasSize = canvasSize
        self.mainLayer = mainLayer
        self.layerSpecs = layerSpecs
    }
}
