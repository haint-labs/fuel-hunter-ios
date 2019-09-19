//
//  FuelListToMapViewPushTransitionAnimator.swift
//  fuelhunter
//
//  Created by Guntis on 26/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol FuelListToMapViewPushTransitionAnimatorHelperProtocol: class {
	// Use this to animate necessary stuff. Return completionHandler when done.
	func reveal(withDuration duration: TimeInterval, completionHandler: @escaping ((CustomNavigationTransitionResult<Bool>) -> Void))
}

class FuelListToMapViewPushTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	
	 weak var context: UIViewControllerContextTransitioning?
	
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    	context = transitionContext

    	guard let fromView = transitionContext.view(forKey: .from),
			  let toView = transitionContext.view(forKey: .to),
        	  let toViewController = transitionContext.viewController(forKey: .to) as? FuelListToMapViewPushTransitionAnimatorHelperProtocol  else { return }
 
		// Get the duration, that was declared in transitionDuration()
 		let duration = transitionDuration(using: transitionContext)

        let container = transitionContext.containerView
		container.addSubview(toView)
		toView.alpha = 1
		fromView.alpha = 1

		// This is just a tiny extra animation, to hide view that will appear - to hide faster.
		UIView.animate(withDuration: duration/2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2,
			options: [.curveEaseInOut], animations: {
			fromView.alpha = 0
		})

		toViewController.reveal(withDuration: duration) { status in
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		}
    }
}
