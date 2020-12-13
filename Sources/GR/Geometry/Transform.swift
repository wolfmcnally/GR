import Foundation
import CoreGraphics

public struct Transform: Equatable {
    public var cgTransform: CGAffineTransform

    @inlinable public init(_ cgTransform: CGAffineTransform) {
        self.cgTransform = cgTransform
    }

    @inlinable public init(rotationAngle: Double) {
        cgTransform = CGAffineTransform(rotationAngle: CGFloat(rotationAngle))
    }

    @inlinable public init(scaleX x: Double, y: Double) {
        cgTransform = CGAffineTransform(scaleX: CGFloat(x), y: CGFloat(y))
    }

    @inlinable public init(scale v: Vector) {
        cgTransform = CGAffineTransform(scaleX: CGFloat(v.dx), y: CGFloat(v.dy))
    }

    @inlinable public init(translationX x: Double, y: Double) {
        cgTransform = CGAffineTransform(translationX: CGFloat(x), y: CGFloat(y))
    }

    @inlinable public init(translation v: Point) {
        cgTransform = CGAffineTransform(translationX: CGFloat(v.x), y: CGFloat(v.y))
    }

    @inlinable public init(translation v: Vector) {
        cgTransform = CGAffineTransform(translationX: CGFloat(v.dx), y: CGFloat(v.dy))
    }

    @inlinable public init() {
        cgTransform = CGAffineTransform()
    }

    @inlinable public init(a: Double, b: Double, c: Double, d: Double, tx: Double, ty: Double) {
        cgTransform = CGAffineTransform(a: CGFloat(a), b: CGFloat(b), c: CGFloat(c), d: CGFloat(d), tx: CGFloat(tx), ty: CGFloat(ty))
    }

    @inlinable public var isIdentity: Bool {
        cgTransform.isIdentity
    }

    @inlinable public var a: Double {
        get { Double(cgTransform.a) }
        set { cgTransform.a = CGFloat(newValue) }
    }

    @inlinable public var b: Double {
        get { Double(cgTransform.b) }
        set { cgTransform.b = CGFloat(newValue) }
    }

    @inlinable public var c: Double {
        get { Double(cgTransform.c) }
        set { cgTransform.c = CGFloat(newValue) }
    }

    @inlinable public var d: Double {
        get { Double(cgTransform.d) }
        set { cgTransform.d = CGFloat(newValue) }
    }

    @inlinable public var tx: Double {
        get { Double(cgTransform.tx) }
        set { cgTransform.tx = CGFloat(newValue) }
    }

    @inlinable public var ty: Double {
        get { Double(cgTransform.ty) }
        set { cgTransform.ty = CGFloat(newValue) }
    }

    public static let identity: Transform = Transform()

    @inlinable public func concatenating(_ other: Transform) -> Transform {
        Transform(cgTransform.concatenating(other.cgTransform))
    }

    @inlinable public func inverted() -> Transform {
        Transform(cgTransform.inverted())
    }

    @inlinable public func rotated(by angle: Double) -> Transform {
        Transform(cgTransform.rotated(by: CGFloat(angle)))
    }

    @inlinable public func scaledBy(x: Double, y: Double) -> Transform {
        Transform(cgTransform.scaledBy(x: CGFloat(x), y: CGFloat(y)))
    }

    @inlinable public func scaledBy(_ v: Vector) -> Transform {
        scaledBy(x: v.dx, y: v.dy)
    }

    @inlinable public func translatedBy(x: Double, y: Double) -> Transform {
        Transform(cgTransform.translatedBy(x: CGFloat(x), y: CGFloat(y)))
    }

    @inlinable public func translatedBy(_ v: Vector) -> Transform {
        translatedBy(x: v.dx, y: v.dy)
    }
}
