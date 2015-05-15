//
//  NEvent.m
//  Pods
//
//  Created by Naithar on 23.04.15.
//
//

#import "NHEvent.h"

@interface NHEvent ()

@property (nonatomic, weak) id object;
@property (nonatomic, copy) NHEventBlock actionBlock;

@end

@implementation NHEvent

- (instancetype)initWithBlock:(NHEventBlock)block {
    return [self initWithName:@"" andBlock:block];
}

- (instancetype)initWithName:(NSString*)name
                    andBlock:(NHEventBlock)block {
    return [self initWithName:name object:nil andBlock:block];
}

- (instancetype)initWithName:(NSString*)name
                      object:(id)object
                    andBlock:(NHEventBlock)block {
    self = [super init];
    if (self) {
        _name = name ?: @"";
        _object = object;
        _actionBlock = block;
    }

    return self;
}

- (void)performWithData:(NSDictionary*)data {
    __weak __typeof(self) weakSelf = self;
    if (weakSelf.actionBlock) {
        weakSelf.actionBlock(weakSelf, data.allKeys.count == 0 ? nil : data);
    }
}

+ (instancetype)eventWithName:(NSString*)name
                       object:(id)object
                        andBlock:(NHEventBlock)block {
    return [[NHEvent alloc]
            initWithName:name
            object:object
            andBlock:block];
}

+ (instancetype)eventWithName:(NSString*)name
                        andBlock:(NHEventBlock)block {
    return [[NHEvent alloc]
            initWithName:name
            andBlock:block];
}

+ (instancetype)eventWithBlock:(NHEventBlock)block {
    return [[NHEvent alloc]
            initWithBlock:block];
}

- (void)dealloc {
    self.actionBlock = nil;
}

@end