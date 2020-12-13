//
//  ProgramView.swift
//  GR
//
//  Created by Wolf McNally on 11/15/20.
//

import SwiftUI
import UIKit

public struct ProgramView: UIViewRepresentable {
    public let program: Program

    public init(program: Program) {
        self.program = program
    }

    public func makeUIView(context: Context) -> ProgramUIView {
        let uiView = ProgramUIView()
        uiView.backgroundImage = UIImage(named: "scanlines")!
        uiView.backgroundTintColor = UIColor(white: 0.1, alpha: 1)
        uiView.program = program
        uiView.program.didDisplay = {
            uiView.flush()
        }
        uiView.program.update()
        uiView.program.display()
        return uiView
    }

    public func updateUIView(_ uiView: ProgramUIView, context: Context) {
    }
}
