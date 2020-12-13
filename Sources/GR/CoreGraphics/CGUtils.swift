//
//  CGUtils.swift
//  GR
//
//  Created by Wolf McNally on 11/14/20.
//

import CoreGraphics

struct CGUtils {
    static var sharedColorSpaceRGB = CGColorSpaceCreateDeviceRGB()
    static var sharedColorSpaceGray = CGColorSpaceCreateDeviceGray()
    static var sharedWhiteColor = CGColor(colorSpace: sharedColorSpaceGray, components: [CGFloat(1.0), CGFloat(1.0)])
    static var sharedBlackColor = CGColor(colorSpace: sharedColorSpaceGray, components: [CGFloat(0.0), CGFloat(1.0)])
    static var sharedClearColor = CGColor(colorSpace: sharedColorSpaceGray, components: [CGFloat(0.0), CGFloat(0.0)])
}
