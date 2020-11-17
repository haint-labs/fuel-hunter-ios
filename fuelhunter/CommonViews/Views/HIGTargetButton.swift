//
//  HIGTargetButton.swift
//  fuelhunter
//
//  Created by Guntis on 07/09/2020.
//  Copyright © 2020. All rights reserved.
//

import Foundation
import UIKit

class HIGTargetButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -100, dy: -100).contains(point)//bounds.inset(dx: -10, dy: -10).contains(point)
    }
}
