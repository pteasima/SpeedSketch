//
//  Lens+KeyPathExtensions.swift
//  SpeedSketch
//
//  Created by Petr Šíma on 19/04/2018.
//  Copyright © 2018 UIKit. All rights reserved.
//

import Foundation

func .~<Root, Value>(keyPath: WritableKeyPath<Root,Value>, value: Value) -> (Root) -> (Root) {
    return set(keyPath)(value)
}

