//
//  Bindings.swift
//  SpeedSketch
//
//  Created by Petr Šíma on 19/04/2018.
//  Copyright © 2018 UIKit. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

protocol BindingsProvider: class { }

private var storageKey = 0
extension BindingsProvider {
    var bindings: Bindings<Self> {
        return Bindings(self)
    }

    fileprivate var bindingsStorage: DictWrapper<AnyKeyPath, Disposable> {
        return objc_getAssociatedObject(self, &storageKey) as? DictWrapper<AnyKeyPath, Disposable> ?? {
            let newStorage = DictWrapper<AnyKeyPath, Disposable>()
            objc_setAssociatedObject(self, &storageKey, newStorage, .OBJC_ASSOCIATION_RETAIN)
            return newStorage
        }()

    }
}

private class DictWrapper<K: Hashable,V> {
    var dict: [K: V] = [:]
}

struct Bindings<Base: BindingsProvider> {
    private let base: Base
    init(_ base: Base) {
        self.base = base
    }

    subscript<V>(_ keyPath: ReferenceWritableKeyPath<Base,V>) -> Disposable? {
        get { return base.bindingsStorage.dict[keyPath] }
        set { base.bindingsStorage.dict[keyPath] = newValue }
    }
}
