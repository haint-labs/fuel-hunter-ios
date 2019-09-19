//
//  FuelListToMapViewPopTransitionAnimator.swift
//  fuelhunter
//
//  Created by Guntis on 26/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol FuelListToMapViewPopTransitionAnimatorHelperProtocol: class {
	// Use this to animate necessary stuff. Return completionHandler when done.
	func hide(withDuration duration: TimeInterval, completionHandler: @escaping ((CustomNavigationTransitionResult<Bool>) -> Void))

	// Used when user manually swipes back, but cancels it.
	func reset()
}

protocol FuelListToMapViewPopTransitionAnimatorFinaliseHelperProtocol: class {
	// Called on toViewController - to finalise any tasks (like, unhide item)
	func customTransitionWasFinished()
}

class FuelListToMapViewPopTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	
	weak var context: UIViewControllerContextTransitioning?
	weak var fromViewController: FuelListToMapViewPopTransitionAnimatorHelperProtocol?
	
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
	
	func animationEnded(_ transitionCompleted: Bool) {
		if !transitionCompleted {
			self.fromViewController?.reset()
		}
	}
	
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    	context = transitionContext

    	guard let fromView = transitionContext.view(forKey: .from),
			  let toView = transitionContext.view(forKey: .to),
			  let toViewController = transitionContext.viewController(forKey: .to) as? FuelListToMapViewPopTransitionAnimatorFinaliseHelperProtocol,
			  let fromViewController = transitionContext.viewController(forKey: .from) as? FuelListToMapViewPopTransitionAnimatorHelperProtocol else { return }


        self.fromViewController = fromViewController

        let duration = transitionDuration(using: transitionContext)

        let container = transitionContext.containerView
        container.insertSubview(toView, belowSubview: fromView)
        toView.alpha = 0

        // This is just a tiny extra animation, to un-hide view that will appear - to appear faster.
		UIView.animate(withDuration: duration/2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2,
			options: [.curveEaseInOut], animations: {
			toView.alpha = 1
		})

		fromViewController.hide(withDuration: duration) { status in
			if !transitionContext.transitionWasCancelled {
				toViewController.customTransitionWasFinished()
				container.addSubview(toView)
			}
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		}
    }
}
