import Foundation
import CoreGraphics

public struct Path : ExpressibleByArrayLiteral {
    public var cgPath: CGPath

    public enum Element {
        case moveTo(Point)
        case addLine(Point)
        case addLines([Point])
        case close
    }

    @inlinable public init(_ cgPath: CGMutablePath) {
        self.cgPath = cgPath
    }

    @inlinable public init(_ elems: [Element]) {
        let path = CGMutablePath()
        for elem in elems {
            switch elem {
            case .moveTo(let point):
                path.move(to: CGPoint(point))
            case .addLine(let point):
                path.addLine(to: CGPoint(point))
            case .addLines(let points):
                path.addLines(between: points.map { CGPoint($0) })
            case .close:
                path.closeSubpath()
            }
        }
        self.cgPath = path
    }
    
    @inlinable public init(rect: Rect) {
        self.cgPath = CGPath(rect: CGRect(rect), transform: nil)
    }
    
    @inlinable public init(circleCenter center: Point, radius: Double) {
        let rect = Rect(origin: center, size: .zero).inset(dx: -radius, dy: -radius)
        self.cgPath = CGPath(ellipseIn: CGRect(rect), transform: nil)
    }

    @inlinable public init(arrayLiteral: Element...) {
        self.init(arrayLiteral)
    }

    @inlinable public func transformed(by transform: Transform) -> Path {
        withUnsafePointer(to: transform.cgTransform) { t in
            if let newPath = cgPath.mutableCopy(using: t) {
                return Path(newPath)
            } else {
                return self
            }
        }
    }

    @inlinable public func scaled(by vector: Vector) -> Path {
        transformed(by: .init(scale: vector))
    }

    @inlinable public func scaled(by scale: Double) -> Path {
        transformed(by: .init(scale: [scale, scale]))
    }

    @inlinable public func translated(by vector: Vector) -> Path {
        transformed(by: .init(translation: vector))
    }

    @inlinable public func translated(by point: Point) -> Path {
        transformed(by: .init(translation: point))
    }

    @inlinable public func rotated(by angle: Angle) -> Path {
        transformed(by: .init(rotationAngle: angle))
    }
}
