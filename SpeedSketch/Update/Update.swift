//
//  Update.swift
//  SpeedSketch
//
//  Created by Petr Šíma on 18/04/2018.
//  Copyright © 2018 UIKit. All rights reserved.
//

import Foundation

enum Action {
    case selectStroke(StrokeDisplayOption)
}

func update<C: Command & PrintCommand>(state: inout State, action: Action) -> C {

    switch action {
    case let .selectStroke(option):
        state.strokeDisplayOption = option
        return C.print(option)
    }
}

