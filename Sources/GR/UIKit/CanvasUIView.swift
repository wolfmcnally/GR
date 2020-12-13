//
//  CanvasUIView.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import UIKit

#if os(tvOS)
import GameController
#endif

public typealias CGPointBlock = (CGPoint) -> Void
public typealias DirectionBlock = (Direction) -> Void

class CanvasUIView : UIKitView {
    var touchBegan: CGPointBlock?
    var touchMoved: CGPointBlock?
    var touchEnded: CGPointBlock?
    var touchCancelled: CGPointBlock?

    #if os(tvOS)
    var gestureActions: TVControllerActions!
    var gameController: GCController!
    var gameControllerConnectionAction: NotificationAction!
    var swiped: DirectionBlock?
    var directionButtonPressed: DirectionBlock?
    var directionButtonReleased: DirectionBlock?
    var lastControllerState: ControllerState?
    #endif

    var layerViews = [CanvasLayerUIView]()
    var screenSpec: ScreenSpec! {
        didSet {
            syncToScreen()
        }
    }

    override func setup() {
        super.setup()

        #if os(tvOS)
        gestureActions = TVControllerActions(view: self)
        gestureActions.onSwipeUp = { [unowned self] _ in
            self.swiped?(.up)
        }
        gestureActions.onSwipeLeft = { [unowned self] _ in
            self.swiped?(.left)
        }
        gestureActions.onSwipeDown = { [unowned self] _ in
            self.swiped?(.down)
        }
        gestureActions.onSwipeRight = { [unowned self] _ in
            self.swiped?(.right)
        }

//        print("controllers: \(GCController.controllers())")
        gameControllerConnectionAction = NotificationAction(name: .GCControllerDidConnect, object: nil) { [unowned self] notification in
            print("connected")
            self.gameController = notification.object as! GCController
            let gamepad = self.gameController.microGamepad!
            gamepad.valueChangedHandler = { (gamepad, element) in
                let state = ControllerState(gamepad: gamepad)
                if let lastState = self.lastControllerState {
                    if state.up.isPressed != lastState.up.isPressed {
                        if state.up.isPressed {
                            self.directionButtonPressed?(.up)
                        } else {
                            self.directionButtonReleased?(.up)
                        }
                    }
                    if state.left.isPressed != lastState.left.isPressed {
                        if state.left.isPressed {
                            self.directionButtonPressed?(.left)
                        } else {
                            self.directionButtonReleased?(.left)
                        }
                    }
                    if state.down.isPressed != lastState.down.isPressed {
                        if state.down.isPressed {
                            self.directionButtonPressed?(.down)
                        } else {
                            self.directionButtonReleased?(.down)
                        }
                    }
                    if state.right.isPressed != lastState.right.isPressed {
                        if state.right.isPressed {
                            self.directionButtonPressed?(.right)
                        } else {
                            self.directionButtonReleased?(.right)
                        }
                    }
                }
                self.lastControllerState = state
            }
        }
        #endif
    }

    private func syncToScreen() {
        removeAllSubviews()
        layerViews.removeAll()
        screenSpec.layerSpecs.forEach { spec in
            let view = CanvasLayerUIView()
            addSubview(view)

            view.requireCenteredInSuperview();
            view.preferSameSizeAsSuperview();
            view.requireNoLargerThanSuperview();
            view.requireAspect(screenSpec.canvasSize.aspect);

            layerViews.append(view)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let loc = touch.location(in: self)
        touchBegan?(loc)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let loc = touch.location(in: self)
        touchMoved?(loc)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let loc = touch.location(in: self)
        touchEnded?(loc)
    }

    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        let touch = touches!.first!
        let loc = touch.location(in: self)
        touchCancelled?(loc)
    }
}
