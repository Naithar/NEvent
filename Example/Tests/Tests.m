//
//  NEventTests.m
//  NEventTests
//
//  Created by Naithar on 04/18/2015.
//  Copyright (c) 2014 Naithar. All rights reserved.
//

#import <NHEventListener.h>

SpecBegin(InitialSpecs)

describe(@"event tests", ^{
    
    it(@"perform event without data", ^{

        __block BOOL didRun;
        NHEvent *event = [[NHEvent alloc] initWithBlock:^(NHEvent *event, NSDictionary *data) {
            didRun = YES;
        }];

        [event performWithData:nil];

        expect(didRun).to.equal(YES);
    });

    it(@"perform with data", ^{
        __block NSInteger value = 0;

        NHEvent *event = [[NHEvent alloc] initWithBlock:^(NHEvent *event, NSDictionary *data) {
            value = [data[@"value"] integerValue];
        }];

        [event performWithData:@{ @"value" : @10 }];

        expect(value).to.equal(10);
    });

});

describe(@"event listener test", ^{
    it(@"will perform stored event without data", ^{
        __block BOOL didRun = NO;

        NHEventListener *listener = [NHEventListener listener];
        [listener addEvent:@"event" withAction:^(NHEvent *event, NSDictionary *data) {
            didRun = YES;
        }];

        [listener performEvent:@"event"];

        expect(didRun).to.equal(YES);
    });

    it(@"will perform event with data", ^{
        __block NSInteger value = 0;

        NHEventListener *listener = [NHEventListener listener];
        [listener addEvent:@"event" withAction:^(NHEvent *event, NSDictionary *data) {
            value = [data[@"value"] integerValue];
        }];

        [listener performEvent:@"event" withData:@{ @"value" : @10 }];

        expect(value).to.equal(10);
    });

    it(@"will perform event with notification call with value", ^{
        __block BOOL didRun = NO;

        NHEventListener *listener = [NHEventListener listener];
        [listener addEvent:@"event" withAction:^(NHEvent *event, NSDictionary *data) {
            didRun = YES;
        }];

        [NHEventListener performEvent:@"event"];

        expect(didRun).to.equal(YES);
    });

    it(@"will perform event with notification call with value", ^{
        __block NSInteger value = 0;

        NHEventListener *listener = [NHEventListener listener];
        [listener addEvent:@"event" withAction:^(NHEvent *event, NSDictionary *data) {
            value = [data[@"value"] integerValue];
        }];

        [NHEventListener performEvent:@"event" withData:@{ @"value" : @10 }];

        expect(value).to.equal(10);
    });

    it(@"will perform event from queue", ^{
        __block NSInteger value = 0;

        [NHEventListener performEvent:@"event" withData:@{ @"value" : @10 } addToQueue:YES];

        NHEventListener *listener = [[NHEventListener alloc] initWithName:@"listener" inheritSharedQueue:YES];

        expect(listener.name).to.equal(@"listener");

        [listener addEvent:@"event" withAction:^(NHEvent *event, NSDictionary *data) {
            value = [data[@"value"] integerValue];
        }];

        expect(value).to.equal(10);
    });

    it(@"will perform after unpaused", ^{
        __block NSInteger value = 0;

        [NHEventListener performEvent:@"event" withData:@{ @"value" : @10 } addToQueue:YES];

        NHEventListener *listener = [[NHEventListener alloc] initWithName:@"listener" inheritSharedQueue:YES];
        listener.paused = YES;

        [listener addEvent:@"event" withAction:^(NHEvent *event, NSDictionary *data) {
            value = [data[@"value"] integerValue];
        }];

        listener.paused = NO;

        expect(value).to.equal(10);
    });

    it(@"will perform last notification event when unpaused", ^{
        __block NSInteger value = 0;

        [NHEventListener performEvent:@"event" withData:@{ @"value" : @10 } addToQueue:YES];

        NHEventListener *listener = [[NHEventListener alloc] initWithName:@"listener" inheritSharedQueue:YES];
        listener.paused = YES;

        [listener addEvent:@"event" withAction:^(NHEvent *event, NSDictionary *data) {
            value += [data[@"value"] integerValue];
        }];

        [NHEventListener performEvent:@"event" withData:@{ @"value" : @10 }];
        [NHEventListener performEvent:@"event" withData:@{ @"value" : @10 }];
        [NHEventListener performEvent:@"event" withData:@{ @"value" : @10 }];

        listener.paused = NO;

        expect(value).to.equal(10);
    });

    it(@"will perform direct call when paused", ^{
        __block NSInteger value = 0;

        [NHEventListener performEvent:@"event" withData:@{ @"value" : @10 } addToQueue:YES];

        NHEventListener *listener = [[NHEventListener alloc] initWithName:@"listener" inheritSharedQueue:YES];

        listener.paused = YES;

        [listener addEvent:@"event" withAction:^(NHEvent *event, NSDictionary *data) {
            value += [data[@"value"] integerValue];
        }];

        [listener performEvent:@"event" withData:@{ @"value" : @15 }];

        expect(value).to.equal(15);
    });

    it(@"will not perform if disabled", ^{
        __block NSInteger value = 0;

        [NHEventListener performEvent:@"event" withData:@{ @"value" : @10 } addToQueue:YES];

        NHEventListener *listener = [[NHEventListener alloc] initWithName:@"listener" inheritSharedQueue:YES];
        listener.enabled = NO;

        [listener addEvent:@"event" withAction:^(NHEvent *event, NSDictionary *data) {
            value += [data[@"value"] integerValue];
        }];

        [listener performEvent:@"event" withData:@{ @"value" : @15 }];
        [NHEventListener performEvent:@"event" withData:@{ @"value" : @10 }];

        expect(value).to.equal(0);
    });

    it(@"will not rewrite existing event", ^{
        __block NSInteger value = 0;

        [NHEventListener performEvent:@"event" withData:@{ @"value" : @10 } addToQueue:YES];

        NHEventListener *listener = [[NHEventListener alloc] initWithName:@"listener" inheritSharedQueue:YES];
        [listener addEvent:@"event" withAction:^(NHEvent *event, NSDictionary *data) {
            value = [data[@"value"] integerValue] * 5;
        }];

        [listener addEvent:@"event" withAction:^(NHEvent *event, NSDictionary *data) {
            value = [data[@"value"] integerValue] + 5;
        }];

        expect([[listener.events allKeys] count]).to.equal(1);

        [NHEventListener performEvent:@"event" withData:@{ @"value" : @10 }];

        expect(value).to.equal(50);
    });

    it(@"will inherit queues from array", ^{
        __block BOOL didRun = NO;
        [[NHEventQueue sharedQueue] addEvent:@"event"];

        NHEventListener *listener = [[NHEventListener alloc] initWithName:@"listener" inheritSharedQueue:NO additionalQueues:@[[NHEventQueue sharedQueue]]];
        [listener addEvent:@"event" withAction:^(NHEvent *event, NSDictionary *data) {
            didRun = YES;
        }];

        expect(didRun).to.equal(YES);
    });
});

SpecEnd
