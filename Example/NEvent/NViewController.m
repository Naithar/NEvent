//
//  NViewController.m
//  NEvent
//
//  Created by Naithar on 04/18/2015.
//  Copyright (c) 2014 Naithar. All rights reserved.
//

#import "NViewController.h"
#import <NEvent/NHEvent.h>
#import <NEvent/NHEventListener.h>

@interface NViewController ()

@end

@implementation NViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.


    [[NHEvent eventWithName:nil block:^(NHEvent *event,
                                        NSDictionary *data) {
        NSLog(@"%@", data);
    }] performWithData:@{
                         @"name" : @"event listener"
                         }];

    [[NHEventQueue sharedQueue] addEvent:@"event" withData:nil];

    NHEventListener *listener = [[NHEventListener alloc] initWithName:nil inheritSharedQueue:YES];
    listener.paused = YES;
    [listener addEvent:@"event" withAction:^(NHEvent *event,
                                             NSDictionary *data) {
        NSLog(@"called event %@", data);
    }];

    [listener performEvent:@"event"
                  withData:nil];

    [NHEventListener performEvent:@"event"
                         withData:nil];

    listener.paused = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
