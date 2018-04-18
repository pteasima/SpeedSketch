//
//  Driver.swift
//  SpeedSketch
//
//  Created by Petr Šíma on 18/04/2018.
//  Copyright © 2018 UIKit. All rights reserved.
//

import Foundation

final class Driver<S: Equatable, A> {
    private let stateInput: Input<S>
    private let reduce: Reduce<S,Run<A>>
    init(state: S, reduce: @escaping Reduce<S,Run<A>>) {
        self.stateInput = Input(state)
        self.reduce = reduce
    }

    var state: I<S> {
        return stateInput.i
    }

    func dispatch(_ action: A) {
        var command: Run<A>!
        stateInput.change {
            command = reduce(&$0, action)
        }
        command.run(dispatch)
    }
}
