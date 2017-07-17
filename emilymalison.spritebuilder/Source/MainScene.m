//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene{
    CCButton *soundOnButton; //button displayed when sound is on
    CCButton *soundOffButton; //button displayed when sound is off
    CCPhysicsNode *_physicsNode; //enables physics on Main Screen
    CCButton *playButton; //play button
    CCSprite *playBackground; //background behind play button
}

#pragma mark - Loading Gameplay Scene
-(void)onEnter{ //enables buttons and makes them visable, also sets up sounds
    [super onEnter];
    [self scheduleBlock:^(CCTimer *timer) {
        playBackground.position=playButton.position;
        playBackground.visible=YES;
    } delay:1];
    _physicsNode.collisionDelegate=self;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"sound"]==nil) {
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"sound"];
        [defaults synchronize];
    }
    else if ([[defaults objectForKey:@"sound"] boolValue]==YES) {
        soundOnButton.visible=YES;
        soundOffButton.visible=NO;
    }
    else if ([[defaults objectForKey:@"sound"] boolValue]==NO) {
        soundOffButton.visible=YES;
        soundOnButton.visible=NO;
    }
}
-(void) startGame{ //called when play button is pressed, directs to the tutorial if the user has never played before, otherwise directs to gameplay screen
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"hasPlayedTutorial"]==nil) {
        CCScene *tutorial=[CCBReader loadAsScene:@"Tutorial"];
        [[CCDirector sharedDirector] replaceScene:tutorial];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"hasPlayedTutorial"];
        [defaults synchronize];
    }
    else{
        CCScene *gameplayScene=[CCBReader loadAsScene:@"Gameplay"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
    }
}


-(void)loadTutorial{ //loads the tutorial when the help button is pressed
    CCScene *tutorial=[CCBReader loadAsScene:@"Tutorial"];
    [[CCDirector sharedDirector] replaceScene:tutorial];
}

-(void)soundChange{ //enables or disables sounds when sound button is pressed
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"sound"] boolValue]==YES) {
        [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"sound"];
        [defaults synchronize];
        soundOnButton.visible=NO;
        soundOffButton.visible=YES;
    }
    else if ([[defaults objectForKey:@"sound"] boolValue]==NO) {
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"sound"];
        [defaults synchronize];
        soundOffButton.visible=NO;
        soundOnButton.visible=YES;
    }
}

#pragma mark - Collisions

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair playButton:(CCNode *)nodeA titleBottom:(CCNode *)nodeB { //sensed physics collision (so title and buttons can fall in when app is opened, and stop when the collide with an invisible node)
    return NO;
}


@end
