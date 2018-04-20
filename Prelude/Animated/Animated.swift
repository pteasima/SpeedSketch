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
//    // TODO: Capturing the view surely creates a leak, we should have a weak wrapper that remembers the hashValue even after the view deallocates
//    fileprivate var animatedStorage: DictWrapper<UIView, [Any]> {
//        return objc_getAssociatedObject(self, &storageKey) as? DictWrapper<UIView, [Any]> ?? {
//            let newStorage = DictWrapper<UIView, [Any]>()
//            objc_setAssociatedObject(self, &storageKey, newStorage, .OBJC_ASSOCIATION_RETAIN)
//            return newStorage
//            }()
//    }
}
extension UIView: AnimatedProvider { }

private class DictWrapper<K: Hashable,V> {
    var dict: [K: V] = [:]
}

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
}
