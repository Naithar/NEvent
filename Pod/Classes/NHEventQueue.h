//
//  NHEventQueue.h
//  Pods
//
//  Created by Naithar on 25.04.15.
//
//

#import <Foundation/Foundation.h>

@interface NHEventQueue : NSObject

@property (nonatomic, readonly, copy) NSDictionary *events;

+ (instancetype)sharedQueue;

- (void)addEvent:(NSString*)name
        withData:(NSDictionary*)data;
- (void)addEvents:(NSDictionary*)events;

- (void)removeEvent:(NSString*)name;
- (void)removeEvents:(NSArray*)names;
- (void)clear;
@end
