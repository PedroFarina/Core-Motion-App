//
//  MotionHandler.swift
//  Motion App
//
//  Created by Pedro Giuliano Farina on 17/06/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import CoreMotion

public class MotionManager{
    private let motion:CMMotionManager
    
    private var timer:Timer?{
        didSet{
            if let timer = timer{
                RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
            }
        }
    }
    
    public var motionDelegate:MotionHandler?
    {
        didSet{
            if motionDelegate == nil{
                motion.stopDeviceMotionUpdates()
                timer?.invalidate()
            }
            else{
                motion.showsDeviceMovementDisplay = true
                motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
                TimeInterval = 1/60
            }
        }
    }
    
    public var TimeInterval:TimeInterval{
        get{
            return motion.deviceMotionUpdateInterval
        }
        set{
            motion.deviceMotionUpdateInterval = newValue
            
            timer?.invalidate()
            timer = Timer(fire: Date(), interval: newValue, repeats: true, block: { (timer) in
                if let data:CMDeviceMotion = self.motion.deviceMotion{
                    let relativeAttitude:CMAttitude = data.attitude
                    if let ref = self.refferenceAttitude{
                        relativeAttitude.multiply(byInverseOf: ref)
                    }
                    self.motionDelegate?.update(attitude: relativeAttitude, gravity: data.gravity)
                }
            })
            
        }
    }
    
    public var refferenceAttitude:CMAttitude?
    
    private init(){
        motion = CMMotionManager()
    }
    
    class func shared() -> MotionManager{
        return sharedMotionManager
    }
    
    private static var sharedMotionManager : MotionManager = {
        let MM = MotionManager()
        
        if MM.motion.isDeviceMotionAvailable{
            MM.motion.showsDeviceMovementDisplay = true
            MM.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            MM.TimeInterval = 1/60
        }
        
        return MM
    }()
}
