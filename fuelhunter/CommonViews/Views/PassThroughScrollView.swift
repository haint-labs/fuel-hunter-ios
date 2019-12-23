//
//  PassThroughScrollView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class PassThroughScrollView: UIScrollView {

	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		return subviews.contains(where: {
			!$0.isHidden
			&& $0.isUserInteractionEnabled
			&& $0.point(inside: self.convert(point, to: $0), with: event)
		})
	}
}
