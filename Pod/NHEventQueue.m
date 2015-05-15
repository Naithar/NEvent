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
    self.innerEvents[name] = data ?: [NSNull null];
}

- (void)addEvents:(NSDictionary*)events {
    [events enumerateKeysAndObjectsUsingBlock:^(NSString* key,
                                                NSDictionary* obj,
                                                BOOL *stop) {
        self.innerEvents[key] = obj;
    }];
}

- (void)removeEvent:(NSString*)name {
    [self.innerEvents removeObjectForKey:name];
}

- (void)removeEvents:(NSArray*)names {
    [names enumerateObjectsUsingBlock:^(NSString *obj,
                                        NSUInteger idx,
                                        BOOL *stop) {
        [self.innerEvents removeObjectForKey:obj];
    }];
}

- (BOOL)containsEvent:(NSString*)name {
    return [self containsEvent:name
                     forObject:nil];
}

- (BOOL)containsEvent:(NSString*)name
            forObject:(id)object {
    return [[self.innerEvents allKeys] containsObject:name];
}

- (NSDictionary*)eventDataForEvent:(NSString*)name {
    return self.innerEvents[name];
}

- (void)clear {
    [self.innerEvents removeAllObjects];
}

- (NSDictionary *)events {
    return self.innerEvents;
}

@end
