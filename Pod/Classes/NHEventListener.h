//
//  NHEventListener.h
//  Pods
//
//  Created by Naithar on 25.04.15.
//
//

#import <Foundation/Foundation.h>
#import "NHEvent.h"
#import "NHEventQueue.h"

@interface NHEventListener : NSObject

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSDictionary *events;
@property (nonatomic, readonly, strong) NHEventQueue *eventQueue;

- (instancetype)initWithName:(NSString*)name;

- (instancetype)initWithName:(NSString*)name
          inheritSharedQueue:(BOOL)inherit;

- (instancetype)initWithName:(NSString*)name
          inheritSharedQueue:(BOOL)inherit
            additionalQueues:(NSArray*)eventQueues;

- (void)addEvent:(NSString*)name
      withAction:(NHEventBlock)block;
- (void)removeEvent:(NSString*)name;
- (void)removeAllEvents;

- (void)performEvent:(NSString*)name
            withData:(NSDictionary*)data;


+ (void)performEvent:(NSString*)name;
+ (void)performEvent:(NSString*)name
            withData:(NSDictionary*)data;
+ (void)performEvent:(NSString*)name
            withData:(NSDictionary*)data
          addToQueue:(BOOL)addToQueue;
@end
