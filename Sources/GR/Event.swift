//
//  Event.swift
//  
//
//  Created by Wolf McNally on 2/2/21.
//

import Foundation

public enum Event {
    case touchBegan(Point)
    case touchMoved(Point)
    case touchEnded(Point)
    case touchCancelled(Point)
    
    case keyPressed(String)
    case keyReleased(String)

    case move(Direction)
}
