//
//  LayoutAnimator.swift
//  SpeedSketch
//
//  Created by Petr Šíma on 21/04/2018.
//  Copyright © 2018 UIKit. All rights reserved.
//

import UIKit


private var storageKey = 0

class LayoutAnimator: UIViewPropertyAnimator {
    weak var view: UIView?
}

extension LayoutProvider where Self: UIView{
    var layoutAnimator: LayoutAnimator {
        return objc_getAssociatedObject(self, &storageKey) as? LayoutAnimator ?? {
            let newStorage = LayoutAnimator(duration: 15.0, dampingRatio: 0.8) { }
            newStorage.view = self
            objc_setAssociatedObject(self, &storageKey, newStorage, .OBJC_ASSOCIATION_RETAIN)
            return newStorage
            }()
    }
}

