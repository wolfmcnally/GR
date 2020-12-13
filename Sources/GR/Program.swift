//
//  Program.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import Foundation

open class Program {
    private var _canvasSize = Size(width: 40, height: 40)
    private var _framesPerSecond: Float = 0.0
    private var needsDisplay: Bool = true
    public var didDisplay: (() -> Void)?
    public private(set) var frameNumber = 0
    public var onScreenChanged: ((ScreenSpec) -> Void)?

    public var screenSpec = ScreenSpec(mainLayer: 1, layerSpecs: [
            LayerSpec(clearColor: Color(color: .white, alpha: 0.05)),
            LayerSpec(clearColor: .clear)
        ]) {
        didSet { resetScreen() }
    }

    public private(set) var layers = [Canvas]()

    public var canvas: Canvas {
        layers[screenSpec.mainLayer]
    }

    public var canvasClearColor: Color? {
        get { canvas.clearColor }
        set { canvas.clearColor = newValue }
    }

    public var backgroundCanvas: Canvas {
        layers[screenSpec.mainLayer - 1]
    }

    public var backgroundCanvasClearColor: Color? {
        get { backgroundCanvas.clearColor }
        set { backgroundCanvas.clearColor = newValue }
    }

    private func resetScreen() {
        layers.removeAll()
        for layerSpec in screenSpec.layerSpecs {
            let layer = Canvas(size: canvasSize, clearColor: layerSpec.clearColor)
            layers.append(layer)
        }
        onScreenChanged?(screenSpec)
    }

    public var canvasSize: Size {
        get { screenSpec.canvasSize }
        set { screenSpec.canvasSize = newValue }
    }

    private var displayLink: DisplayLink?
    private var displayLinkFrameCounter = 0

    public var framesPerSecond: Int = 0 {
        didSet {
            displayLink?.invalidate()
            displayLinkFrameCounter = 0
            guard framesPerSecond > 0 else { return }
            displayLink = DisplayLink(preferredFramesPerSecond: framesPerSecond) { [unowned self] _ in
                DispatchQueue.main.async {
                    defer { self.displayLinkFrameCounter += 1}
                    guard self.displayLinkFrameCounter > 1 else { return }
                    self._update()
                    self.displayIfNeeded()
                }
            }
        }
    }

    public init() {
        _setup()
    }

    private func _setup() {
        resetScreen()
        setup()
    }

    private var lastUpdateTime: TimeInterval?
    private var averageElapsedTime: TimeInterval?

    private func _update() {
        frameNumber += 1

        let updateTime = Date.timeIntervalSinceReferenceDate
        if let lastUpdateTime = lastUpdateTime {
            let elapsedTime = updateTime - lastUpdateTime
            if let averageElapsedTime = averageElapsedTime {
                self.averageElapsedTime = (elapsedTime + averageElapsedTime) / 2
            } else {
                averageElapsedTime = elapsedTime
            }
            //            print("target: \(1.0 / framesPerSecond) elapsed: \(elapsedTime) averageElapsed: \(averageElapsedTime!)")
        }
        lastUpdateTime = updateTime

        update()
        needsDisplay = true
    }

    public func display() {
        clear()
        draw()
        didDisplay?()
    }

    private func displayIfNeeded() {
        if needsDisplay {
            display()
            needsDisplay = false
        }
    }

    open func clear() {
        for layer in layers {
            layer.clear()
        }
    }

    open func setup() { }
    open func update() { }
    open func draw() { }

    // macOS
    open func mouseDown(at point: Point) { }
    open func mouseDragged(at point: Point) { }
    open func mouseUp(at point: Point) { }

    open func mouseEntered(at point: Point) { }
    open func mouseMoved(at point: Point) { }
    open func mouseExited(at point: Point) { }

    open func keyDown(with key: Key) { }
    open func keyUp(with key: Key) { }

    // iOS
    open func touchBegan(at point: Point) { }
    open func touchMoved(at point: Point) { }
    open func touchEnded(at point: Point) { }
    open func touchCancelled(at point: Point) { }

    // tvOS
    open func directionButtonPressed(in direction: Direction) { }
    open func directionButtonReleased(in direction: Direction) { }
    open func swiped(in direction: Direction) { }
}
