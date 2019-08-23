//
//  UIControl.swift
//  Training
//
//  Created by Bryan on 10/26/16.
//  Copyright © 2016 Bryan Lloyd Anderson. All rights reserved.
//

import Foundation
import UIKit

//public enum AUIControlEvent: UInt {
//    case touchDown = 1
//    case touchDownRepeat = 2
//    case touchDragInside = 4
//    case touchDragOutside = 8
//    case touchDragEnter = 16
//    case touchDragExit = 32
//    case touchUpInside = 64
//    case touchUpOutside = 128
//    case touchCancel = 256
//    
//    case valueChanged = 4096
//    
//    case editingDidBegin = 65536
//    case editingChanged = 131072
//    case editingDidEnd = 262144
//    case editingDidEndOnExit = 524288
//    
//    case allTouchEvents = 0x00000FFF
//    case allEditingEvents = 0x000F0000
//    case applicationReserved = 0x0F000000
//    case systemReserved = 0xF0000000
//    case allEvents = 0xFFFFFFFF
//    
//    public static func auiEventsFromUI(_ events: UIControl.Event) -> [AUIControlEvent] {
//        var evs = [AUIControlEvent]()
//        let ev = events.rawValue
//        let one: UInt = 1
//        for i: UInt in 0 ..< 20 {
//            let it = one << i
//            if (it & ev) > 0 {
//                if let auievent = AUIControlEvent(rawValue: it) {
//                    evs.append(auievent)
//                }
//            }
//        }
//        return evs
//    }
//}
//
//open class ArkUI {
//    static let instance = ArkUI()
//    static var listeners = Dictionary < WeakKey<UIView>, [AUIControlEvent: Array < (_ sender: AnyObject) -> () >] > ()
//    static func addListener(_ view: UIView, events: [AUIControlEvent], listener: @escaping (_ sender: AnyObject) -> ()) {
//        WeakCollections.clean(dictionary: &listeners)
//        let viewKey = WeakCollections.weakKeyOrNew(key: view, dict: listeners)
//        var viewListeners = listeners[viewKey]
//        if viewListeners == nil {
//            viewListeners = [AUIControlEvent: Array < (_ sender: AnyObject) -> () >]()
//            listeners[viewKey] = viewListeners!
//        }
//        var lists = viewListeners!
//        for event in events {
//            var evlist = lists[event]
//            if evlist == nil {
//                evlist = Array < (_ sender: AnyObject) -> () > ()
//                lists[event] = evlist!
//            }
//            evlist!.append(listener)
//            lists[event] = evlist!
//        }
//        listeners[viewKey] = lists
//    }
//    static func removeListener(_ view: UIView, events: [AUIControlEvent], listener: @escaping (_ sender: AnyObject) -> ()) {
//        WeakCollections.clean(dictionary: &listeners)
//        if let viewKey = WeakCollections.weakKey(key: view, dictionary: listeners) {
//            var viewListeners = listeners[viewKey]!
//            for event in events {
//                if var evlisteners = viewListeners[event] {
//                    var indexForRemove = -1
//                    for (index, list) in evlisteners.enumerated() {
//                        let listfix = list as(_ sender: AnyObject) -> ()
//                        if listfix === listener {
//                            indexForRemove = index
//                        }
//                    }
//                    if indexForRemove > -1 {
//                        _ = evlisteners.remove(at: indexForRemove)
//                        viewListeners[event] = evlisteners
//                    }
//                }
//            }
//        }
//    }
//    
//    static func addTargetIfNeeded(_ view: UIControl, event: UIControl.Event) {
//        WeakCollections.clean(dictionary: &listeners)
//        let events = AUIControlEvent.auiEventsFromUI(event)
//        for ev in events {
//            if let viewKey = WeakCollections.weakKey(key: view, dictionary: listeners) {
//                guard let viewlisteners = listeners[viewKey] else { return }
//                if let _ = viewlisteners[ev] {
//                } else {
//                    view.addTarget(self, action: self.selector(ev), for: UIControl.Event(rawValue: ev.rawValue))
//                }
//            } else {
//                view.addTarget(self, action: self.selector(ev), for: UIControl.Event(rawValue: ev.rawValue))
//            }
//        }
//    }
//    
//    static func handleEvent(_ event: AUIControlEvent, sender: UIView) {
//        WeakCollections.clean(dictionary: &listeners)
//        if let lists = WeakCollections.valueForWeakKey(key: sender, dict: listeners) {
//            if let evlisteners = lists[event] {
//                for listener in evlisteners {
//                    listener(sender)
//                }
//            }
//        }
//    }
//    
//    static var gestureListeners = Dictionary < WeakKey<UIGestureRecognizer>, Array < (_ gestureRecognizer: UIGestureRecognizer) -> () >> ()
//    static var longPressListeners = Dictionary < WeakKey<UILongPressGestureRecognizer>, Array < (_ gestureRecognizer: UILongPressGestureRecognizer) -> () >> ()
//    static var panListeners = Dictionary < WeakKey<UIPanGestureRecognizer>, Array < (_ gestureRecognizer: UIPanGestureRecognizer) -> () >> ()
//    static var pinchListeners = Dictionary < WeakKey<UIPinchGestureRecognizer>, Array < (_ gestureRecognizer: UIPinchGestureRecognizer) -> () >> ()
//    static var rotationListeners = Dictionary < WeakKey<UIRotationGestureRecognizer>, Array < (_ gestureRecognizer: UIRotationGestureRecognizer) -> () >> ()
//    static var swipeListeners = Dictionary < WeakKey<UISwipeGestureRecognizer>, Array < (_ gestureRecognizer: UISwipeGestureRecognizer) -> () >> ()
//    static var tapListeners = Dictionary < WeakKey<UITapGestureRecognizer>, Array < (_ gestureRecognizer: UITapGestureRecognizer) -> () >> ()
//    
//    static func addGesture<T: UIGestureRecognizer>(_ gesture: T, listener: @escaping (_ gestureRecognizer: T) -> (), gestureListeners: inout Dictionary < WeakKey<T>, Array < (_ gestureRecognizer: T) -> () >>) {
//        WeakCollections.clean(dictionary: &gestureListeners)
//        let gestureKey = WeakCollections.weakKeyOrNew(key: gesture, dict: gestureListeners)
//        var listenersForKey = gestureListeners[gestureKey]
//        if listenersForKey == nil {
//            listenersForKey = Array < (_ gestureRecognizer: T) -> () > ()
//            gestureListeners[gestureKey] = listenersForKey
//        }
//        listenersForKey!.append(listener)
//        gestureListeners[gestureKey] = listenersForKey
//    }
//    
//    static func removeGesture<T: UIGestureRecognizer>(_ gesture: T, listener: (_ gestureRecognizer: T) -> (), gestureListeners: inout Dictionary < WeakKey<T>, Array < (_ gestureRecognizer: T) -> () >>) {
//        WeakCollections.clean(dictionary: &gestureListeners)
//        if let gestureKey = WeakCollections.weakKey(key: gesture, dictionary: gestureListeners) {
//            var lists = gestureListeners[gestureKey]!
//            var indexForRemove = -1
//            for (index, list) in lists.enumerated() {
//                if list === listener {
//                    indexForRemove = index
//                }
//            }
//            if indexForRemove > -1 {
//                _ = lists.remove(at: indexForRemove)
//                gestureListeners[gestureKey] = lists
//            }
//        }
//    }
//    
//    open static dynamic func handleGesture(_ gesture: UIGestureRecognizer) {
//        if let gest = gesture as? UITapGestureRecognizer {
//            if let lists = WeakCollections.valueForWeakKey(key: gest, dict: tapListeners) {
//                for f in lists {
//                    f(gest)
//                }
//            }
//        } else if let gest = gesture as? UIPinchGestureRecognizer {
//            if let lists = WeakCollections.valueForWeakKey(key: gest, dict: pinchListeners) {
//                for f in lists {
//                    f(gest)
//                }
//            }
//        } else if let gest = gesture as? UILongPressGestureRecognizer {
//            if let lists = WeakCollections.valueForWeakKey(key: gest, dict: longPressListeners) {
//                for f in lists {
//                    f(gest)
//                }
//            }
//        } else if let gest = gesture as? UIPanGestureRecognizer {
//            if let lists = WeakCollections.valueForWeakKey(key: gest, dict: panListeners) {
//                for f in lists {
//                    f(gest)
//                }
//            }
//        } else if let gest = gesture as? UIRotationGestureRecognizer {
//            if let lists = WeakCollections.valueForWeakKey(key: gest, dict: rotationListeners) {
//                for f in lists {
//                    f(gest)
//                }
//            }
//        } else if let gest = gesture as? UISwipeGestureRecognizer {
//            if let lists = WeakCollections.valueForWeakKey(key: gest, dict: swipeListeners) {
//                for f in lists {
//                    f(gest)
//                }
//            }
//        } else if let lists = WeakCollections.valueForWeakKey(key: gesture, dict: gestureListeners) {
//            for f in lists {
//                f(gesture)
//            }
//        }
//    }
//    
//    open static dynamic func touchCancel(_ sender: AnyObject) {
//        self.handleEvent(.touchCancel, sender: sender as! UIView)
//    }
//    
//    open static dynamic func touchDown(_ sender: AnyObject) {
//        self.handleEvent(.touchDown, sender: sender as! UIView)
//    }
//    
//    open static dynamic func touchDownRepeat(_ sender: AnyObject) {
//        self.handleEvent(.touchDownRepeat, sender: sender as! UIView)
//    }
//    
//    open static dynamic func touchDragEnter(_ sender: AnyObject) {
//        self.handleEvent(.touchDragEnter, sender: sender as! UIView)
//    }
//    
//    open static dynamic func touchDragExit(_ sender: AnyObject) {
//        self.handleEvent(.touchDragExit, sender: sender as! UIView)
//    }
//    
//    open static dynamic func touchUpInside(_ sender: AnyObject) {
//        self.handleEvent(.touchUpInside, sender: sender as! UIView)
//    }
//    
//    open static dynamic func touchUpOutside(_ sender: AnyObject) {
//        self.handleEvent(.touchUpOutside, sender: sender as! UIView)
//    }
//    
//    open static dynamic func valueChanged(_ sender: AnyObject) {
//        self.handleEvent(.valueChanged, sender: sender as! UIView)
//    }
//    
//    open static dynamic func editingChanged(_ sender: AnyObject) {
//        self.handleEvent(.editingChanged, sender: sender as! UIView)
//    }
//    
//    open static dynamic func editingDidBegin(_ sender: AnyObject) {
//        self.handleEvent(.editingDidBegin, sender: sender as! UIView)
//    }
//    
//    open static dynamic func editingDidEnd(_ sender: AnyObject) {
//        self.handleEvent(.editingDidEnd, sender: sender as! UIView)
//    }
//    
//    open static dynamic func editingDidEndOnExit(_ sender: AnyObject) {
//        self.handleEvent(.editingDidEndOnExit, sender: sender as! UIView)
//    }
//    
//    open static dynamic func systemReserved(_ sender: AnyObject) {
//        self.handleEvent(.systemReserved, sender: sender as! UIView)
//    }
//    
//    open static dynamic func applicationReserved(_ sender: AnyObject) {
//        self.handleEvent(.applicationReserved, sender: sender as! UIView)
//    }
//    
//    open static dynamic func allEvents(_ sender: AnyObject) {
//        self.handleEvent(.allEvents, sender: sender as! UIView)
//    }
//    
//    open static dynamic func allTouchEvents(_ sender: AnyObject) {
//        self.handleEvent(.allTouchEvents, sender: sender as! UIView)
//    }
//    
//    open static dynamic func allEditingEvents(_ sender: AnyObject) {
//        self.handleEvent(.allEditingEvents, sender: sender as! UIView)
//    }
//    
//    static func selector(_ event: AUIControlEvent) -> Selector {
//        switch event {
//        case .touchCancel:
//            return #selector(ArkUI.touchCancel(_:))
//        case .touchDown:
//            return #selector(ArkUI.touchDown(_:))
//        case .touchDownRepeat:
//            return #selector(ArkUI.touchDownRepeat(_:))
//        case .touchDragEnter:
//            return #selector(ArkUI.touchDragEnter(_:))
//        case .touchDragExit:
//            return #selector(ArkUI.touchDragExit(_:))
//        case .touchDragInside:
//            // TODO: resolve, not defined
//            return Selector(("touchDragInside:"))
//        case .touchDragOutside:
//            // TODO: resolve, not defined
//            return Selector("touchDragOutside:")
//        case .touchUpInside:
//            return #selector(ArkUI.touchUpInside(_:))
//        case .touchUpOutside:
//            return #selector(ArkUI.touchUpOutside(_:))
//        case .valueChanged:
//            return #selector(ArkUI.valueChanged(_:))
//        case .editingChanged:
//            return #selector(ArkUI.editingChanged(_:))
//        case .editingDidBegin:
//            return #selector(ArkUI.editingDidBegin(_:))
//        case .editingDidEnd:
//            return #selector(ArkUI.editingDidEnd(_:))
//        case .editingDidEndOnExit:
//            return #selector(ArkUI.editingDidEndOnExit(_:))
//        case .systemReserved:
//            return #selector(ArkUI.systemReserved(_:))
//        case .applicationReserved:
//            return #selector(ArkUI.applicationReserved(_:))
//        case .allEvents:
//            return #selector(ArkUI.allEvents(_:))
//        case .allTouchEvents:
//            return #selector(ArkUI.allTouchEvents(_:))
//        case .allEditingEvents:
//            return #selector(ArkUI.allEditingEvents(_:))
//        }
//    }
//}
//
//public extension UIControl {
//    public func on(_ event: UIControl.Event, listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.addListener(event, listener: listener)
//    }
//    public func onTouchUpInside(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.touchUpInside, listener: listener)
//    }
//    public func onTouchUpOutside(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.touchUpOutside, listener: listener)
//    }
//    public func onValueChanged(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.valueChanged, listener: listener)
//    }
//    public func onTouchCancel(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.touchCancel, listener: listener)
//    }
//    public func onTouchDown(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.touchDown, listener: listener)
//    }
//    public func onTouchDownRepeat(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.touchDownRepeat, listener: listener)
//    }
//    public func onTouchDragEnter(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.touchDragEnter, listener: listener)
//    }
//    public func onTouchDragOutside(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.touchDragOutside, listener: listener)
//    }
//    public func onTouchDragInside(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.touchDragInside, listener: listener)
//    }
//    public func onTouchDragExit(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.touchDragExit, listener: listener)
//    }
//    public func onEditingChanged(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.editingChanged, listener: listener)
//    }
//    public func onEditingDidBegin(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.editingDidBegin, listener: listener)
//    }
//    public func onEditingDidEnd(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.editingDidEnd, listener: listener)
//    }
//    public func onEditingDidEndOnExit(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.editingDidEndOnExit, listener: listener)
//    }
//    public func onAllEvents(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.allEvents, listener: listener)
//    }
//    public func onAllTouchEvents(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.allTouchEvents, listener: listener)
//    }
//    public func onAllEditingEvents(_ listener: @escaping (_ sender: AnyObject) -> ()) {
//        self.on(.allEditingEvents, listener: listener)
//    }
//    public func addListener(_ event: UIControl.Event, listener: @escaping (_ sender: AnyObject) -> ()) {
//        ArkUI.addTargetIfNeeded(self, event: event)
//        ArkUI.addListener(self, events: AUIControlEvent.auiEventsFromUI(event), listener: listener)
//    }
//    public func removeListener(_ event: UIControl.Event, listener: @escaping (_ sender: AnyObject) -> ()) {
//        ArkUI.removeListener(self, events: AUIControlEvent.auiEventsFromUI(event), listener: listener)
//    }
//}
//
//public extension UIGestureRecognizer {
//    public convenience init(_ listener: @escaping (_ gestureRecognizer: UIGestureRecognizer) -> ()) {
//        self.init(target: ArkUI.self, action: #selector(ArkUI.handleGesture(_:)))
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.gestureListeners)
//    }
//    public func onGesture(_ listener: @escaping (_ gestureRecognizer: UIGestureRecognizer) -> ()) {
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.gestureListeners)
//    }
//    public func addListener(_ listener: @escaping (_ gestureRecognizer: UIGestureRecognizer) -> ()) {
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.gestureListeners)
//    }
//    public func removeListener(_ listener: (_ gestureRecognizer: UIGestureRecognizer) -> ()) {
//        ArkUI.removeGesture(self, listener: listener, gestureListeners: &ArkUI.gestureListeners)
//    }
//}
//
//public extension UITapGestureRecognizer {
//    public convenience init(_ listener: @escaping (_ gestureRecognizer: UITapGestureRecognizer) -> ()) {
//        self.init(target: ArkUI.self, action: #selector(ArkUI.handleGesture(_:)))
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.tapListeners)
//    }
//    public override func onGesture(_ listener: @escaping (_ gestureRecognizer: UITapGestureRecognizer) -> ()) {
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.tapListeners)
//    }
//    public override func addListener(_ listener: @escaping (_ gestureRecognizer: UITapGestureRecognizer) -> ()) {
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.tapListeners)
//    }
//    public override func removeListener(_ listener: (_ gestureRecognizer: UITapGestureRecognizer) -> ()) {
//        ArkUI.removeGesture(self, listener: listener, gestureListeners: &ArkUI.tapListeners)
//    }
//}
//
//public extension UILongPressGestureRecognizer {
//    public convenience init(_ listener: @escaping (_ gestureRecognizer: UILongPressGestureRecognizer) -> ()) {
//        self.init(target: ArkUI.self, action: #selector(ArkUI.handleGesture(_:)))
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.longPressListeners)
//    }
//    public override func onGesture(_ listener: @escaping (_ gestureRecognizer: UILongPressGestureRecognizer) -> ()) {
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.longPressListeners)
//    }
//    public override func addListener(_ listener: @escaping (_ gestureRecognizer: UILongPressGestureRecognizer) -> ()) {
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.longPressListeners)
//    }
//    public override func removeListener(_ listener: (_ gestureRecognizer: UILongPressGestureRecognizer) -> ()) {
//        ArkUI.removeGesture(self, listener: listener, gestureListeners: &ArkUI.longPressListeners)
//    }
//}
//
//public extension UIPanGestureRecognizer {
//    public convenience init(_ listener: @escaping (_ gestureRecognizer: UIPanGestureRecognizer) -> ()) {
//        self.init(target: ArkUI.self, action: #selector(ArkUI.handleGesture(_:)))
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.panListeners)
//    }
//    public override func onGesture(_ listener: @escaping (_ gestureRecognizer: UIPanGestureRecognizer) -> ()) {
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.panListeners)
//    }
//    public override func addListener(_ listener: @escaping (_ gestureRecognizer: UIPanGestureRecognizer) -> ()) {
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.panListeners)
//    }
//    public override func removeListener(_ listener: (_ gestureRecognizer: UIPanGestureRecognizer) -> ()) {
//        ArkUI.removeGesture(self, listener: listener, gestureListeners: &ArkUI.panListeners)
//    }
//}
//
//public extension UIPinchGestureRecognizer {
//    public convenience init(_ listener: @escaping (_ gestureRecognizer: UIPinchGestureRecognizer) -> ()) {
//        self.init(target: ArkUI.self, action: #selector(ArkUI.handleGesture(_:)))
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.pinchListeners)
//    }
//    public override func onGesture(_ listener: @escaping (_ gestureRecognizer: UIPinchGestureRecognizer) -> ()) {
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.pinchListeners)
//    }
//    public override func addListener(_ listener: @escaping (_ gestureRecognizer: UIPinchGestureRecognizer) -> ()) {
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.pinchListeners)
//    }
//    public override func removeListener(_ listener: (_ gestureRecognizer: UIPinchGestureRecognizer) -> ()) {
//        ArkUI.removeGesture(self, listener: listener, gestureListeners: &ArkUI.pinchListeners)
//    }
//}
//
//public extension UIRotationGestureRecognizer {
//    public convenience init(_ listener: @escaping (_ gestureRecognizer: UIRotationGestureRecognizer) -> ()) {
//        self.init(target: ArkUI.self, action: #selector(ArkUI.handleGesture(_:)))
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.rotationListeners)
//    }
//    public override func onGesture(_ listener: @escaping (_ gestureRecognizer: UIRotationGestureRecognizer) -> ()) {
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.rotationListeners)
//    }
//    public override func addListener(_ listener: @escaping (_ gestureRecognizer: UIRotationGestureRecognizer) -> ()) {
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.rotationListeners)
//    }
//    public override func removeListener(_ listener: (_ gestureRecognizer: UIRotationGestureRecognizer) -> ()) {
//        ArkUI.removeGesture(self, listener: listener, gestureListeners: &ArkUI.rotationListeners)
//    }
//}
//
//public extension UISwipeGestureRecognizer {
//    public convenience init(_ listener: @escaping (_ gestureRecognizer: UISwipeGestureRecognizer) -> ()) {
//        self.init(target: ArkUI.self, action: #selector(ArkUI.handleGesture(_:)))
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.swipeListeners)
//    }
//    public override func onGesture(_ listener: @escaping (_ gestureRecognizer: UISwipeGestureRecognizer) -> ()) {
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.swipeListeners)
//    }
//    public override func addListener(_ listener: @escaping (_ gestureRecognizer: UISwipeGestureRecognizer) -> ()) {
//        ArkUI.addGesture(self, listener: listener, gestureListeners: &ArkUI.swipeListeners)
//    }
//    public override func removeListener(_ listener: (_ gestureRecognizer: UISwipeGestureRecognizer) -> ()) {
//        ArkUI.removeGesture(self, listener: listener, gestureListeners: &ArkUI.swipeListeners)
//    }
//}
//
//func peekFunc<A, R>(f: @escaping (A) -> R) -> (fp: Int, ctx: Int) {
//    typealias IntInt = (Int, Int)
//    let (_, lo) = unsafeBitCast(f, to: IntInt.self)
//    let offset = MemoryLayout<Int>.size == 8 ? 16 : 12
//    let ptr = UnsafePointer<Int>(bitPattern: lo + offset)
//    return (ptr!.pointee, ptr!.successor().pointee)
//}
//
//func === <A, R>(lhs: @escaping (A) -> R, rhs: @escaping (A) -> R) -> Bool {
//    let (tl, tr) = (peekFunc(f: lhs), peekFunc(f: rhs))
//    return tl.0 == tr.0 && tl.1 == tr.1
//}
//
//class Weak<T: AnyObject> where T: Equatable {
//    weak var value: T?
//    init(value: T) {
//        self.value = value
//    }
//}
//
//class WeakKey<T: AnyObject>: Weak<T>, Hashable where T: Hashable {
//    override init(value: T) {
//        _hashValue = value.hashValue
//        super.init(value: value)
//    }
//    var hashValue: Int {
//        return _hashValue
//    }
//    let _hashValue: Int
//}
//
//func === <T>(lhs: Weak<T>, rhs: Weak<T>) -> Bool {
//    if let lhsv = lhs.value {
//        if let rhsv = rhs.value {
//            return lhsv === rhsv
//        }
//    }
//    return false
//}
//
//func === <T>(lhs: WeakKey<T>, rhs: WeakKey<T>) -> Bool {
//    if let lhsv = lhs.value {
//        if let rhsv = rhs.value {
//            return lhsv === rhsv
//        }
//    }
//    return false
//}
//
//func == <T>(lhs: Weak<T>, rhs: Weak<T>) -> Bool where T: Equatable {
//    if let lhsv = lhs.value {
//        if let rhsv = rhs.value {
//            return lhsv == rhsv
//        }
//    }
//    return false
//}
//
//func == <T>(lhs: WeakKey<T>, rhs: WeakKey<T>) -> Bool where T: Equatable {
//    if let lhsv = lhs.value {
//        if let rhsv = rhs.value {
//            return lhsv == rhsv
//        }
//    }
//    return false
//}
//
//class WeakCollections {
//    static func valueForWeakKey <T, U>(key: T, dict: [WeakKey<T>: U]) -> U? {
//        let keys = dict.keys
//        for k in keys {
//            if k.hashValue == key.hashValue {
//                return dict[k]
//            }
//        }
//        return nil
//    }
//    
//    static func weakKeyOrNew <T: AnyObject, U>(key: T, dict: Dictionary<WeakKey<T>, U>) -> WeakKey<T> where T: Hashable {
//        return self.weakKey(key: key, dictionary: dict) ?? WeakKey<T>(value: key)
//    }
//    
//    static func weakKey <T, U>(key: T, dictionary: Dictionary<WeakKey<T>, U>) -> WeakKey<T>? {
//        let keys = dictionary.keys
//        for k in keys {
//            if k.hashValue == key.hashValue {
//                return k
//            }
//        }
//        return nil
//    }
//    
//    static func clean <T, U>( dictionary: inout Dictionary<WeakKey<T>, U>) {
//        var needClean = [WeakKey<T>]()
//        for k in dictionary.keys {
//            if k.value == nil {
//                needClean.append(k)
//            }
//        }
//        for k in needClean {
//            dictionary.removeValue(forKey: k)
//        }
//    }
//}
//
//
