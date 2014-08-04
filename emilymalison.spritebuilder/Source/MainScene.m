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
    /*if (timesPlayed==1){
        CCScene *tutorial=[CCBReader loadAsScene:@"Tutorial"];
        [[CCDirector sharedDirector] replaceScene:tutorial];
    }*/
    
    CCScene *gameplayScene=[CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}


-(void)loadTutorial{
    CCScene *tutorial=[CCBReader loadAsScene:@"Tutorial"];
    [[CCDirector sharedDirector] replaceScene:tutorial];
}


@end
