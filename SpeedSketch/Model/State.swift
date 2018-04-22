//
//  State.swift
//  SpeedSketch
//
//  Created by Petr Šíma on 18/04/2018.
//  Copyright © 2018 UIKit. All rights reserved.
//

import Foundation
import UIKit

struct State: Equatable/*, Codable*/ {
    var strokeDisplayOption: StrokeDisplayOption = .debug

    var color: Tuple3<Double,Double,Double> = lift((0.5,0.5,0.5))
    var animationProgress: Float = 0.5
}

enum StrokeDisplayOption: String, Codable {
    case debug
    case calligraphy
    case ink
}
