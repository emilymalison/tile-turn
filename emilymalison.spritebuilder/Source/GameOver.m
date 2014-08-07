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
    CCLabelTTF *highScore;
}

-(void)onEnter{
    [super onEnter];
    [self setScoreLabels];
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

-(void)setScoreLabels{
    int highScoreInt = [[NSUserDefaults standardUserDefaults] integerForKey:@"High Score"];
    if (self.finalScore > highScoreInt) {
        highScoreInt = self.finalScore;
        [[NSUserDefaults standardUserDefaults] setInteger:highScoreInt forKey:@"High Score"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    highScore.string=[NSString stringWithFormat:@"%i", highScoreInt];
}





@end
