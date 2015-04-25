//
//  NHEventListener.m
//  Pods
//
//  Created by Naithar on 25.04.15.
//
//

#import "NHEventListener.h"

@implementation NHEventListener

@end

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