//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene{
    CCButton *soundOnButton;
    CCButton *soundOffButton;
    CCPhysicsNode *_physicsNode;
    CCButton *playButton;
    CCSprite *playBackground;
}

#pragma mark - Loading Gameplay Scene
-(void)onEnter{
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
-(void) startGame{
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


-(void)loadTutorial{
    CCScene *tutorial=[CCBReader loadAsScene:@"Tutorial"];
    [[CCDirector sharedDirector] replaceScene:tutorial];
}

-(void)soundChange{
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

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair playButton:(CCNode *)nodeA titleBottom:(CCNode *)nodeB {
    return NO;
}


@end
