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

    if ([[self.innerEvents allKeys] containsObject:name]) {
        return;
    }

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
                                                      withData:data];
                           }
                       }
                       else {
                           [strongSelf performEvent:name
                                          forObject:note.object
                                           withData:data];
                       }
                   }];

    self.innerEvents[name] = @{
                               @"observer" : observer ?: [NSNull null],
                               @"event" : [NHEvent eventWithName:name
                                                          object:object
                                                        andBlock:block]
                               };

    if ([self.eventQueue containsEvent:name]
        && !self.paused
        && self.enabled) {
        [self performEvent:name
                  withData:[self.eventQueue eventDataForEvent:name]];
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

    NHEvent *event = ifNSNull(self.innerEvents[name][@"event"], nil);

    if (event) {
        [self.eventQueue removeEvent:name];
        NSMutableDictionary *eventData = (isNSNull(data)
                                          ? nil
                                          : [data mutableCopy]);

        [eventData removeObjectForKey:kNHListenerUserEvent];

        [event performWithData:eventData];
    }
}

- (void)removeEvent:(NSString*)name {
    id observer = ifNSNull(self.innerEvents[name][@"observer"], nil);

    if (observer) {
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
    [self performEvent:name forObject:nil withData:data addToQueue:addToQueue];
}

+ (void)performEvent:(NSString*)name
           forObject:(id)object
            withData:(NSDictionary*)data
          addToQueue:(BOOL)addToQueue {
    NSMutableDictionary *eventData = [(data ?: @{}) mutableCopy];
    [eventData addEntriesFromDictionary:@{ kNHListenerUserEvent : @YES }];

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