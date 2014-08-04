//
//  Gameplay.m
//  emilymalison
//
//  Created by Emily Malison on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Grid.h"
#import "GameOver.h"

@implementation Gameplay{
    Grid *_grid;
    int timeRemaining;
    CCLabelTTF *_timer;
    NSTimer *myTimer;
    CCLabelTTF *_score;
    int gameplayScore;
    CCPhysicsNode *_physicsNode;
    GameOver *_gameOver;
}

#pragma mark - Timer

-(void)onEnter{
    [super onEnter];
    
    _gameOver.visible=NO;
    
    _physicsNode.collisionDelegate = self;
    
    myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(second) userInfo:nil repeats:YES];
    timeRemaining=60;
    
    [self schedule:@selector(updateScore) interval:0.5f];
}


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
    _gameOver.visible=YES;
}

 #pragma mark - Score

-(void)updateScore{
    _score.string=[NSString stringWithFormat:@"%i", _grid.totalScore];
}



- (BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair tile:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    if (nodeB.physicsBody.affectedByGravity == NO && nodeA.physicsBody.affectedByGravity) {
        nodeA.physicsBody.affectedByGravity = NO;
        nodeA.physicsBody.velocity = ccp(0,0);
    }
    return YES;
    //[_grid checkTile:nodeA];
}

@end