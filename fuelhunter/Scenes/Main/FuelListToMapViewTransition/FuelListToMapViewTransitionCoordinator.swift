//
//  FuelListToMapViewTransitionCoordinator.swift
//  fuelhunter
//
//  Created by Guntis on 26/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

enum CustomNavigationTransitionResult<Value> {
	case success
	case failure
}

class FuelListToMapViewTransitionCoordinator: NSObject, UINavigationControllerDelegate {
    var interactionController: UIPercentDrivenInteractiveTransition?
	var sideSwipeRecognizerAdded: Bool = false
	weak var navController: UINavigationController?
	
	func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    	if !sideSwipeRecognizerAdded {
    		navController = navigationController
    		self.addSideSwipeRecognizerToNavigationController()
    		sideSwipeRecognizerAdded = true
    	}
    	
        switch operation {
        case .push:
            return FuelListToMapViewPushTransitionAnimator()
        case .pop:
            return FuelListToMapViewPopTransitionAnimator()
        default:
            return nil
        }
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func addSideSwipeRecognizerToNavigationController() {
    	let edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        edgeSwipeGestureRecognizer.edges = .left
        navController!.view.addGestureRecognizer(edgeSwipeGestureRecognizer)
    }
    
    @objc func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
       
		let percent = gestureRecognizer.translation(in: gestureRecognizer.view!).x / gestureRecognizer.view!.bounds.size.width
		
        if gestureRecognizer.state == .began {
            interactionController = UIPercentDrivenInteractiveTransition()
            navController!.popViewController(animated: true)
        } else if gestureRecognizer.state == .changed {
            interactionController?.update(percent)
        } else if gestureRecognizer.state == .ended {
            if percent > 0.5 && gestureRecognizer.state != .cancelled {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
}
