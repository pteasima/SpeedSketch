//
//  UIViewPropertyAnimator+Progress.swift
//  SpeedSketch
//
//  Created by Petr Šíma on 22/04/2018.
//  Copyright © 2018 UIKit. All rights reserved.
//

import UIKit

extension UIViewPropertyAnimator {
    var progress: Double {
        get { return 0 }
        set { continueAnimation(withTimingParameters: nil, durationFactor: CGFloat(newValue))
            pauseAnimation()
        }
    }
}
