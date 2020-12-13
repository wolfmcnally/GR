//
//  ColorTable.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import Foundation

public struct ColorTable {
    public var colors: [Character: Color?] = [:]
    private var lookup: [[Unicode.Scalar]: Color?] = [:]

    public init(_ colors: [Character: Color?]) {
        self.colors = colors
        self.lookup = Dictionary(uniqueKeysWithValues: colors.map {
            return (Array($0.key.unicodeScalars), $0.value)
        })
    }

    public subscript(c: Character) -> Color? {
        get {
            let a: [Unicode.Scalar] = Array(c.unicodeScalars)
            return lookup[a]!
        }

        set {
            colors[c] = newValue
            let a: [Unicode.Scalar] = Array(c.unicodeScalars)
            lookup[a] = newValue
        }
    }

    public static let standardColors = ColorTable([
        "❔": nil,
        "⚪️": .clear,
        "💣": .black,
        "💭": .white,
        "🐺": .gray,
        "❤️": .red,
        "🍊": .orange,
        "🍋": .yellow,
        "🍏": .green,
        "🦋": .blue,
        "🍇": .purple,
        "🌸": .pink,
        "🐻": .brown
    ])
}
