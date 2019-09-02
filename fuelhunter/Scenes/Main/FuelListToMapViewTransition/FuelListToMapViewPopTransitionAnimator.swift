//
//  FuelListToMapViewPopTransitionAnimator.swift
//  fuelhunter
//
//  Created by Guntis on 26/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol FuelListToMapViewPopTransitionAnimatorHelperProtocol {
	func hide()
	func reset()
}

protocol FuelListToMapViewPopTransitionAnimatorFinaliseHelperProtocol {
	func customTransitionWasFinished()
}

final class FuelListToMapViewPopTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	
	weak var context: UIViewControllerContextTransitioning?
	
	weak var fromViewController: UIViewController? 
	
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
	
	func animationEnded(_ transitionCompleted: Bool) {
		if !transitionCompleted {
			(self.fromViewController as? MapViewController)?.reset()
		}
	}
	
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    	context = transitionContext
    
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
		
		guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
		guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }

        self.fromViewController = fromViewController
        (fromViewController as? MapViewController)?.hide()
		
        let duration = transitionDuration(using: transitionContext)

        let container = transitionContext.containerView
        container.insertSubview(toView, belowSubview: fromView)
        
		toView.alpha = 0

        let animations = {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
            	toView.alpha = 1
            }
        }
	
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, 
        	animations: animations, completion: { finished in
			if !transitionContext.transitionWasCancelled {
				(toViewController as? FuelListViewController)?.customTransitionWasFinished()
				container.addSubview(toView)	
			} 
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
