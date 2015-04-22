//
//  NEvent.m
//  Pods
//
//  Created by Naithar on 23.04.15.
//
//

#import "NEvent.h"

@implementation NEvent

@end


////
////  EventListener.swift
////
////  Created by Naithar on 14.09.14.
////  Naithar
////
////  Copyright (c) 2014 'ITC-Project' LLC http://itcproject.ru
////  All rights reserved.
////
//
//import Foundation
//
//public typealias EventClosure = ([String: AnyObject]!) -> ()
//
//private let CancelEventNotification: String = "CANCEL-EVENT-IN-LISTENERS"
////private let SaveEventNotification: String = "EVENT-STAYS-IN-LISTENERS"
//private let RemoveFromQueueNotification: String = "REMOVE-EVENT-FROM-QUEUE"
//
//private let EventNameAttribute: String = "Event-NAME-Attribute"
//private let EventDataAttribute: String = "Event-DATA-Attribute"
//private let EventQueueListenerName: String = "EVENTQueue-EVENT-LISTENER"
//
//@objc public class Observer: NSObject {
//    public var name: String
//    public var action: EventClosure?
//    private(set) weak var target: NSObject?
//    private(set) var keyPath: String?
//    private(set) var once: Bool = false
//
//    public init(name: String) {
//        self.name = name
//
//        super.init()
//    }
//
//    private func setAsObserverFor(#target: NSObject?, keyPath: String, closure: EventClosure?) {
//
//        if let object = self.target {
//            self.remove(object)
//        }
//
//        self.keyPath = keyPath
//        self.action = closure
//        self.target = target
//
//        if self.target?.respondsToSelector(NSSelectorFromString(keyPath)) == true {
//            self.target?.addObserver(
//                                     self,
//                                     forKeyPath: keyPath,
//                                     options: .New | .Old | .Initial,
//                                     context: nil)
//        }
//    }
//
//    public func on(target: NSObject?, keyPath: String, closure: EventClosure?) {
//        self.setAsObserverFor(target: target, keyPath: keyPath, closure: closure)
//        self.once = false
//    }
//
//    public func once(target: NSObject?, keyPath: String, closure: EventClosure?) {
//        self.setAsObserverFor(target: target, keyPath: keyPath, closure: closure)
//        self.once = true
//    }
//
//    public override func observeValueForKeyPath(
//                                                keyPath: String,
//                                                ofObject object: AnyObject,
//                                                change: [NSObject : AnyObject],
//                                                context: UnsafeMutablePointer<Void>) {
//        synchronize(self) {
//            self.observe(object: object, keyPath: keyPath, data: change)
//        }
//    }
//
//    private func observe(
//#object: AnyObject,
//                         keyPath: String,
//                         data: [NSObject : AnyObject]) {
//        if self.target == object as? NSObject
//            && keyPath == self.keyPath {
//                self.action?(data as? [String : AnyObject])
//                if self.once {
//                    self.remove(self.target)
//                }
//            }
//    }
//
//    public func remove(target: NSObject?) {
//        if let keyPath = self.keyPath {
//
//            if target?.respondsToSelector(NSSelectorFromString(keyPath)) == true {
//                target?.removeObserver(self, forKeyPath: keyPath, context: nil)
//                self.target?.removeObserver(self, forKeyPath: keyPath, context: nil)
//                self.target = nil
//                self.keyPath = nil
//                self.action = nil
//            }
//
//
//            //            }
//        }
//    }
//
//    deinit {
//        self.remove(self.target)
//
//        //NSLog("deinit observer")
//    }
//
//}
//
/////
//@objc public class Event {
//    ///
//    public var name: String
//    ///
//    public var action: EventClosure?
//    ///
//    private(set) weak var listener: Listener?
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//
//     :return: <#return description#>
//     */
//    public init(name: String, action: EventClosure?, listener: Listener?) {
//        self.name = name
//        self.action = action
//        self.listener = listener
//    }
//
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//
//     :return: <#return description#>
//     */
//    public convenience init(name: String, action: EventClosure?) {
//        self.init(name: name, action: action, listener: nil)
//    }
//
//    //    public convenience init(action: EventClosure?) {
//    //        self.init(name: "", action: action, listener: nil)
//    //    }
//
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//
//     :return: <#return description#>
//     */
//    public func call(data: [String: AnyObject]? = nil) {
//        self.action?(data)
//    }
//
//    deinit {
//        //NSLog("")
//    }
//}
//
//// MARK: -
//private class EventQueue {
//    lazy private var queue: [String : AnyObject] = [:]
//    lazy private var onceArray: [String] = []
//
//    //    lazy private var queue: [String : Bool] = [:]
//    //    private var removeEventObserver: AnyObject!
//    private var eventQueueListener: Listener
//
//    class func sharedInstance() -> EventQueue {
//        struct Static {
//            static let instance = EventQueue()
//        }
//        return Static.instance
//    }
//
//    init() {
//        self.eventQueueListener = Listener(name: EventQueueListenerName, inheritQueue: false)
//        self.eventQueueListener[RemoveFromQueueNotification] = { [weak weakSelf = self] data in
//            if let name = data?[EventNameAttribute] as? String {
//
//                if ((weakSelf?.onceArray.filter { $0 == name })?.count ?? 0) > 0 {
//                    weakSelf?.removeFromQueue(name: name)
//
//                    weakSelf?.onceArray = weakSelf?.onceArray.filter { $0 != name } ?? weakSelf?.onceArray ?? []
//                }
//
//            }
//        }
//    }
//
//    func add(#name: String, data: [String : AnyObject]?, once: Bool) {
//        self.queue[name] = data ?? [:]
//
//        if once {
//            self.onceArray.append(name)
//        }
//    }
//
//    func clear() {
//        self.queue = [:]
//        self.onceArray = []
//    }
//
//    func removeFromQueue(#name: String) {
//        self.queue[name] = nil
//    }
//
//    deinit {
//        self.clear()
//        //        NSNotificationCenter.defaultCenter().removeObserver(self.removeEventObserver)
//    }
//}
//
//// MARK: -
//
/////
//@objc public class Listener: NSObject {
//    ///
//    //    private var cancelEventNotificationObserver: AnyObject!
//    //    private var saveEventNotificationObserver: AnyObject!
//    ///
//    public private(set) var name: String
//    ///
//    public var paused: Bool {
//        didSet {
//            if !self.paused && self.eventQueue.count > 0 {
//                for (eventName, data) in self.eventQueue {
//                    let storedEvents = self.events.filter({ (event) -> Bool in
//                        return event.name == eventName
//                    })
//
//                    if storedEvents.count > 0 {
//                        if let event = storedEvents.first {
//                            self.launchEvent(event, data: data as? [String : AnyObject])
//                        }
//                    }
//                    else {
//                        self.eventQueue.removeValueForKey(eventName)
//                    }
//
//                }
//            }
//        }
//    }
//    public var enabled: Bool
//
//    ///
//    final lazy public private(set) var events: [Event] = []
//    ///
//    final lazy private private(set) var observers: [AnyObject] = []
//    ///
//    final lazy public private(set) var eventQueue: [String : AnyObject] = [:]
//
//    public subscript(key: String) -> EventClosure? {
//        get {
//            if /*key == SaveEventNotification
//                ||*/ key == CancelEventNotification {
//                    return nil
//                }
//
//            return self.eventWithName(key)?.action
//        }
//        set {
//            if newValue == nil {
//                if /*key == SaveEventNotification
//                    ||*/ key == CancelEventNotification {
//                        return
//                    }
//
//                self.removeWithName(key)
//            }
//            else {
//                var existingEvent = self.eventWithName(key)
//                if existingEvent == nil {
//                    var event = Event(name: key, action: newValue, listener: self)
//                    self.addEvent(event)
//                }
//                else {
//                    if /*key == SaveEventNotification
//                        ||*/ key == CancelEventNotification {
//                            return
//                        }
//
//                    existingEvent?.action = newValue
//                }
//            }
//        }
//    }
//
//    //    public subscript(index: Int) -> EventClosure? {
//    //        get {
//    //            return (index < 0 || index >= self.events.count) ?
//    //                nil :
//    //                self.events[index].action
//    //        }
//    //        set {
//    //            if newValue == nil {
//    //                self.removeAtIndex(index)
//    //            }
//    //            else {
//    //                if index < 0 || index >= self.events.count {
//    //                    var event = Event(name: "unknownEvent-(\(generateRandomString(length: 4)))", action: newValue, listener: self)
//    //                    self.addEvent(event)
//    //                }
//    //                else {
//    //                    self.events[index].action = newValue
//    //                }
//    //            }
//    //        }
//    //    }
//
//    /**
//     Returns event listener with specified name
//
//     :param: name name of event listener
//     */
//    public init(name: String, inheritQueue: Bool = false) {
//        self.name = name
//        self.paused = false
//        self.enabled = true
//
//        super.init()
//
//        self[CancelEventNotification] = { [weak weakSelf = self] data in
//            if let name = data?[EventNameAttribute] as? String {
//                weakSelf?.eventQueue[name] = nil
//            }
//            return
//        }
//
//        //        self[SaveEventNotification] = { [weak weakSelf = self] data in
//        //            if let name = data?[EventNameAttribute] as? String {
//        //                weakSelf?.eventQueue[name] = (data?[EventDataAttribute] as? [String : AnyObject]) ?? [:]
//        //            }
//        //        }
//
//        if inheritQueue {
//            self.eventQueue = EventQueue.sharedInstance().queue
//        }
//    }
//
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//
//     :return: <#return description#>
//     */
//    public class func sharedInstance() -> Listener {
//        struct Static {
//            static let instance = Listener(name: "default-listener")
//        }
//
//        return Static.instance
//    }
//
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//
//     :return: <#return description#>
//     */
//    public func addEvent(event: Event) -> Bool {
//        var existingEvent = self.eventWithName(event.name)
//
//        if existingEvent != nil {
//            return false
//        }
//
//        event.listener = self
//        self.events.append(event)
//
//        var observer = NSNotificationCenter.defaultCenter()
//        .addObserverForName(event.name,
//                            object: nil,
//                            queue: nil, usingBlock: { [weak weakSelf = self] notification in
//                                if weakSelf == nil {
//                                    return
//                                }
//
//                                if weakSelf?.enabled == false {
//                                    return
//                                }
//
//                                if weakSelf?.paused == false {
//                                    //                        event.call(data: notification.userInfo as? [String : AnyObject])
//                                    weakSelf?.launchEvent(
//                                                          event,
//                                                          data: notification.userInfo as? [String : AnyObject])
//                                }
//                                else {
//                                    weakSelf?.eventQueue[event.name] = notification.userInfo ?? [:]
//                                }
//                                return
//                            })
//
//        self.observers.append(observer)
//
//        if self.eventQueue[event.name] != nil
//            && !self.paused {
//                self.launchEvent(
//                                 event,
//                                 data: self.eventQueue[event.name] as? [String : AnyObject])
//            }
//
//        return true
//    }
//
//    private func launchEvent(event: Event, data: [String : AnyObject]?) {
//        event.call(data: data)
//        self.eventQueue[event.name] = nil
//
//        if /*event.name != SaveEventNotification
//            && */event.name != CancelEventNotification
//            && self.name != EventQueueListenerName {
//                Listener.callEventByName(
//                                         RemoveFromQueueNotification,
//                                         data: [EventNameAttribute : event.name])
//            }
//    }
//
//    public func clearQueue() {
//        self.eventQueue = [:]
//    }
//
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//
//     :return: <#return description#>
//     */
//    public func eventWithName(name: String) -> Event? {
//        var filtered = self.events.filter { (item: Event) -> Bool in
//            return item.name == name
//        }
//
//        return filtered.first
//    }
//
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//
//     :return: <#return description#>
//     */
//    public func removeWithName(name: String) {
//        //        for var i = 0; i < self.events.count; i++ {
//        //            if self.events[i].name == name {
//        //                self.removeAtIndex(i)
//        //            }
//        //        }
//
//        for (index, event) in enumerate(self.events) {
//            if event.name == name {
//                self.removeAtIndex(index)
//            }
//        }
//    }
//
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//
//     :return: <#return description#>
//     */
//    public func removeAtIndex(index: Int) {
//        if index < 0 || index >= self.events.count {
//            return
//        }
//
//        var event = self.events[index]
//        event.listener = nil
//        self.eventQueue[event.name] = nil
//
//        self.events.removeAtIndex(index)
//
//        var observer: AnyObject = self.observers[index]
//        NSNotificationCenter.defaultCenter().removeObserver(observer)
//        self.observers.removeAtIndex(index)
//    }
//
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//
//     :return: <#return description#>
//     */
//    public func removeAll() {
//        for observer in self.observers {
//            NSNotificationCenter.defaultCenter().removeObserver(observer)
//        }
//
//        self.events = []
//        self.eventQueue = [:]
//        self.observers = []
//    }
//
//    deinit {
//        self.removeAll()
//
//        //        NSNotificationCenter.defaultCenter()
//        //            .removeObserver(self.saveEventNotificationObserver)
//        //        NSNotificationCenter.defaultCenter()
//        //            .removeObserver(self.cancelEventNotificationObserver)
//    }
//}
//
//extension Listener {
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//
//     :return: <#return description#>
//     */
//
//    public class func addToQueue(
//#name: String,
//                                 data: [String: AnyObject]? = nil,
//                                 once: Bool = true, call: Bool = true) {
//        EventQueue.sharedInstance().add(
//                                        name: name,
//                                        data: data,
//                                        once: once)
//
//        if call {
//            Listener.callEventByName(
//                                     name,
//                                     data: data)
//        }
//    }
//
//    public class func removeEventWithName(name: String) {
//        EventQueue.sharedInstance().removeFromQueue(name: name)
//        Listener.cancelEventWithName(name)
//    }
//
//    public class func clearQueue() {
//        EventQueue.sharedInstance().clear()
//    }
//
//    public class func callEventByName(
//                                      name: String,
//                                      data: [String: AnyObject]? = nil) {
//
//        NSNotificationCenter.defaultCenter()
//        .postNotificationName(
//                              name,
//                              object: nil,
//                              userInfo: data)
//
//        //            if shouldWait {
//        //                var userInfo: [String: AnyObject] = [EventNameAttribute : name]
//        //                userInfo[EventDataAttribute] = data
//        //
//        //                NSNotificationCenter.defaultCenter()
//        //                    .postNotificationName(
//        //                        SaveEventNotification,
//        //                        object: nil,
//        //                        userInfo: userInfo)
//        //            }
//    }
//
//    public class func cancelEventWithName(
//                                          name: String) {
//        NSNotificationCenter.defaultCenter()
//        .postNotificationName(
//                              CancelEventNotification,
//                              object: nil,
//                              userInfo: [EventNameAttribute : name])
//    }
//}
//// MARK: -
//
/////
//public class ListenerContainer {
//    ///
//    public private(set) var name: String!
//    ///
//    final lazy public private(set) var listeners: [Listener] = [Listener]()
//
//
//    public subscript (index: Int) -> Listener? {
//        get {
//            return (index < 0 || index >= self.listeners.count) ?
//            nil :
//            self.listeners[index]
//        }
//        set {
//            if newValue != nil {
//                if index < 0 || index >= self.listeners.count {
//                    self.addListener(newValue!)
//                }
//                else {
//                    self.listeners[index] = newValue!
//                }
//            }
//            else {
//                self.removeAtIndex(index)
//            }
//        }
//    }
//
//    public subscript (key: String) -> Listener? {
//        get {
//            return self.listenerWithName(key)
//        }
//    }
//
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//
//     :return: <#return description#>
//     */
//    public class func sharedInstance() -> ListenerContainer {
//        struct Static {
//            static let instance = ListenerContainer(name: "default-listenerContainer")
//        }
//
//        return Static.instance
//    }
//
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//
//     :return: <#return description#>
//     */
//    public init() {
//        self.name = "listenerContainer-\(generateRandomString(length: 5))"
//    }
//
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//
//     :return: <#return description#>
//     */
//    public init(name: String!) {
//        self.name = name
//    }
//
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//
//     :return: <#return description#>
//     */
//    public func removeAll() {
//        self.listeners = []
//    }
//
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//
//     :return: <#return description#>
//     */
//    public func resumeAllListeners() {
//        for listener in self.listeners {
//            listener.paused = false
//        }
//    }
//
//    /**
//     <#Brief description#>
//
//     <#Description#>
//
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//
//     :code:
//     <#code#>
//     :endcode:
//
//     :param: <#param name#> <#param description#>
//     
//     :return: <#return description#>
//     */
//    public func pauseAllListeners() {
//        for listener in self.listeners {
//            listener.paused = true
//        }
//    }
//    
//    /**
//     <#Brief description#>
//     
//     <#Description#>
//     
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//     
//     :code:
//     <#code#>
//     :endcode:
//     
//     :param: <#param name#> <#param description#>
//     
//     :return: <#return description#>
//     */
//    public func addListener(listener: Listener) -> Bool {
//        var existingListener = self.listenerWithName(listener.name)
//        
//        if existingListener != nil {
//            return false
//        }
//        
//        self.listeners.append(listener)
//        
//        return true
//    }
//    
//    /**
//     <#Brief description#>
//     
//     <#Description#>
//     
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//     
//     :code:
//     <#code#>
//     :endcode:
//     
//     :param: <#param name#> <#param description#>
//     
//     :return: <#return description#>
//     */
//    public func listenerWithName(name: String) -> Listener? {
//        var filtered = self.listeners.filter { (item: Listener) -> Bool in
//            return item.name == name
//        }
//        
//        return filtered.first
//    }
//    
//    /**
//     <#Brief description#>
//     
//     <#Description#>
//     
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//     
//     :code:
//     <#code#>
//     :endcode:
//     
//     :param: <#param name#> <#param description#>
//     
//     :return: <#return description#>
//     */
//    public func removeWithName(name: String) {
//        for var i = 0; i < self.listeners.count; i++ {
//            if self.listeners[i].name == name {
//                self.removeAtIndex(i)
//            }
//        }
//    }
//    
//    /**
//     <#Brief description#>
//     
//     <#Description#>
//     
//     :note <#note#>
//     :warning <#warning#>
//     :see <#see also#>
//     
//     :code:
//     <#code#>
//     :endcode:
//     
//     :param: <#param name#> <#param description#>
//     
//     :return: <#return description#>
//     */
//    public func removeAtIndex(index: Int) {
//        if index < 0 || index >= self.listeners.count {
//            return
//        }
//        
//        self.listeners.removeAtIndex(index)
//    }
//    
//    deinit {
//        self.removeAll()
//    }
//}