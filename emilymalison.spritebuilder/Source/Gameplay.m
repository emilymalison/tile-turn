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
//#import <Crashlytics/Crashlytics.h>
#import "OALSimpleAudio.h"

@implementation Gameplay{
    Grid *_grid;
    float timeRemaining;
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
    CCButton *retryButton;
    CCButton *menuButton;
    CCNode *retry;
    CCNode *play;
    CCNode *home;
    CCButton *soundButton;
    CCLabelTTF *comboText;
}

#pragma mark - Timer
-(void)onEnter{
    [super onEnter];
    _gameOver.visible=NO;
    
    _physicsNode.collisionDelegate = self;
    
    myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(second) userInfo:nil repeats:YES];
    timeRemaining=60;
    
    [self schedule:@selector(updateScore) interval:0.5f];
    self.shuffling=NO;
    
    NSURL *timerSoundURL=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"zap2-3" ofType:@"mp3"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)timerSoundURL, &timerSound);
    //[[OALSimpleAudio sharedInstance] preloadEffect:@"zap2.mp3"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.sound=[[defaults objectForKey:@"sound"] boolValue];
    [defaults synchronize];
}




-(void)second{
    timeRemaining-=1;
    int newTimeRemaining=round(timeRemaining);
    _timer.string= [NSString stringWithFormat:@"%d", newTimeRemaining];
    if (timeRemaining==10) {
        [_timer.animationManager runAnimationsForSequenceNamed:@"Animation"];
        if (self.sound==YES) {
            AudioServicesPlaySystemSound(timerSound);
            //OALSimpleAudio *audio=[OALSimpleAudio sharedInstance];
            //audio.effectsVolume=1.0;
            //[[OALSimpleAudio sharedInstance] playEffect:@"zap2.mp3"];
        }
    }
    else if (timeRemaining<10 && timeRemaining>0){
        if (self.sound==YES) {
            AudioServicesPlaySystemSound(timerSound);
        }
    }
    else if (timeRemaining==0) {
        [_timer.animationManager runAnimationsForSequenceNamed:@"Default Timeline"];
        [myTimer invalidate];
        myTimer=nil;
        [self timerExpired];
    }
}

-(void)timerExpired{
    _grid.timerExpired=YES;
    [_grid disableUserInteraction];
}
-(void)gameOver{
    NSNumber* score = [NSNumber numberWithInt:_grid.totalScore];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: score, @"score", nil];
    [MGWU logEvent:@"game_finished" withParams:params];
    
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
    self.shuffling=YES;
    shufflingScreen.visible=YES;
    shufflingText.visible=YES;
}

-(void)shufflingDone{
    shufflingScreen.visible=NO;
    shufflingText.visible=NO;
    [_grid enableUserInteraction];
    [_grid checkForMoves];
    self.shuffling=NO;
}

#pragma mark - Combo
-(void)combo{
    comboText.visible=YES;
    [comboText.animationManager runAnimationsForSequenceNamed:@"Animation2"];
    [self scheduleBlock:^(CCTimer *timer) {
        comboText.visible=NO;
        [comboText.animationManager runAnimationsForSequenceNamed:@"Default Timeline"];
    } delay:1.5];
}

#pragma mark - Pause Screen
-(void)pause{
    _grid.pause=YES;
    self.paused=YES;
    pauseScreen.visible=YES;
    pauseText.visible=YES;
    continuePlayButton.visible=YES;
    retryButton.visible=YES;
    menuButton.visible=YES;
    retry.visible=YES;
    play.visible=YES;
    home.visible=YES;
    [myTimer invalidate];
    [_grid disableUserInteraction];
    if (timeRemaining<=10) {
        [_timer.animationManager runAnimationsForSequenceNamed:@"Default Timeline"];
    }
}

-(void)continuePlay{
    _grid.pause=NO;
    self.paused=NO;
    if (timeRemaining<=10) {
        [_timer.animationManager runAnimationsForSequenceNamed:@"Animation"];
    }
    pauseScreen.visible=NO;
    pauseText.visible=NO;
    menuButton.visible=NO;
    retryButton.visible=NO;
    retry.visible=NO;
    play.visible=NO;
    home.visible=NO;
    continuePlayButton.visible=NO;
    myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(second) userInfo:nil repeats:YES];
    [_grid checkForMoves];
    [_grid enableUserInteraction];
}

-(void)loadMenu{
    CCScene *mainScene=[CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

-(void)retry{
    CCScene *gameplay=[CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplay];
}

@end