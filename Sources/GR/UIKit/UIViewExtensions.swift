//
//  UIViewExtensions.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import UIKit

extension UIView {
    func makeTransparent() {
        isOpaque = false
        backgroundColor = .clear
    }

    func __setup() {
        translatesAutoresizingMaskIntoConstraints = false
        makeTransparent()
    }
}

extension UIView {
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}

extension UIView {
    func requireCenteredInSuperview() {
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview!.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview!.centerYAnchor)
        ])
    }

    func preferSameSizeAsSuperview() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: superview!.widthAnchor).withPriority(.defaultLow),
            heightAnchor.constraint(equalTo: superview!.heightAnchor).withPriority(.defaultLow),
        ])
    }

    func requireSameSizeAsSuperview() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: superview!.widthAnchor),
            heightAnchor.constraint(equalTo: superview!.heightAnchor)
        ])
    }

    func requireNoLargerThanSuperview() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(lessThanOrEqualTo: superview!.widthAnchor, multiplier: 1),
            heightAnchor.constraint(lessThanOrEqualTo: superview!.heightAnchor, multiplier: 1),
        ])
    }

    func requireAspect(_ aspect: Double) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: heightAnchor, multiplier: CGFloat(aspect))
        ])
    }

    func requireSameFrameAsSuperview() {
        requireCenteredInSuperview()
        requireSameSizeAsSuperview()
    }
}
