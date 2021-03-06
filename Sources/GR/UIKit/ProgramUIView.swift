//
//  ProgramUIView.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import UIKit
import Interpolate

public class ProgramUIView: UIKitView {
    weak var program: Program? {
        didSet {
            syncToProgram()
        }
    }
    private var canvasView: CanvasUIView! {
        didSet {
            syncToProgram()
        }
    }

    override public func setup() {
        super.setup()
        addCanvasView()
    }

    private func syncToProgram() {
        guard let program = program else { return }
        program.onScreenChanged = { [unowned self] screenSpec in
            self.canvasView?.screenSpec = screenSpec
        }
        canvasView?.screenSpec = program.screenSpec
    }

    func addCanvasView() {
        canvasView = CanvasUIView(frame: bounds)
        addSubview(canvasView)
        canvasView.requireSameFrameAsSuperview()

        canvasView.touchBegan = { [unowned self] point in
            let p = canvasPointForCanvasViewPoint(point)
            program?.eventSource.send(.touchBegan(p))
        }

        canvasView.touchMoved = { [unowned self] point in
            let p = canvasPointForCanvasViewPoint(point)
            program?.eventSource.send(.touchMoved(p))
        }

        canvasView.touchEnded = { [unowned self] point in
            let p = canvasPointForCanvasViewPoint(point)
            program?.eventSource.send(.touchEnded(p))
        }

        canvasView.touchCancelled = { [unowned self] point in
            let p = canvasPointForCanvasViewPoint(point)
            program?.eventSource.send(.touchCancelled(p))
        }

        #if os(tvOS)
        canvasView.swiped = { direction in
            self.programRunner.swiped(in: direction)
        }
        canvasView.directionButtonPressed = { direction in
            self.programRunner.directionButtonPressed(in: direction)
        }
        canvasView.directionButtonReleased = { direction in
            self.programRunner.directionButtonReleased(in: direction)
        }
        #endif
    }

    public func flush() {
        guard let program = program else { return }
        for (view, canvas) in zip(canvasView.layerViews, program.layers) {
            view.image = canvas.image
        }
    }

    func canvasPointForCanvasViewPoint(_ point: CGPoint) -> Point {
        guard let program = program else { return .zero }
        
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
