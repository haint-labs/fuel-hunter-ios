//
//  FuelListToMapViewPushTransitionAnimator.swift
//  fuelhunter
//
//  Created by Guntis on 26/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol FuelListToMapViewPushTransitionAnimatorHelperProtocol {
	func reveal()
}

final class FuelListToMapViewPushTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	
	 weak var context: UIViewControllerContextTransitioning?
	
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
	
	func animationEnded(_ transitionCompleted: Bool) {
	}
  
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    	context = transitionContext
    
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
		
		guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
 
		DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
			(toViewController as? MapViewController)?.reveal()
		})
		
		
		let duration = transitionDuration(using: transitionContext)

        let container = transitionContext.containerView
		container.addSubview(toView)
		
		toView.alpha = 1
		fromView.alpha = 1
		
        let animations = {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
            	fromView.alpha = 0
            }
        }
	
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: animations, completion: { finished in
			container.addSubview(toView)
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
