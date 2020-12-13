//
//  ProgramUIView.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import UIKit
import Interpolate

public class ProgramUIView: UIKitView {
    public var program: Program! {
        didSet {
            syncToProgram()
        }
    }
    private var canvasView: CanvasUIView! {
        didSet {
            syncToProgram()
        }
    }

    private var backgroundView: BackgroundUIView!

    public var backgroundImage: UIImage? {
        get { return backgroundView.image }
        set { backgroundView.image = newValue }
    }

    public var backgroundTintColor: UIColor? {
        get { return backgroundView.backgroundTintColor }
        set { backgroundView.backgroundTintColor = newValue }
    }

    override public func setup() {
        super.setup()
        addBackgroundView()
        addCanvasView()
    }

    private func syncToProgram() {
        guard let program = program else { return }
        program.onScreenChanged = { [unowned self] screenSpec in
            self.canvasView?.screenSpec = screenSpec
        }
        canvasView?.screenSpec = program.screenSpec
    }

    func addBackgroundView() {
        backgroundView = BackgroundUIView(frame: bounds)
        addSubview(backgroundView)
        backgroundView.requireSameFrameAsSuperview()
    }

    func addCanvasView() {
        canvasView = CanvasUIView(frame: bounds)
        addSubview(canvasView)
        canvasView.requireSameFrameAsSuperview()

        canvasView.touchBegan = { [unowned self] point in
            self.program.touchBegan(at: self.canvasPointForCanvasViewPoint(point))
        }

        canvasView.touchMoved = { [unowned self] point in
            self.program.touchMoved(at: self.canvasPointForCanvasViewPoint(point))
        }

        canvasView.touchEnded = { [unowned self] point in
            self.program.touchEnded(at: self.canvasPointForCanvasViewPoint(point))
        }

        canvasView.touchCancelled = { [unowned self] point in
            self.program.touchCancelled(at: self.canvasPointForCanvasViewPoint(point))
        }

        #if os(tvOS)
        canvasView.swiped = { direction in
            self.program.swiped(in: direction)
        }
        canvasView.directionButtonPressed = { direction in
            self.program.directionButtonPressed(in: direction)
        }
        canvasView.directionButtonReleased = { direction in
            self.program.directionButtonReleased(in: direction)
        }
        #endif
    }

    public func flush() {
        for (view, canvas) in zip(canvasView.layerViews, program.layers) {
            view.image = canvas.image
        }
    }

    func canvasPointForCanvasViewPoint(_ point: CGPoint) -> Point {
        let canvasImageSize = program.canvas.image.size
        let canvasImageSizeScaled = canvasImageSize.aspectFit(within: canvasView.bounds.size)
        let canvasImageFrame = CGRect(origin: .zero, size: canvasImageSizeScaled).settingMidXmidY(self.canvasView.bounds.midXmidY)
        let fx = point.x.interpolate(from: (canvasImageFrame.minX, canvasImageFrame.maxX), to: (CGFloat(0), canvasImageSize.width))
        let fy = point.y.interpolate(from: (canvasImageFrame.minY, canvasImageFrame.maxY), to: (CGFloat(0), canvasImageSize.height))
        let x = Int(floor(fx))
        let y = Int(floor(fy))
        let p = Point(x: x, y: y)
        return p
    }

    public override func didMoveToSuperview() {
        if superview != nil {
            requireSameFrameAsSuperview()
        }
    }
}
