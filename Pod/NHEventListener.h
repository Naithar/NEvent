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

extern NSString *const kNHListenerUserEvent;

@interface NHEventListener : NSObject

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSDictionary *events;
@property (nonatomic, readonly, strong) NHEventQueue *eventQueue;

@property (nonatomic, assign) BOOL paused;
@property (nonatomic, assign) BOOL enabled;

- (instancetype)initWithName:(NSString*)name;

- (instancetype)initWithName:(NSString*)name
          inheritSharedQueue:(BOOL)inherit;

- (instancetype)initWithName:(NSString*)name
          inheritSharedQueue:(BOOL)inherit
            additionalQueues:(NSArray*)eventQueues;

+ (instancetype)listener;

- (void)addEvent:(NSString*)name
      withAction:(NHEventBlock)block;
- (void)addEvent:(NSString*)name
       forObject:(id)object
      withAction:(NHEventBlock)block;

- (void)removeEvent:(NSString*)name;
- (void)removeEvent:(NSString*)name
          forObject:(id)object;

- (void)removeAllEvents;

- (void)performEvent:(NSString*)name;
- (void)performEvent:(NSString*)name
            withData:(NSDictionary*)data;
- (void)performEvent:(NSString*)name
           forObject:(id)object
            withData:(NSDictionary*)data;


+ (void)performEvent:(NSString*)name;
+ (void)performEvent:(NSString*)name
         asUserEvent:(BOOL)userEvent;
+ (void)performEvent:(NSString*)name
            withData:(NSDictionary*)data;
+ (void)performEvent:(NSString*)name
         asUserEvent:(BOOL)userEvent
            withData:(NSDictionary*)data;
+ (void)performEvent:(NSString*)name
            withData:(NSDictionary*)data
          addToQueue:(BOOL)addToQueue;
+ (void)performEvent:(NSString*)name
         asUserEvent:(BOOL)userEvent
            withData:(NSDictionary*)data
          addToQueue:(BOOL)addToQueue;
+ (void)performEvent:(NSString*)name
           forObject:(id)object
            withData:(NSDictionary*)data
          addToQueue:(BOOL)addToQueue;
+ (void)performEvent:(NSString*)name
         asUserEvent:(BOOL)userEvent
           forObject:(id)object
            withData:(NSDictionary*)data
          addToQueue:(BOOL)addToQueue;
@end
