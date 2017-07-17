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
    Grid *_grid; //object that contains tiles and dots
    CCPhysicsNode *_physicsNode; //enables physics effects from SpriteBuilder
    
    int timeRemaining; //stores number of seconds left on timer
    CCLabelTTF *_timer; //label that displays timer
    NSTimer *myTimer; //timer
    
    CCLabelTTF *_score; //label that displays score
    int gameplayScore; //stores the score
    
    GameOver *_gameOver; //game over screen (becomes visible when timer is up)
    
    CCNodeColor *shufflingScreen; //screen that appears when tiles are rearranging
    CCLabelTTF *shufflingText; //text that appears when tiles are rearranging
    
    CCNodeColor *pauseScreen; //screen that appears when paused
    CCLabelTTF *pauseText; //text that appears when paused
    CCButton *continuePlayButton; //button on pause screen to resume play
    CCNode *play;
    CCButton *retryButton; //button on pause screen to start new game
    CCNode *retry;
    CCButton *menuButton; //button on pause screen to return to menu
    CCNode *home;
    
    CCButton *soundButton; //sound button
    CCLabelTTF *comboText; //displays when user makes two matches at once
}

#pragma mark - Timer
-(void)onEnter{ //when a new game starts
    [super onEnter];
    _gameOver.visible=NO; //make gameover screen disappear
    
    _physicsNode.collisionDelegate = self; //enable collision detection
    
    myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(second) userInfo:nil repeats:YES];
    timeRemaining=60; //set timer
    
    [self schedule:@selector(updateScore) interval:0.5f]; //updated the score display every half second
    self.shuffling=NO;
    
    //Importing and defining sounds
    NSURL *timerSoundURL=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"zap2" ofType:@"mp3"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)timerSoundURL, &timerSound);
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.sound=[[defaults objectForKey:@"sound"] boolValue];
    [defaults synchronize];
}




-(void)second{ //called every second that passes, updates the timer, and plays a sound and animation for last 10 seconds
    timeRemaining-=1;
    _timer.string= [NSString stringWithFormat:@"%i", timeRemaining];
    if (timeRemaining==10) { //if there are 10 seconds left, start the timer animation
        [_timer.animationManager runAnimationsForSequenceNamed:@"Animation"];
        if (self.sound==YES) {
            OALSimpleAudio *audio=[OALSimpleAudio sharedInstance];
            [audio playEffect:@"zap2.mp3"];
        }
    }
    else if (timeRemaining<10 && timeRemaining>0){ //play the countdown sound if there are less than 10 seconds left
        if (self.sound==YES) {
            OALSimpleAudio *audio=[OALSimpleAudio sharedInstance];
            [audio playEffect:@"zap2.mp3"];
        }
    }
    else if (timeRemaining==0) { //if there's no time left, end the timer
        [_timer.animationManager runAnimationsForSequenceNamed:@"Default Timeline"];
        [myTimer invalidate];
        myTimer=nil;
        [self timerExpired];
    }
}

-(void)timerExpired{ //disables user interaction
    _grid.timerExpired=YES;
    [_grid disableUserInteraction];
}

-(void)gameOver{ //loads gameOver screen when game is over (timer is up)
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

-(void)updateScore{ //updated the score label to reflect the actual score, called every half second
    _score.string=[NSString stringWithFormat:@"%i", _grid.totalScore];
}

#pragma mark - Collisions

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair tile:(CCNode *)nodeA wildcard:(CCNode *)nodeB { //when the falling tile hits a physics object (either another tile or the ground) that is not falling, it stops falling
    if (nodeB.physicsBody.affectedByGravity == NO && nodeA.physicsBody.affectedByGravity) {
        nodeA.physicsBody.affectedByGravity = NO;
        nodeA.physicsBody.velocity = ccp(0,0);
    }
    return YES;
}

#pragma mark - Shuffling Screen
-(void)noPossibleMatches{ //when there are no possible matches (determined in Grid class) then display shuffling screen (actual shuffling is done in Grid class)
    self.shuffling=YES;
    shufflingScreen.visible=YES;
    shufflingText.visible=YES;
}

-(void)shufflingDone{ //when shuffling is done (determined in Grid class), gets rid of shuffling screen
    shufflingScreen.visible=NO;
    shufflingText.visible=NO;
    [_grid enableUserInteraction];
    [_grid checkForMoves];
    self.shuffling=NO;
}

#pragma mark - Combo
-(void)combo{ //if user makes two matches at once, displays an animation
    comboText.visible=YES;
    [comboText.animationManager runAnimationsForSequenceNamed:@"Animation2"];
    [self scheduleBlock:^(CCTimer *timer) {
        comboText.visible=NO;
        [comboText.animationManager runAnimationsForSequenceNamed:@"Default Timeline"];
    } delay:1.5];
}

#pragma mark - Pause Screen
-(void)pause{ //displays pause screen when paused
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

-(void)continuePlay{ //when user continues play from pause screen, returns to game
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

-(void)loadMenu{ //switches to main menu when user presses menu button on pause screen
    CCScene *mainScene=[CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

-(void)retry{ //starts a new game when user presses retry button on pause screen
    CCScene *gameplay=[CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplay];
}

@end
