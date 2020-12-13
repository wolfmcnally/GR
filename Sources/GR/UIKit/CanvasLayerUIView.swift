//
//  CanvasLayerUIView.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import UIKit

class CanvasLayerUIView: UIKitView {
    override func setup() {
        super.setup()
        layer.magnificationFilter = .nearest
    }

    var image: UIImage? {
        didSet {
            layer.contents = image!.cgImage
        }
    }
}

