//
//  LayerSpec.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import Foundation

public struct LayerSpec {
    public var clearColor: Color

    public init(clearColor: Color = .black) {
        self.clearColor = clearColor
    }
}
