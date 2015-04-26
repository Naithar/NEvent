//
//  NEvent.m
//  Pods
//
//  Created by Naithar on 23.04.15.
//
//

#import "NHEvent.h"

@interface NHEvent ()

@property (nonatomic, copy) NHEventBlock actionBlock;

@end

@implementation NHEvent

- (instancetype)initWithBlock:(NHEventBlock)block {
    return [self initWithName:@"" andBlock:block];
}

- (instancetype)initWithName:(NSString*)name
                    andBlock:(NHEventBlock)block {
    self = [super init];
    if (self) {
        _name = name ?: @"";
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
                        block:(NHEventBlock)block {
    return [[NHEvent alloc]
            initWithName:name
            andBlock:block];
}

- (void)dealloc {
    self.actionBlock = nil;
}

@end