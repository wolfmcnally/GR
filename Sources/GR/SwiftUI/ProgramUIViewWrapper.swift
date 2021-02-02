//
//  ProgramUIViewWrapper.swift
//  GR
//
//  Created by Wolf McNally on 11/15/20.
//

import SwiftUI
import UIKit

public struct ProgramUIViewWrapper: UIViewRepresentable {
    let program: Program

    public init(_ program: Program) {
        self.program = program
    }

    public func makeUIView(context: Context) -> ProgramUIView {
        let uiView = ProgramUIView()
        uiView.program = program
        uiView.program.didDisplay = {
            uiView.flush()
        }
        uiView.program.restart()
        return uiView
    }

    public func updateUIView(_ uiView: ProgramUIView, context: Context) {
    }
}
