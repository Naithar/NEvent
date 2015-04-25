//
//  NHEventListener.m
//  Pods
//
//  Created by Naithar on 25.04.15.
//
//

#import "NHEventListener.h"

NSString *const kNHListenerUserEvent = @"kNHListenerUserEventAttribute";

@interface NHEventListener ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSMutableDictionary *innerEvents;
@property (nonatomic, strong) NHEventQueue *eventQueue;

@end

@implementation NHEventListener

- (instancetype)init {
    return [self initWithName:@""];
}

- (instancetype)initWithName:(NSString*)name {
    return [self initWithName:name
           inheritSharedQueue:NO];
}

- (instancetype)initWithName:(NSString*)name
          inheritSharedQueue:(BOOL)inherit {
    return [self initWithName:name
           inheritSharedQueue:inherit
             additionalQueues:nil];
}

- (instancetype)initWithName:(NSString*)name
          inheritSharedQueue:(BOOL)inherit
            additionalQueues:(NSArray*)eventQueues {
    self = [super init];

    if (self) {
        _name = name;
        _innerEvents = [@{} mutableCopy];
        _eventQueue = [[NHEventQueue alloc] init];
        _paused = NO;
        _enabled = YES;

        if (inherit) {
            [_eventQueue addEvents:[NHEventQueue sharedQueue].events];
        }

        if (eventQueues) {
            [eventQueues enumerateObjectsUsingBlock:^(NHEventQueue *obj,
                                                      NSUInteger idx,
                                                      BOOL *stop) {
                [_eventQueue addEvents:obj.events];
            }];
        }
    }

    return self;
}

- (void)addEvent:(NSString*)name
      withAction:(NHEventBlock)block {

    if ([[self.innerEvents allKeys] containsObject:name]) {
        return;
    }

    __weak __typeof(self) weakSelf = self;
    id observer = [[NSNotificationCenter defaultCenter]
                   addObserverForName:name
                   object:nil
                   queue:[NSOperationQueue mainQueue]
                   usingBlock:^(NSNotification *note) {
                       __strong __typeof(weakSelf) strongSelf = weakSelf;

                       if (!strongSelf.enabled) {
                           return;
                       }

                       NSDictionary *data = note.userInfo;

                       if (strongSelf.paused) {
                           NSNumber* calledByUser = data[kNHListenerUserEvent];

                           if (calledByUser
                               && ![calledByUser isEqual:[NSNull null]]
                               && [calledByUser boolValue]) {
                               [strongSelf.eventQueue addEvent:name
                                                      withData:data];
                           }
                       }
                       else {
                           [strongSelf performEvent:name
                                           withData:data];
                       }
                   }];

    self.innerEvents[name] = @{
                               @"observer" : observer ?: [NSNull null],
                               @"event" : [NHEvent eventWithName:name
                                                           block:block]
                               };

    if ([self.eventQueue containsEvent:name]
        && !self.paused
        && self.enabled) {
        [self performEvent:name
                  withData:[self.eventQueue eventDataForEvent:name]];
    }
}

- (void)performEvent:(NSString*)name
            withData:(NSDictionary*)data {
    if (!self.enabled) {
        return;
    }

    NHEvent *event = self.innerEvents[name][@"event"];

    if (event
        && ![event isEqual:[NSNull null]]) {
        [self.eventQueue removeEvent:name];
        NSMutableDictionary *eventData = ([data isEqual:[NSNull null]]
                                          ? nil
                                          : [data mutableCopy]);

        [eventData removeObjectForKey:kNHListenerUserEvent];

        [event performWithData:eventData];
    }
}

- (void)removeEvent:(NSString*)name {
    id observer = self.innerEvents[name][@"observer"];

    if (observer
        && ![observer isEqual:[NSNull null]]) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }

    [self.innerEvents removeObjectForKey:name];
}

- (void)removeAllEvents {
    [[self.innerEvents allKeys] enumerateObjectsUsingBlock:^(NSString* obj,
                                                             NSUInteger idx,
                                                             BOOL *stop) {
        [self removeEvent:obj];
    }];
}

- (NSDictionary *)events {
    return self.innerEvents;
}

+ (void)performEvent:(NSString*)name {
    [self performEvent:name
              withData:nil];
}
+ (void)performEvent:(NSString*)name
            withData:(NSDictionary*)data {
    [self performEvent:name
              withData:data
            addToQueue:NO];
}

+ (void)performEvent:(NSString*)name
            withData:(NSDictionary*)data
          addToQueue:(BOOL)addToQueue {

    NSMutableDictionary *eventData = [(data ?: @{}) mutableCopy];
    [eventData addEntriesFromDictionary:@{ kNHListenerUserEvent : @YES }];

    if (addToQueue) {
        [[NHEventQueue sharedQueue] addEvent:name
                                    withData:eventData];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:nil
                                                      userInfo:eventData];
}

- (void)setPaused:(BOOL)paused {
    [self willChangeValueForKey:@"paused"];
    _paused = paused;

    if (!_paused) {
        [[self.eventQueue events] enumerateKeysAndObjectsUsingBlock:^(NSString *key,
                                                                      NSDictionary *obj,
                                                                      BOOL *stop) {
            [self performEvent:key
                      withData:obj];
        }];
    }
    [self didChangeValueForKey:@"paused"];
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"dealloc event listener");
#endif

    [self removeAllEvents];
    [self.eventQueue clear];
}
@end