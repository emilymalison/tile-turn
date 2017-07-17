//
//  GameOver.m
//  emilymalison
//
//  Created by Emily Malison on 7/28/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOver.h"
#import "Grid.h"

@implementation GameOver{ //code for Game Over Screen at the end of a game
    //importing game objects
    Grid *_grid; //object that contains tiles and dots
    CCLabelTTF *finalScore; //label that displays final score on game over screen
    CCLabelTTF *highScore; //label that displays overall high score on game over screen
}

-(void)onEnter{
    [super onEnter];
    [self setScoreLabels];
    finalScore.string=[NSString stringWithFormat:@"%i", self.finalScore]; //defining final score
}

-(void) startGame{ //loads a new game if the user hits replay
    CCScene *gameplayScene=[CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)loadMenu{ //loads menu if user hits main menu
    CCScene *mainScene=[CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

-(void)setScoreLabels{ //gets the user's high score and displays it along with their final score
    int highScoreInt = [[NSUserDefaults standardUserDefaults] integerForKey:@"High Score"];
    if (self.finalScore > highScoreInt) {
        highScoreInt = self.finalScore;
        [[NSUserDefaults standardUserDefaults] setInteger:highScoreInt forKey:@"High Score"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    highScore.string=[NSString stringWithFormat:@"%i", highScoreInt];
}





@end
