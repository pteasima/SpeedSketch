import Closures
#if os(iOS)
  import UIKit
  import UIKit.UIGestureRecognizerSubclass

  public struct Events<A> {
    fileprivate let ref: A
    fileprivate init(_ ref: A) {
      self.ref = ref
    }
  }

  public protocol Evented {}

  extension NSObject: Evented {}

  public extension Evented {
    public var events: Events<Self> {
        get { return Events(self) }
        //I need this mutable for my keyPath shit
        set { self = Events(self).ref }
    }
  }

  private var gestureRecognizerKey = 0

  private final class GestureRecognizer: UIGestureRecognizer {
    fileprivate let touchesBeganEvent = Event<Set<UITouch>>()
    fileprivate let touchesMovedEvent = Event<Set<UITouch>>()
    fileprivate let touchesEndedEvent = Event<Set<UITouch>>()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
      self.touchesBeganEvent.push(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
      self.touchesMovedEvent.push(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
      self.touchesEndedEvent.push(touches)
    }
  }

  public extension Events where A: UIView {
    private var gestureRecognizer: GestureRecognizer {
      return objc_getAssociatedObject(self.ref, &gestureRecognizerKey) as? GestureRecognizer
        ?? {
          let gestureRecognizer = GestureRecognizer()
          objc_setAssociatedObject(self.ref, &gestureRecognizerKey, gestureRecognizer, .OBJC_ASSOCIATION_RETAIN)
          self.ref.addGestureRecognizer(gestureRecognizer)
          return gestureRecognizer
        }()
    }

    var touches: Event<Set<UITouch>> {
      return self.touchesBegan <|> self.touchesMoved <|> self.touchesEnded
    }

    var touchesBegan: Event<Set<UITouch>> {
      return self.gestureRecognizer.touchesBeganEvent
    }

    var touchesMoved: Event<Set<UITouch>> {
      return self.gestureRecognizer.touchesMovedEvent
    }

    var touchesEnded: Event<Set<UITouch>> {
      return self.gestureRecognizer.touchesEndedEvent
    }
  }

  extension UIView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.events.touchesBegan.push(touches)
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.events.touchesMoved.push(touches)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.events.touchesEnded.push(touches)
    }
  }

  import QuartzCore

	private final class Animator {
    let callback: () -> ()

    init(_ callback: @escaping () -> ()) {
      self.callback = callback
      CADisplayLink(target: self, selector: #selector(step)).add(to: .current, forMode: .defaultRunLoopMode)
    }

    @objc func step(displaylink: CADisplayLink) {
      callback()
    }
  }

  public let animationFrame: Event<()> = {
    let (event, push) = Event<()>.create()
    _ = Animator(push)
    return event
  }()

//added UIControlEvents


extension Events where A: UIControl {
    subscript(_ controlEvents: UIControlEvents) -> (UIControlEvents, A) -> () {
        get { return { _ in } }
        set {
            ref.on(controlEvents) { [unowned ref] _ in
                newValue(controlEvents, ref)
            }
        }
    }
}

extension UIControl {
    private static var storageKey = 0
    fileprivate var eventsStorage: DictWrapper<UIControlEvents, (UIControl) -> ()> {
        return objc_getAssociatedObject(self, &UIControl.storageKey) as? DictWrapper<UIControlEvents, (UIControl) -> ()> ?? {
            let newStorage = DictWrapper<UIControlEvents, (UIControl) -> ()>()
            objc_setAssociatedObject(self, &UIControl.storageKey, newStorage, .OBJC_ASSOCIATION_RETAIN)
            return newStorage
            }()
    }

    

}

extension UIControlEvents: Hashable {
    public var hashValue: Int { return Int(rawValue) }
}

#endif
