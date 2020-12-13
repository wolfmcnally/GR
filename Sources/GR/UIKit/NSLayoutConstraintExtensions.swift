//
//  NSLayoutConstraintExtensions.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import UIKit

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
