//
//  MotionHandler.swift
//  Motion App
//
//  Created by Pedro Giuliano Farina on 17/06/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import CoreMotion

public protocol MotionHandler{
    func update(attitude:CMAttitude, gravity:CMAcceleration)
}
