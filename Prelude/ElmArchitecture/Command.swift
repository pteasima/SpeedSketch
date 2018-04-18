import UIKit

public protocol Command: Monoid {
    associatedtype Action
}

public struct Run<Action>: Command {
    public static var empty: Run<Action> { return Run { _ in }}

    public static func <> (lhs: Run<Action>, rhs: Run<Action>) -> Run<Action> {
        return Run { callback in
            lhs.run(callback)
            rhs.run(callback)
        }
    }

    public let run: (_ callback: @escaping (Action) -> ()) -> ()
    public init(run: @escaping (@escaping (Action) -> ()) -> ()) {
        self.run = run
    }
}

public struct MapCommand<A, C> where C: Command {
    public typealias B = C.Action
    public let map: (_ transform: @escaping (A) -> B) -> C
}
extension MapCommand: Command {
    public typealias Action = A

    public static var empty: MapCommand<A, C> {
        return MapCommand { _ in .empty }
    }

    public static func <> (lhs: MapCommand<A, C>, rhs: MapCommand<A, C>) -> MapCommand<A, C> {
        return MapCommand { transform in
            lhs.map(transform) <> rhs.map(transform)
        }
    }
}
//this is needed to constrain against the generic params of MapCommand
public protocol MapCommandProtocol {
    associatedtype A
    associatedtype C: Command
    typealias B = C.Action

    var map: (@escaping (A) -> B) -> C { get }
}
extension MapCommand: MapCommandProtocol { }

public protocol PrintCommand: Command {
    static func print(_ text: String) -> Self
}
extension Run: PrintCommand {
    public static func print(_ text: String) -> Run {
        return Run { _ in Swift.print(text) }
    }
}
extension MapCommand: PrintCommand where C: PrintCommand {
    public static func print(_ text: String) -> MapCommand {
        return MapCommand { _ in C.print(text) }
    }
}

public protocol ViewCommand: Command {
    static func modal(text: String, cancel: @escaping () -> Action) -> Self
}
extension Run: ViewCommand {
    public static func modal(text: String, cancel: @escaping () -> Action) -> Run<Action> {
        return Run { callback in
            let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
                callback(cancel())
            }
            alert.addAction(cancelAction)
//            (PlaygroundPage.current.liveView as? UIViewController)?.present(alert, animated: true, completion: nil)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }

    }
}
extension MapCommand: ViewCommand where C: ViewCommand {
    public static func modal(text: String, cancel: @escaping () -> Action) -> MapCommand {
        return MapCommand { transform in
            C.modal(text: text, cancel : { transform(cancel()) })
        }
    }
}
