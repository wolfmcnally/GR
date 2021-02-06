//
//  ProgramDisplay.swift
//  
//
//  Created by Wolf McNally on 1/28/21.
//

import SwiftUI

public struct ProgramDisplay<Header>: View where Header: View {
    let programType: Program.Type
    @State private var program: Program?
    let header: Header
    
    public init(_ programType: Program.Type, @ViewBuilder header: () -> Header) {
        self.programType = programType
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
                if let program = program {
                    ProgramView(program)
                        .navigationBarItems(trailing: restartButton)
                }
            }
        }
        .onAppear {
            program = programType.init()
        }
        .onDisappear {
            program = nil
        }
    }

    var restartButton: some View {
        Button { [weak program] in
            program?.restart()
        } label: {
            Image(systemName: "arrow.uturn.left")
                .font(.title)
        }
    }
}
