//
//  ControllerUtils.swift
//  
//
//  Created by Wolf McNally on 2/5/21.
//

import GameController

func print(level: Int, _ items: Any..., separator: String = " ", terminator: String = "\n") {
    Swift.print( String(repeating: "\t", count: level) + items.map({String(describing: $0)}).joined(separator: separator), terminator: terminator)
}

func setupControllers()
{
//    printControllerDescriptions()
    if let controller = GCController.controllers().first {
        guard let gamepad = controller.microGamepad else { return }
        gamepad.valueChangedHandler = { gamepad, element in
            print("gamepad: \(gamepad), element: \(element)")
        }
    }
    
    if let keyboardInput = GCKeyboard.coalesced?.keyboardInput {
        keyboardInput.keyChangedHandler = { keyboard, key, keyCode, pressed in
            print("key: \(key), keyCode: \(keyCode), pressed: \(pressed)")
        }
    }
}

func printControllerDescriptions() {
    let controllers = GCController.controllers()
    if let keyboard = GCKeyboard.coalesced {
        print("Keyboard: \(keyboard.description)")
        keyboard.physicalInputProfile.printDescription(1)
    }
    if let mouse = GCMouse.current {
        print("Mouse: \(mouse.description)")
    }
    print("Connected controllers: \(controllers.count)")
    for (index, controller) in controllers.enumerated() {
        print("Controller \(index)")
        controller.printDescription(1)
    }
}

extension GCDevice {
    var detailedDescription: String {
        var comps: [String] = []
        
        comps.append("category: \(productCategory)")
        
        if let vendorName = vendorName {
            comps.append("vendorName: \(vendorName)")
        }
        
        return comps.joined(separator: ", ")
    }
}

extension GCController {
    func printDescription(_ level: Int) {
        print(level: level, detailedDescription)

        if let extendedGamepad = extendedGamepad {
            print(level: level, "extended gamepad:")
            extendedGamepad.printDescription(level + 1)
        }
        if let microGamepad = microGamepad {
            print(level: level, "micro gamepad:")
            microGamepad.printDescription(level + 1)
        }
        if let motion = motion {
            print(level: level, "motion:")
            motion.printDescription(level + 1)
        }
    }
}

extension GCPhysicalInputProfile {
    func printDescription(_ level: Int) {
        if !axes.isEmpty {
            print(level: level, "axes")
            for axis in axes.sorted(by: { $0.key < $1.key } ) {
                print(level: level + 1, "\(axis.key) \(axis.value.detailedDescription)")
            }
        }
        
        if !buttons.isEmpty {
            print(level: level, "buttons")
            for button in buttons.sorted(by: { $0.key < $1.key } ) {
                print(level: level + 1, "\(button.key) \(button.value.detailedDescription)")
            }
        }
        
        if !dpads.isEmpty {
            print(level: level, "dpads")
            for dpad in dpads.sorted(by: { $0.key < $1.key } ) {
                print(level: level + 1, "\(dpad.key) \(dpad.value.detailedDescription)")
            }
        }
    }
}

extension GCMotion {
    func printDescription(_ level: Int) {
        print(level: level, description)
    }
}

extension GCControllerElement {
    var detailedDescription: String {
        var comps: [String] = []
        
        if !isAnalog {
            comps.append("isAnalog: \(isAnalog)")
        }
        
        if let sfSymbolsName = sfSymbolsName {
            comps.append("sfSymbolsName: \(sfSymbolsName)")
        }
        
        if isBoundToSystemGesture {
            comps.append("isBoundToSystemGesture: \(isBoundToSystemGesture)")
        }

        if comps.isEmpty {
            return ""
        } else {
            return "[" + comps.joined(separator: ", ") + "]"
        }
    }
}
