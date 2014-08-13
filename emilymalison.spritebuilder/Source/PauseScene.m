//
//  PauseScene.m
//  emilymalison
//
//  Created by Emily Malison on 8/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PauseScene.h"

@implementation PauseScene

-(void)continuePlay{
    [[CCDirector sharedDirector] popScene];
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
