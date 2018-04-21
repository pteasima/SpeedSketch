protocol WritableKeyPathEraser {}

extension WritableKeyPathEraser {
    var any: KeyPathCast<Self> {
        get { return KeyPathCast(self) }
        set { self = newValue.base }
    }
}

struct KeyPathCast<Base> {
    var base: Base
    init(_ base: Base) {
        self.base = base
    }

    subscript<Value>(_ keyPath: WritableKeyPath<Base, Value>) -> Any {
        get { return base[keyPath: keyPath] }
        set {
            guard let newValue = newValue as? Value else { return }
            base[keyPath: keyPath] = newValue
        }
    }
}

//struct A { //works for classes too
//    var foo: String
//}
//extension A: WritableKeyPathEraser { }
//
//let a = A(foo: "hello") //goodbye
//    |> \.any[\.foo] .~ ("goodbye" as Any)
//
//





