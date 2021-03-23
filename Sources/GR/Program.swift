//
//  Program.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import Foundation
import Combine
import GameController

open class Program {
    open class var title: String { String(describing: Self.self) }
    open class var subtitle: String? { nil }
    open class var author: String? { nil }
    open class var version: String? { nil }
    
    private var _canvasSize = Size(width: 40, height: 40)
    private var _framesPerSecond: Float = 0.0
    private var needsDisplay: Bool = true
    public var didDisplay: (() -> Void)?
    public private(set) var frameNumber = 0
    public var onScreenChanged: ((ScreenSpec) -> Void)?
    public var eventSource = PassthroughSubject<Event, Never>()
    private var ops = Set<AnyCancellable>()

    public var screenSpec = ScreenSpec(mainLayer: 1, layerSpecs: [
        LayerSpec(clearColor: .black),
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

    public var canvasSize: IntSize {
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
            displayLink = DisplayLink(preferredFramesPerSecond: framesPerSecond) { [weak self] _ in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    defer { self.displayLinkFrameCounter += 1 }
                    guard self.displayLinkFrameCounter > 1 else { return }
                    self._update()
                    self.displayIfNeeded()
                }
            }
        }
    }

    private lazy var tapMovePublisher: AnyPublisher<Event, Never> = {
        eventSource.map { [unowned self] event -> Event? in
            switch event {
            case .touchBegan(let point):
                let direction: Direction
                
                let nx = Double(point.x) / Double(self.canvasSize.width)
                let ny = Double(point.y) / Double(self.canvasSize.height)
                if nx >= ny {
                    direction = nx >= (1 - ny) ? .right : .up
                } else {
                    direction = nx >= (1 - ny) ? .down : .left
                }
                
                self.startRepeatingMove(direction: direction)

                return .move(direction)
            case .touchEnded:
                self.endRepeatingMove()
                return nil
            default:
                return nil
            }
        }
        .compactMap { $0 }
        .eraseToAnyPublisher()
    }()
    
    private var moveTimerCancellable: AnyCancellable?

    public var moveRepeatInitialInterval: TimeInterval = 0.3
    public var moveRepeatContinuedInterval: TimeInterval = 0.1
    
    private func startRepeatingMove(direction: Direction) {
        self.moveTimerCancellable =
            Timer.TimerPublisher(interval: moveRepeatInitialInterval, runLoop: .main, mode: .default)
            .autoconnect()
            .sink { [unowned self] _ in
                self.eventSource.send(.move(direction))
                self.moveTimerCancellable = Timer.TimerPublisher(interval: moveRepeatContinuedInterval, runLoop: .main, mode: .default)
                    .autoconnect()
                    .sink { [unowned self] _ in
                        self.eventSource.send(.move(direction))
                    }
            }
    }
    
    private func endRepeatingMove() {
        self.moveTimerCancellable = nil
    }
    
    private lazy var keyMovePublisher: AnyPublisher<Event, Never> = {
        eventSource.map { [weak self] event -> Event? in
            guard let self = self else { return nil }
            switch event {
            case .keyPressed(let key):
                let direction: Direction?
                switch key {
                case "UpArrow":
                    direction = .up
                case "DownArrow":
                    direction = .down
                case "LeftArrow":
                    direction = .left
                case "RightArrow":
                    direction = .right
                default:
                    direction = nil
                }
                if let direction = direction {
                    self.startRepeatingMove(direction: direction)
                    return .move(direction)
                } else {
                    return nil
                }
            case .keyReleased:
                self.endRepeatingMove()
                return nil
            default:
                return nil
            }
        }
        .compactMap { $0 }
        .eraseToAnyPublisher()
    }()
    
    private func setupEvents() {
        eventSource
            .merge(with: tapMovePublisher, keyMovePublisher)
            .sink { [weak self] event in
                guard let self = self else { return }
                //print(event)
                self.onEvent(event: event)
            }
        .store(in: &ops)
    }

    public required init() {
        print("\(type(of: self)) init")

        attachKeyboard()
        setupEvents()
        resetScreen()
    }
    
    deinit {
        print("\(self) deinit")
        
        detachKeyboard()
    }

    private static var keyboard: GCKeyboardInput?

    private func attachKeyboard() {
        precondition(Self.keyboard == nil, "Keyboard could not be attached. Did a previously run Program fail to deinit due to a retain cycle?")
        
        guard let keyboard = GCKeyboard.coalesced?.keyboardInput else { return }
        keyboard.keyChangedHandler = { [weak self] _, key, _, _ in
            guard let self = self else { return }
            guard let name = key.aliases.first else { return }
            if key.isPressed {
                self.eventSource.send(.keyPressed(name))
            } else {
                self.eventSource.send(.keyReleased(name))
            }
        }
        Self.keyboard = keyboard
    }
    
    private func detachKeyboard() {
        guard let keyboard = Self.keyboard else { return }
        keyboard.keyChangedHandler = nil
        Self.keyboard = nil
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
    open func onEvent(event: Event) { }
    
    open func restart() {
        frameNumber = 0
        setup()
        update()
        display()
    }
}
