import Foundation
import UIKit
import ObjectiveC

protocol BindingsProvider: class { }

private var storageKey = 0
extension BindingsProvider {
    var bindings: Bindings<Self> {
        get { return Bindings(self) }
        set { /*needed to enable writing to the keyPath, do nothing here*/ }
    }
    //we store the AnyI just for shits. We could probably get away with not storing it and returning empty from the subscript getter to make the compiler happy. Maybe it will be usefull in debugging and testing?
    fileprivate var bindingsStorage: DictWrapper<AnyKeyPath, (Disposable, AnyI)> {
        return objc_getAssociatedObject(self, &storageKey) as? DictWrapper<AnyKeyPath, (Disposable, AnyI)> ?? {
            let newStorage = DictWrapper<AnyKeyPath, (Disposable, AnyI)>()
            objc_setAssociatedObject(self, &storageKey, newStorage, .OBJC_ASSOCIATION_RETAIN)
            return newStorage
        }()
    }
}
extension NSObject: BindingsProvider { }

struct Bindings<Base: BindingsProvider> {
    private let base: Base
    init(_ base: Base) {
        self.base = base
    }

    subscript<Value>(_ keyPath: ReferenceWritableKeyPath<Base,Value>) -> I<Value>? {
        get {
            return base.bindingsStorage.dict[keyPath].map { $0.1 as! I<Value> }
        }
        set {
            let d = newValue?.observe { [weak base] in
                base?[keyPath: keyPath] = $0
            }
            base.bindingsStorage.dict[keyPath] = d.flatMap { d in newValue.map { (d,$0 as AnyI) }}
        }
    }
}
