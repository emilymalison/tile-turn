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
}

#pragma mark - Loading Gameplay Scene
-(void)onEnter{
    [super onEnter];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"sound"]==nil) {
        [defaults setBool:YES forKey:@"sound"];
        [defaults synchronize];
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
    if ([defaults objectForKey:@"sound"]==YES) {
        [defaults setBool:NO forKey:@"sound"];
        [defaults synchronize];
        soundOnButton.visible=NO;
        soundOffButton.visible=YES;
    }
    if ([defaults objectForKey:@"sound"]==NO) {
        [defaults setBool:YES forKey:@"sound"];
        [defaults synchronize];
        soundOffButton.visible=NO;
        soundOnButton.visible=YES;
    }
}


@end
