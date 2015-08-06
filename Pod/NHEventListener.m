//
//  NHEventListener.m
//  Pods
//
//  Created by Naithar on 25.04.15.
//
//

#import "NHEventListener.h"

#define isNSNull(x) \
([x isKindOfClass:[NSNull class]])

#define ifNSNull(x, y) \
([x isKindOfClass:[NSNull class]]) ? y : (x ?: y)

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

+ (instancetype)listener {
    return [[NHEventListener alloc] init];
}

- (void)addEvent:(NSString*)name
      withAction:(NHEventBlock)block {
    [self addEvent:name
         forObject:nil
        withAction:block];
}

- (void)addEvent:(NSString*)name
       forObject:(id)object
      withAction:(NHEventBlock)block {

    id key = EventKeyForObject(object);

    if (self.innerEvents[key]
        && [self.innerEvents[key] isKindOfClass:[NSMutableDictionary class]]
        && [[self.innerEvents[key] allKeys] containsObject:name]) {
        return;
    }

    //    if ([[self.innerEvents allKeys] containsObject:name]) {
    //        return;
    //    }

    __weak __typeof(self) weakSelf = self;
    id observer = [[NSNotificationCenter defaultCenter]
                   addObserverForName:name
                   object:object
                   queue:[NSOperationQueue mainQueue]
                   usingBlock:^(NSNotification *note) {
                       __strong __typeof(weakSelf) strongSelf = weakSelf;

                       if (!strongSelf.enabled) {
                           return;
                       }

                       NSDictionary *data = note.userInfo;

                       if (strongSelf.paused) {
                           NSNumber* calledByUser = ifNSNull(data[kNHListenerUserEvent], @NO);

                           if ([calledByUser boolValue]) {
                               [strongSelf.eventQueue addEvent:name
                                                     forObject:note.object
                                                      withData:data];
                           }
                       }
                       else {
                           [strongSelf performEvent:name
                                          forObject:note.object
                                           withData:data];
                       }
                   }];

    if (!self.innerEvents[key]
        || ![self.innerEvents[key] isKindOfClass:[NSMutableDictionary class]]) {
        self.innerEvents[key] = [[NSMutableDictionary alloc] init];
    }

    self.innerEvents[key][name] = @{
                                    @"observer" : observer ?: [NSNull null],
                                    @"event" : [NHEvent eventWithName:name
                                                               object:object
                                                             andBlock:block]
                                    };

    //    self.innerEvents[name] = @{
    //                               @"observer" : observer ?: [NSNull null],
    //                               @"event" : [NHEvent eventWithName:name
    //                                                          object:object
    //                                                        andBlock:block]
    //                               };

    if ([self.eventQueue containsEvent:name forObject:object]
        && !self.paused
        && self.enabled) {
        [self performEvent:name
                 forObject:object
                  withData:[self.eventQueue
                            eventDataForEvent:name
                            andObject:object]];
    }
}

- (void)performEvent:(NSString*)name {
    [self performEvent:name
              withData:nil];
}

- (void)performEvent:(NSString*)name
            withData:(NSDictionary*)data {
    [self performEvent:name
             forObject:nil
              withData:data];
}

- (void)performEvent:(NSString*)name
           forObject:(id)object
            withData:(NSDictionary*)data {
    if (!self.enabled) {
        return;
    }

    id key = EventKeyForObject(object);

    if (!self.innerEvents[key]
        || ![self.innerEvents[key] isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }

    NHEvent *event = ifNSNull(self.innerEvents[key][name][@"event"], nil);

    if (event) {
        [self.eventQueue removeEvent:name
                           forObject:object];
        NSMutableDictionary *eventData = (isNSNull(data)
                                          ? nil
                                          : [data mutableCopy]);

        [eventData removeObjectForKey:kNHListenerUserEvent];

        [event performWithData:eventData];
    }
}

- (void)removeEvent:(NSString*)name {
    [self removeEvent:name
            forObject:nil];
}

- (void)removeEvent:(NSString*)name
          forObject:(id)object {
    id key = EventKeyForObject(object);

    if (!self.innerEvents[key]
        || ![self.innerEvents[key] isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }

    id observer = ifNSNull(self.innerEvents[key][name][@"observer"], nil);

    if (observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }

    [self.innerEvents[key] removeObjectForKey:key];
}

- (void)removeAllEvents {
    [self.innerEvents enumerateKeysAndObjectsUsingBlock:^(id key,
                                                          id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSMutableDictionary class]]) {
            id object = ObjectForKey(key);

            [obj enumerateKeysAndObjectsUsingBlock:^(id innerKey, id obj, BOOL *stop) {
                [self removeEvent:innerKey forObject:object];
            }];
        }
    }];
}

- (NSDictionary *)events {
    return self.innerEvents;
}

+ (void)performEvent:(NSString*)name {
    [self performEvent:name
           asUserEvent:YES];
}

+ (void)performEvent:(NSString*)name
         asUserEvent:(BOOL)userEvent {
    [self performEvent:name
              withData:nil];
}

+ (void)performEvent:(NSString*)name
            withData:(NSDictionary*)data {
    [self performEvent:name
           asUserEvent:YES
              withData:data];
}

+ (void)performEvent:(NSString*)name
         asUserEvent:(BOOL)userEvent
            withData:(NSDictionary*)data {
    [self performEvent:name
              withData:data
            addToQueue:NO];
}

+ (void)performEvent:(NSString*)name
            withData:(NSDictionary*)data
          addToQueue:(BOOL)addToQueue {
    [self performEvent:name
           asUserEvent:YES
              withData:data
            addToQueue:addToQueue];
}
+ (void)performEvent:(NSString*)name
         asUserEvent:(BOOL)userEvent
            withData:(NSDictionary*)data
          addToQueue:(BOOL)addToQueue {
    [self performEvent:name
           asUserEvent:userEvent
             forObject:nil
              withData:data
            addToQueue:addToQueue];
}

+ (void)performEvent:(NSString*)name
           forObject:(id)object
            withData:(NSDictionary*)data
          addToQueue:(BOOL)addToQueue {
    [self performEvent:name
           asUserEvent:YES
             forObject:object
              withData:data
            addToQueue:addToQueue];
}

+ (void)performEvent:(NSString*)name
         asUserEvent:(BOOL)userEvent
           forObject:(id)object
            withData:(NSDictionary*)data
          addToQueue:(BOOL)addToQueue {
    NSMutableDictionary *eventData = [(data ?: @{}) mutableCopy];
    [eventData addEntriesFromDictionary:@{ kNHListenerUserEvent : @(userEvent) }];

    if (addToQueue) {
        [[NHEventQueue sharedQueue] addEvent:name
                                   forObject:object
                                    withData:eventData];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:object
                                                      userInfo:eventData];
}

- (void)setPaused:(BOOL)paused {
    [self willChangeValueForKey:@"paused"];
    _paused = paused;

    if (!_paused) {
        [[self.eventQueue events] enumerateKeysAndObjectsUsingBlock:^(id key,
                                                                      id obj,
                                                                      BOOL *stop) {



            if ([obj isKindOfClass:[NSMutableDictionary class]]) {
                id object = ObjectForKey(key);

                [obj enumerateKeysAndObjectsUsingBlock:^(id innerKey, id obj, BOOL *stop) {
                    [self performEvent:innerKey
                             forObject:object
                              withData:obj];
                }];
                
            }
            
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