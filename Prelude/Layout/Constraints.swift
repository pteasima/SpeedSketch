//
//  Constraints.swift
//  SpeedSketch
//
//  Created by Petr Šíma on 19/04/2018.
//  Copyright © 2018 UIKit. All rights reserved.
//

import UIKit

public typealias Constraint = (_ first: UIView, _ second: UIView) -> NSLayoutConstraint


public func equal<Anchor, Axis>(_ keyPath: KeyPath<UIView, Anchor>, to: KeyPath<UIView, Anchor>? = nil, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    let to = to ?? keyPath
    return { $0[keyPath: keyPath].constraint(equalTo: $1[keyPath: to], constant: constant) }
}

public func sizeToParent(inset constant: CGFloat = 0) -> [Constraint] {
    return [
            equal(\.leadingAnchor, constant: -constant),
            equal(\.trailingAnchor, constant: constant),
            equal(\.topAnchor, constant: -constant),
            equal(\.bottomAnchor, constant: constant),
    ]
}


public func equal(_ keyPath: KeyPath<UIView, NSLayoutDimension>, to constant: CGFloat) -> Constraint  {
    return { first, _ in
        return first[keyPath: keyPath].constraint(equalToConstant: constant)
    }
}
