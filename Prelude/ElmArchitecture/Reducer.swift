public typealias Reduce<S, C: Command> = (inout S, C.Action) -> C

public struct Reducer<S,C: Command> {
    public typealias A = C.Action
    public let reduce: Reduce<S,C>

    public init(reduce: @escaping Reduce<S,C>) {
        self.reduce = reduce
    }
}

extension Reducer: Monoid {
    public static var empty: Reducer<S, C> {
        return Reducer { (_,_) in .empty }
    }

    public static func <> (lhs: Reducer<S, C>, rhs: Reducer<S, C>) -> Reducer<S, C> {
        return Reducer { state, action in
            return lhs.reduce(&state, action) <> rhs.reduce(&state, action)
        }
    }
}

public extension Reducer {
    public func lift<T>(state: WritableKeyPath<T, S>) -> Reducer<T, C> {
        return Reducer<T, C> { stateT, action in
            return self.reduce(&stateT[keyPath: state], action)
        }
    }
}

//public extension Reducer where C: MapCommandProtocol, C.A == Reducer.A {
//    public func lift(action: APrism<C.B, A>) -> Reducer<S, C.C> {
//        return Reducer<S, C.C> { state, actionB in
//            guard let actionA = action.preview(actionB) else { return .empty }
//            return self.reduce(&state, actionA).map(action.review)
//        }
//    }
//}
