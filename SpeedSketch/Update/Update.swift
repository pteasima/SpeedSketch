//
//  Update.swift
//  SpeedSketch
//
//  Created by Petr Šíma on 18/04/2018.
//  Copyright © 2018 UIKit. All rights reserved.
//

import Foundation

enum Action {
    case selectDebug
    case selectCalligraphy
    case selectInk
}

func update<C: Command & PrintCommand>(state: inout State, action: Action) -> C {

    func setStroke(_ option: StrokeDisplayOption) -> C {
        state.strokeDisplayOption = option
        return C.print(option)
//        return .empty
    }

    switch action {
    case .selectDebug:
        return setStroke(.debug)
    case .selectCalligraphy:
        return setStroke(.calligraphy)
    case .selectInk:
        return setStroke(.ink)
    }
}

