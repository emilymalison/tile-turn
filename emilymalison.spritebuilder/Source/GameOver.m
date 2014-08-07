//
//  GameOver.m
//  emilymalison
//
//  Created by Emily Malison on 7/28/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOver.h"
#import "Grid.h"

@implementation GameOver{
    Grid *_grid;
    CCLabelTTF *finalScore;
}

-(void)onEnter{
    [super onEnter];
    finalScore.string=[NSString stringWithFormat:@"%i", self.finalScore];
}

-(void) startGame{
    CCScene *gameplayScene=[CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)loadMenu{
    CCScene *mainScene=[CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}





@end
