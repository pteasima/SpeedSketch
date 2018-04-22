import Foundation
import UIKit
import ObjectiveC

protocol AnimatedProvider: class { }

private var storageKey = 0
extension AnimatedProvider where Self: UIView {
    var animated: Animated<Self> {
        get { return Animated(self) }
        set {  }
    }
}
extension UIView: AnimatedProvider { }

struct Animated<Base: UIView> {
    private var base: Base
    init(_ base: Base) {
        self.base = base
    }

    subscript<Value>(_ params: (ReferenceWritableKeyPath<Base, Value>, in: UIView)) -> Value {
        get {
            return base[keyPath: params.0]
        }
        set {
            let base = self.base
            UIView.animate(withDuration: 1) {
                base[keyPath: params.0] = newValue
                params.in.layoutIfNeeded()
            }
        }
    }

    subscript<Value>(_ params: (ReferenceWritableKeyPath<Base, Value>, by: LayoutAnimator)) -> Value {
        get {
            return base[keyPath: params.0]
        }
        set {
            params.by.addAnimations { [weak base = self.base, weak view = params.by.view] in
                base?[keyPath: params.0] = newValue
                view?.layoutIfNeeded()
            }
        }
    }
}
