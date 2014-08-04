//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene{
}

#pragma mark - Loading Gameplay Scene

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


@end
