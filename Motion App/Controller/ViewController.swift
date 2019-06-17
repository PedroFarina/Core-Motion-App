//
//  ViewController.swift
//  Motion App
//
//  Created by Pedro Giuliano Farina on 17/06/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, UICollisionBehaviorDelegate, MotionHandler {
    @IBOutlet var warMike: UIImageView!
    @IBOutlet var Collidables: [UIView]!
    @IBOutlet var lblEnd: UILabel!
    @IBOutlet var lblHorario: UILabel!
    
    var animator:UIDynamicAnimator!
    var collision:UICollisionBehavior!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: self.view)
        collision = UICollisionBehavior(items: Collidables)
        collision.translatesReferenceBoundsIntoBoundary = true
        
        
        collision.collisionDelegate = self
        animator.addBehavior(collision)
        
        let df:DateFormatter = DateFormatter()
        df.dateFormat = "HH:mm"
        lblHorario.text = df.string(from: Date())
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MotionManager.shared().motionDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        MotionManager.shared().motionDelegate = self
    }

    
    func update(attitude: CMAttitude, gravity: CMAcceleration) {
        let aX = CGFloat(attitude.pitch * 0.15)
        let aY = CGFloat(attitude.roll * 0.15)
        
        let push = UIPushBehavior(items: [warMike], mode: .instantaneous)
        push.pushDirection = CGVector(dx: aY, dy: aX)
        animator.addBehavior(push)
        
        //warMike.transform = CGAffineTransform(rotationAngle: CGFloat(atan2(gravity.x, gravity.y) - .pi))
    }
    
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        let colliderItem:UIView = item1 as! UIView
        let collidedItem:UIView = item2 as! UIView
        
        if colliderItem == warMike && collidedItem.tag != 666{
            
            collidedItem.tag = 666
            
            UIView.animate(withDuration: 2, animations: {
                collidedItem.backgroundColor = .red
            }) { (completion) in
                behavior.removeItem(item2)
                collidedItem.removeFromSuperview()
                if behavior.items.count == 1{
                    self.lblEnd.isHidden = false
                }
            }
            
            
        }
    }
}
