//
//  Gameplay.m
//  emilymalison
//
//  Created by Emily Malison on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Grid.h"

@implementation Gameplay{
    Grid *_grid;
    int timeRemaining;
    CCLabelTTF *_timer;
    NSTimer *myTimer;

}

#pragma mark - Timer

-(void)onEnter{
    [super onEnter];
    
    myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(second) userInfo:nil repeats:YES];
    timeRemaining=60;
}

#pragma mark - Score

-(void)second{
    timeRemaining-=1;
    _timer.string= [NSString stringWithFormat:@"%d", timeRemaining];
    if (timeRemaining==0) {
        [myTimer invalidate];
        myTimer=nil;
        [self timerExpired];
    }
    
}

-(void)timerExpired{
    
}

@end
