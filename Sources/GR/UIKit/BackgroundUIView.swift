//
//  BackgroundUIView.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import UIKit

class BackgroundUIView : UIKitImageView {
    override func setup() {
        super.setup()

        contentMode = .scaleAspectFill
        backgroundColor = UIColor.black
    }

    var backgroundTintColor: UIColor? {
        get { return tintColor }
        set { tintColor = newValue }
    }
}
