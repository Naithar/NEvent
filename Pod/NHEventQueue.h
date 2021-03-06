//
//  NHEventQueue.h
//  Pods
//
//  Created by Naithar on 25.04.15.
//
//

#import <Foundation/Foundation.h>

#define EventKeyForObject(object) \
object ? [NSValue valueWithNonretainedObject:object] : [NSNull null]

#define ObjectForKey(key) \
[key isKindOfClass:[NSValue class]] ? [key nonretainedObjectValue] : nil

@interface NHEventQueue : NSObject

@property (nonatomic, readonly, copy) NSDictionary *events;

+ (instancetype)sharedQueue;

- (void)addEvent:(NSString*)name;
- (void)addEvent:(NSString*)name
        withData:(NSDictionary*)data;
- (void)addEvent:(NSString*)name
       forObject:(id)object
        withData:(NSDictionary*)data;

- (void)addEvents:(NSDictionary*)events;

- (BOOL)containsEvent:(NSString*)name;
- (BOOL)containsEvent:(NSString*)name
            forObject:(id)object;

- (void)removeEvent:(NSString*)name;
- (void)removeEvent:(NSString*)name
          forObject:(id)object;

- (void)removeEvents:(NSArray*)names;
- (void)removeEvents:(NSArray*)names
           forObject:(id)object;

- (void)clear;

- (NSDictionary*)eventDataForEvent:(NSString*)name;
- (NSDictionary*)eventDataForEvent:(NSString*)name
                         andObject:(id)object;
@end
