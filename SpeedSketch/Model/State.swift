//
//  State.swift
//  SpeedSketch
//
//  Created by Petr Šíma on 18/04/2018.
//  Copyright © 2018 UIKit. All rights reserved.
//

import Foundation

struct State: Equatable, Codable {
    var strokeDisplayOption: StrokeDisplayOption = .debug
}

enum StrokeDisplayOption: String, Codable {
    case debug
    case calligraphy
    case ink
}
