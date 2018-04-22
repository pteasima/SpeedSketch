//
//  Subview.swift
//  SpeedSketch
//
//  Created by Petr Šíma on 21/04/2018.
//  Copyright © 2018 UIKit. All rights reserved.
//

import UIKit

extension UIView {
    static func added<V: UIView>(into superview: UIView) -> (V) -> V {
        return { view in
            superview.addSubview(view)
            return view
        }
    }
}
