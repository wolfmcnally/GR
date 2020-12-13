//
//  StringUtils.swift
//  GR
//
//  Created by Wolf McNally on 11/15/20.
//

import Foundation

public class Joiner {
    var left: String
    var right: String
    var separator: String
    var objs = [Any]()
    var count: Int { return objs.count }
    public var isEmpty: Bool { return objs.isEmpty }

    public init(left: String = "", separator: String = " ", right: String = "") {
        self.left = left
        self.right = right
        self.separator = separator
    }

    public func append(_ objs: Any...) {
        self.objs.append(contentsOf: objs)
    }

    public func append<S: Sequence>(contentsOf newElements: S) {
        for element in newElements {
            objs.append(element)
        }
    }

    public var result: String {
        var s = [String]()
        for o in objs {
            s.append("\(o)")
        }
        let t = s.joined(separator: separator)
        return "\(left)\(t)\(right)"
    }
}

extension Joiner: CustomStringConvertible {
    public var description: String {
        return result
    }
}

public func += (lhs: Joiner, rhs: Any) {
    lhs.append(rhs)
}

extension NSNumber {
    public convenience init<T: BinaryFloatingPoint>(value: T) {
        self.init(value: Double(value))
    }
}

extension String {
    public init<T: BinaryFloatingPoint>(_ value: T, precision: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = precision
        self.init(formatter.string(from: NSNumber(value: value))!)
    }
}

precedencegroup AttributeAssignmentPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: ComparisonPrecedence
}

infix operator %% : AttributeAssignmentPrecedence

public func %% <T: BinaryFloatingPoint>(left: T, right: Int) -> String {
    return String(left, precision: right)
}
