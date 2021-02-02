//
//  Canvas.swift
//  GR
//
//  Created by Wolf McNally on 11/28/20.
//


import Foundation
import UIKit
import Metal

public final class Canvas {
    public let bounds: Rect
    public var clearColor: Color?

    let device: MTLDevice
//    let texture: MTLTexture

    let context: CGContext
    private let bytesPerRow: Int
    private let allocationSize: Int
    private let data: UnsafeMutablePointer<UInt8>
    private var _image: UIImage?

    private struct Pixel {
        typealias Component = UInt8

        var r: Component
        var g: Component
        var b: Component
        var a: Component

        static let bitsPerComponent = MemoryLayout<Component>.size * 8
        static let bytesPerPixel = MemoryLayout<Self>.size
        static let metalPixelFormat: MTLPixelFormat = .rgba8Unorm
    }

    public init(size: Size, clearColor: Color = .black) {
        self.bounds = size.bounds
        self.clearColor = clearColor

        let width = Int(size.width)
        let height = Int(size.height)

        assert(width >= 1)
        assert(height >= 1)

        // https://medium.com/@s1ddok/combine-the-power-of-coregraphics-and-metal-by-sharing-resource-memory-eabb4c1be615
        let device = MTLCreateSystemDefaultDevice()!
        let pixelRowAlignment = device.minimumLinearTextureAlignment(for: Pixel.metalPixelFormat)
        let minBytesPerRow = width * Pixel.bytesPerPixel
        let bytesPerRow = Self.alignUp(size: minBytesPerRow, align: pixelRowAlignment)
        let pagesize = Int(getpagesize())
        let allocationSize = Self.alignUp(size: bytesPerRow * height, align: pagesize)
        let rawData = mmap(nil, allocationSize, PROT_READ | PROT_WRITE, MAP_ANON | MAP_SHARED, 0, 0)!
        let data = UnsafeMutablePointer<UInt8>(OpaquePointer(rawData))

        let bitmapInfo: CGBitmapInfo = []
        let alphaInfo: CGImageAlphaInfo = .premultipliedLast
        let bitmapInfoRaw = bitmapInfo.rawValue | alphaInfo.rawValue

        let context = CGContext(data: data, width: width, height: height, bitsPerComponent: Pixel.bitsPerComponent, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfoRaw)!
        assert(context.bytesPerRow == bytesPerRow)
        context.translateBy(x: 0, y: CGFloat(size.height))
        context.scaleBy(x: 1, y: -1)

//        let buffer = device.makeBuffer(bytesNoCopy: rawData, length: allocationSize, options: .storageModeShared, deallocator: nil)!

//        let textureDescriptor = MTLTextureDescriptor()
//        textureDescriptor.pixelFormat = Pixel.metalPixelFormat
//        textureDescriptor.width = width
//        textureDescriptor.height = height
//        textureDescriptor.storageMode = .shared
//        textureDescriptor.usage = .shaderRead
//
//        let texture = buffer.makeTexture(descriptor: textureDescriptor, offset: 0, bytesPerRow: bytesPerRow)!

        self.device = device
        self.bytesPerRow = bytesPerRow
        self.allocationSize = allocationSize
        self.data = data
        self.context = context
//        self.texture = texture
    }

    deinit {
        munmap(data, allocationSize)
    }

    // Returns a size of the 'inSize' aligned to 'align' as long as align is a power of 2
    private static func alignUp(size: Int, align: Int) -> Int {
        let alignmentMask = align - 1
        assert(alignmentMask & align == 0, "Align must be a power of two")
        return (size + alignmentMask) & ~alignmentMask
    }

    public var isImageValid: Bool {
        return self._image != nil
    }

    public var image: UIImage {
        if _image == nil {
            _image = UIImage(cgImage: context.makeImage()!)
        }

        return _image!
    }

    func invalidateImage() {
        self._image = nil
    }

    private func offsetForPoint(_ point: Point.IntView) -> Int {
        point.y * bytesPerRow + point.x * Pixel.bytesPerPixel
    }

    public func setPoint(_ point: Point, to color: Color) {
        let p = point.intView
        bounds.intView.checkPoint(p)

        invalidateImage()

        let pixel = data.advanced(by: offsetForPoint(p))
        let alpha = color.alpha.clamped
        pixel[0] = UInt8(color.red.clamped * alpha * 255)
        pixel[1] = UInt8(color.green.clamped * alpha * 255)
        pixel[2] = UInt8(color.blue.clamped * alpha * 255)
        pixel[3] = UInt8(alpha * 255)
    }

    public func colorAtPoint(_ point: Point) -> Color {
        let p = point.intView
        bounds.intView.checkPoint(p)
        let pixel = data.advanced(by: offsetForPoint(p))
        let r = Double(pixel[0]) / 255
        let g = Double(pixel[1]) / 255
        let b = Double(pixel[2]) / 255
        let a = Double(pixel[3]) / 255
        return Color(red: r, green: g, blue: b, alpha: a)
    }
}
