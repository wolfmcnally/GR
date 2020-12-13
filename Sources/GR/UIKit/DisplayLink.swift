//
//  DisplayLink.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import Foundation
import UIKit

class DisplayLink {
    typealias FiredBlock = (DisplayLink) -> Void
    var firstTimestamp: CFTimeInterval!
    var elapsedTime: CFTimeInterval { timestamp - firstTimestamp }

    private var displayLink: CADisplayLink!
    private let onFired: FiredBlock

    init(preferredFramesPerSecond: Int = 30, onFired: @escaping FiredBlock) {
        self.onFired = onFired
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkFired))
        if #available(iOS 10.0, *) {
            displayLink.preferredFramesPerSecond = min(60, preferredFramesPerSecond)
        }
        displayLink.add(to: RunLoop.main, forMode: .default)
    }

    deinit {
        displayLink.invalidate()
    }

    @objc private func displayLinkFired(displayLink: CADisplayLink) {
        if firstTimestamp == nil {
            firstTimestamp = timestamp
        }

        onFired(self)
    }

    func invalidate() { displayLink.invalidate() }

    @inlinable var timestamp: CFTimeInterval { displayLink.timestamp }
    @inlinable var targetTimestamp: CFTimeInterval { displayLink.targetTimestamp }
    @inlinable var duration: CFTimeInterval { displayLink.duration }
    @inlinable var frameRate: CFTimeInterval { 1 / (targetTimestamp - timestamp) }

    var isPaused: Bool {
        get { displayLink.isPaused }
        set { displayLink.isPaused = newValue }
    }

    var preferredFramesPerSecond: Int {
        get { displayLink.preferredFramesPerSecond }
        set { displayLink.preferredFramesPerSecond = newValue }
    }
}
