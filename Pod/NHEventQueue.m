//
//  NHEventQueue.m
//  Pods
//
//  Created by Naithar on 25.04.15.
//
//

#import "NHEventQueue.h"

@interface NHEventQueue ()

@property (nonatomic, copy) NSMutableDictionary *innerEvents;

@end


@implementation NHEventQueue

+ (instancetype)sharedQueue {
    static dispatch_once_t token;
    __strong static id instance = nil;
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _innerEvents = [@{} mutableCopy];
    }
    return self;
}

- (void)addEvent:(NSString*)name {
    [self addEvent:name withData:nil];
}

- (void)addEvent:(NSString*)name
        withData:(NSDictionary*)data {
    [self addEvent:name
         forObject:nil
          withData:data];
}

- (void)addEvent:(NSString*)name
       forObject:(id)object
        withData:(NSDictionary*)data {
//    self.innerEvents[name] = data ?: [NSNull null];

    id key = EventKeyForObject(object);

    if (!self.innerEvents[key]
        || ![self.innerEvents[key] isKindOfClass:[NSMutableDictionary class]]) {
        self.innerEvents[key] = [[NSMutableDictionary alloc] init];
    }

    self.innerEvents[key][name] = data ?: [NSNull null];
}

- (void)addEvents:(NSDictionary*)events {
    [events enumerateKeysAndObjectsUsingBlock:^(id key,
                                                NSDictionary* obj,
                                                BOOL *stop) {
        self.innerEvents[key] = [obj mutableCopy];
    }];
}

- (void)removeEvent:(NSString*)name {
    [self removeEvent:name forObject:nil];
}

- (void)removeEvent:(NSString*)name
          forObject:(id)object {
//    [self.innerEvents removeObjectForKey:name];

    id key = EventKeyForObject(object);

    if (self.innerEvents[key]
        && [self.innerEvents[key] isKindOfClass:[NSMutableDictionary class]]) {
        [self.innerEvents[key] removeObjectForKey:name];
    }
}

- (void)removeEvents:(NSArray*)names {
    [self removeEvents:names forObject:nil];
}

- (void)removeEvents:(NSArray*)names
           forObject:(id)object {
    [names enumerateObjectsUsingBlock:^(NSString *obj,
                                        NSUInteger idx,
                                        BOOL *stop) {
        [self removeEvent:obj
                forObject:object];
    }];
}

- (BOOL)containsEvent:(NSString*)name {
    return [self containsEvent:name
                     forObject:nil];
}

- (BOOL)containsEvent:(NSString*)name
            forObject:(id)object {

    id key = EventKeyForObject(object);

    if (self.innerEvents[key]
        && [self.innerEvents[key] isKindOfClass:[NSMutableDictionary class]]) {
        return [[self.innerEvents[key] allKeys] containsObject:name];
    }

    return NO;
//    return [[self.innerEvents allKeys] containsObject:name];
}

- (NSDictionary*)eventDataForEvent:(NSString*)name {
    return [self eventDataForEvent:name
                         andObject:nil];
}

- (NSDictionary*)eventDataForEvent:(NSString*)name
                         andObject:(id)object {

    id key = EventKeyForObject(object);

    if (self.innerEvents[key]
        && [self.innerEvents[key] isKindOfClass:[NSMutableDictionary class]]) {
        return self.innerEvents[key][name];
    }

    return nil;
}

- (void)clear {
    [self.innerEvents removeAllObjects];
}

- (NSDictionary *)events {
    return self.innerEvents;
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"dealloc event queue");
#endif
    [self clear];
}
@end
