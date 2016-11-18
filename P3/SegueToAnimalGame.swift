//
//  SegueToAnimalGame.swift
//  P3
//
//  Created by Mitchell Borman on 11/14/16.
//  Copyright © 2016 Tony Branson. All rights reserved.
//

import UIKit
import SpriteKit

class SegueToAnimalGame: UIStoryboardSegue {
    
    override func perform() {
        
        // Assign the source and destination views to local variables.
        let firstVCView = self.source.view as UIView!
        let secondVCView = self.destination.view as UIView!
        
        // Get the screen width and height.
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Specify the initial position of the destination view.
        secondVCView?.frame = CGRect(x: 0.0, y: screenHeight, width: screenWidth, height: screenHeight)
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVCView!, aboveSubview: firstVCView!)
        
        // Animate the transition.
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            firstVCView?.frame = (firstVCView?.frame)!.offsetBy(dx: 0.0, dy: -screenHeight)
            secondVCView?.frame = (secondVCView?.frame)!.offsetBy(dx: 0.0, dy: -screenHeight)
            
        }) { (Finished) -> Void in
            self.source.present(self.destination as UIViewController, animated: false, completion: nil)
        }
        
        /*let source = self.source
        let destination = self.destination
        
        source.view.addSubview(destination.view)
        
        destination.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: { () -> Void in
            
        destination.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }) { (Finished) -> Void in
            
            /*
            let time = DispatchTime.now(DispatchTime.now(), Int64(0.001 * Double(NSEC_PER_SEC)))
            
            dispatch_after(time, dispatch_get_main_queue()) {
                
                sourceVC.presentViewController(destinationVC, animated: false, completion: nil)
                
            }
            */
            //destination.view.removeFromSuperview()
            //source.present(destination, animated: false, completion: nil)
        }*/
        
    }
    
}
