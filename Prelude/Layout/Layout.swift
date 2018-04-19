import Foundation
import UIKit
import ObjectiveC

protocol LayoutProvider: class { }

private var storageKey = 0
extension LayoutProvider where Self: UIView {
    var constraintsTo: Layout<Self> {
        get { return Layout(self) }
        set { /*needed to enable writing to the keyPath, do nothing here*/ }
    }
    // TODO: Capturing the view surely creates a leak, we should have a weak wrapper that remembers the hashValue even after the view deallocates
    fileprivate var layoutStorage: DictWrapper<UIView, [(Constraint, NSLayoutConstraint)]> {
        return objc_getAssociatedObject(self, &storageKey) as? DictWrapper<UIView, [(Constraint, NSLayoutConstraint)]> ?? {
            let newStorage = DictWrapper<UIView, [(Constraint, NSLayoutConstraint)]>()
            objc_setAssociatedObject(self, &storageKey, newStorage, .OBJC_ASSOCIATION_RETAIN)
            return newStorage
            }()
    }
}
extension UIView: LayoutProvider { }

private class DictWrapper<K: Hashable,V> {
    var dict: [K: V] = [:]
}

struct Layout<Base: UIView> {
    private let base: Base
    init(_ base: Base) {
        self.base = base
    }

    subscript(_ to: UIView) -> [Constraint]? {
        get {
            return base.layoutStorage.dict[to]?.map { $0.0 }
        }
        set {
            base.translatesAutoresizingMaskIntoConstraints = false
            if let oldConstraints = base.layoutStorage.dict[to]?.map({ $0.1 }) {
                NSLayoutConstraint.deactivate(oldConstraints)
            }
            guard let newValue = newValue else {
                base.layoutStorage.dict.removeValue(forKey: to)
                return
            }
            let newConstraints = newValue.map { $0(base, to) }
            NSLayoutConstraint.activate(newConstraints)
            base.layoutStorage.dict[to] = Array(zip(newValue, newConstraints))
        }
    }
}
