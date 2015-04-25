//
//  NEvent.h
//  Pods
//
//  Created by Naithar on 23.04.15.
//
//

#import <Foundation/Foundation.h>

@class NHEvent;

typedef void(^NHEventBlock)(NHEvent *event, NSDictionary *data);

@interface NHEvent : NSObject

@property (nonatomic, readonly, copy) NSString *name;

- (instancetype)initWithName:(NSString*)name
                    andBlock:(NHEventBlock)block;
- (instancetype)initWithBlock:(NHEventBlock)block;

+ (instancetype)eventWithName:(NSString*)name
                        block:(NHEventBlock)block;

- (void)callWithData:(NSDictionary*)data;
@end
