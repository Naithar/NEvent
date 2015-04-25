//
//  NEvent.m
//  Pods
//
//  Created by Naithar on 23.04.15.
//
//

#import "NHEvent.h"

@interface NHEvent ()

@property (nonatomic, copy) NHEventBlock actionBlock;

@end

@implementation NHEvent

- (instancetype)initWithBlock:(NHEventBlock)block {
    return [self initWithName:@"" andBlock:block];
}

- (instancetype)initWithName:(NSString*)name
                    andBlock:(NHEventBlock)block {
    self = [super init];
    if (self) {
        _name = name ?: @"";
        _actionBlock = block;
    }

    return self;
}

- (void)performWithData:(NSDictionary*)data {
    __weak __typeof(self) weakSelf = self;
    if (weakSelf.actionBlock) {
        weakSelf.actionBlock(weakSelf, data);
    }
}

+ (instancetype)eventWithName:(NSString*)name
                        block:(NHEventBlock)block {
    return [[NHEvent alloc]
            initWithName:name
            andBlock:block];
}

- (void)dealloc {
    self.actionBlock = nil;
}

@end

//eventqueue (add-remove queue)

//listener (add-remove event, add-remove observer for event, notifications, pause, enabled)
//(call events by name)

// observer?


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
//}
//
