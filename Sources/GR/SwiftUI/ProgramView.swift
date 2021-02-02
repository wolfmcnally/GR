//
//  File.swift
//  
//
//  Created by Wolf McNally on 1/28/21.
//

import SwiftUI

public struct ProgramView<Header>: View where Header: View {
    let program: Program
    let header: Header
    
    public init(_ programType: Program.Type, @ViewBuilder header: () -> Header) {
        self.program = programType.init()
        self.header = header()
    }
    
    public var body: some View {
        ZStack {
            Rectangle()
                .fill(SwiftUI.Color(UIColor(white: 0.5, alpha: 0.1)))
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                header
                    .padding()
                ProgramUIViewWrapper(program)
                    .navigationBarItems(trailing: restartButton)
            }
        }
    }

    var restartButton: some View {
        Button {
            program.restart()
        } label: {
            Image(systemName: "arrow.uturn.left")
                .font(.title)
        }
    }
}
