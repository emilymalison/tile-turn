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
    CCNodeColor *shufflingScreen;
    CCLabelTTF *shufflingText;
    CCNodeColor *pauseScreen;
    CCLabelTTF *pauseText;
    CCButton *continuePlayButton;
    CCButton *menuButton;
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
    GameOver *gameover = (GameOver*)[CCBReader load:@"GameOver"];
    gameover.finalScore = _grid.totalScore;
    CCScene *gameoverScene = [CCScene node];
    [gameoverScene addChild:gameover];
    [[CCDirector sharedDirector] replaceScene:gameoverScene];
}

 #pragma mark - Score

-(void)updateScore{
    _score.string=[NSString stringWithFormat:@"%i", _grid.totalScore];
}

#pragma mark - Collisions

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair tile:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    if (nodeB.physicsBody.affectedByGravity == NO && nodeA.physicsBody.affectedByGravity) {
        nodeA.physicsBody.affectedByGravity = NO;
        nodeA.physicsBody.velocity = ccp(0,0);
    }
    return YES;
}

#pragma mark - Shuffling Screen
-(void)noPossibleMatches{
    shufflingScreen.visible=YES;
    shufflingText.visible=YES;
    [_grid disableUserInteraction];
}

-(void)shufflingDone{
    shufflingScreen.visible=NO;
    shufflingText.visible=NO;
    [_grid enableUserInteraction];
}

#pragma mark - Pause Screen
-(void)pause{
    pauseScreen.visible=YES;
    pauseText.visible=YES;
    continuePlayButton.visible=YES;
    menuButton.visible=YES;
    [myTimer invalidate];
    [_grid disableUserInteraction];
}

-(void)continuePlay{
    pauseScreen.visible=NO;
    pauseText.visible=NO;
    menuButton.visible=NO;
    continuePlayButton.visible=NO;
    myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(second) userInfo:nil repeats:YES];
    [_grid enableUserInteraction];
}

-(void)loadMenu{
    CCScene *mainScene=[CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

@end