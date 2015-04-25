//
//  NViewController.m
//  NEvent
//
//  Created by Naithar on 04/18/2015.
//  Copyright (c) 2014 Naithar. All rights reserved.
//

#import "NViewController.h"
#import <NEvent/NHEvent.h>

@interface NViewController ()

@end

@implementation NViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.


    [[NHEvent eventWithName:nil block:^(NHEvent *event, NSDictionary *data) {
        NSLog(@"%@", data);
    }] callWithData:@{ @"name" : @"event listener"}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
