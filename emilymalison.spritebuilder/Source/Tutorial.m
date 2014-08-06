//
//  Tutorial.m
//  emilymalison
//
//  Created by Emily Malison on 7/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tutorial.h"
#import "TutorialTile.h"

@implementation Tutorial{
    TutorialTile *tileLeft;
    TutorialTile *tileRight;
    TutorialTile *tutorialTile3;
    TutorialTile *tutorialTile4;
    CCLabelTTF *greatJob;
    CCNodeColor *newScreen;
    CCButton *continueButton;
    CCButton *newButton;
    CCLabelTTF *newText;
    CCLabelTTF *secondText;
    CCLabelTTF *greatText;
    NSTimer *checkTimer;
    NSTimer *continueTimer;
    int numberScene;
}

-(void)onEnter{
    [super onEnter];
    tileLeft.number=1;
    tileRight.number=2;
    tutorialTile3.number=3;
    tutorialTile3.visible=NO;
    tutorialTile4.number=4;
    tutorialTile4.visible=NO;
    [tileLeft setUpTutorialTile];
    [tileRight setUpTutorialTile];
    [tutorialTile3 setUpTutorialTile];
    [tutorialTile4 setUpTutorialTile];
    
    numberScene=1;
}

-(void)check{
    if (tileRight.rotationMeasure==1) {
        tileRight.rotationMeasure=0;
        greatJob.visible=YES;
        [greatJob.animationManager runAnimationsForSequenceNamed:(@"Animation")];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(resetAnimation) userInfo:nil repeats:NO];
    }
    else if (tutorialTile4.rotationMeasure==3){
        tutorialTile4.rotationMeasure=0;
        greatText.visible=YES;
        [greatText.animationManager runAnimationsForSequenceNamed:(@"Animation")];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(resetSecondAnimation) userInfo:nil repeats:NO];
    }
}

-(void)resetAnimation{
    [greatJob.animationManager runAnimationsForSequenceNamed:(@"Default Timeline")];
    continueTimer=[NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(continueButtonVisible) userInfo:nil repeats:NO];
}

-(void)continueButtonVisible{
    continueButton.visible=YES;
    [continueTimer invalidate];
}

-(void)nextScreen{
    if (numberScene==1) {
        continueButton.visible=NO;
        newScreen.visible=YES;
        tutorialTile3.visible=YES;
        tutorialTile4.visible=YES;
        secondText.visible=YES;
        numberScene+=1;
    }
    else if (numberScene==2){
        continueButton.visible=NO;
        tutorialTile3.visible=NO;
        tutorialTile4.visible=NO;
        secondText.visible=NO;
        greatText.visible=NO;
        newButton.visible=YES;
        newText.visible=YES;
        numberScene+=1;
    }
}

-(void)resetSecondAnimation{
    [greatJob.animationManager runAnimationsForSequenceNamed:(@"Default Timeline")];
    continueTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(continueButtonVisible) userInfo:nil repeats:NO];
}

-(void) startGame{
    CCScene *gameplayScene=[CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}



@end
