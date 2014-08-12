//
//  Tutorial.m
//  emilymalison
//
//  Created by Emily Malison on 7/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tutorial.h"
#import "TutorialTile.h"
#import "Dot.h"

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
    CCNode *continueBackground;
    CCNode *play;

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
        Dot* dot1=tileLeft.tileArray[2][0];
        Dot* dot2=tileLeft.tileArray[2][1];
        Dot* dot3=tileLeft.tileArray[2][2];
        Dot* dot4=tileRight.tileArray[2][0];
        Dot* dot5=tileRight.tileArray[2][1];
        [dot1.animationManager runAnimationsForSequenceNamed:(@"Animation")];
        [dot2.animationManager runAnimationsForSequenceNamed:(@"Animation")];
        [dot3.animationManager runAnimationsForSequenceNamed:(@"Animation")];
        [dot4.animationManager runAnimationsForSequenceNamed:(@"Animation")];
        [dot5.animationManager runAnimationsForSequenceNamed:(@"Animation")];
        [self scheduleBlock:^(CCTimer *timer) {
            [greatJob.animationManager runAnimationsForSequenceNamed:(@"Animation")];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(resetAnimation) userInfo:nil repeats:NO];
            greatJob.visible=YES;
        } delay:.4];
    }
    else if (tutorialTile4.rotationMeasure==3){
        tutorialTile4.rotationMeasure=0;
        Dot* dot1=tutorialTile3.tileArray[2][0];
        Dot* dot2=tutorialTile3.tileArray[2][1];
        Dot* dot3=tutorialTile3.tileArray[2][2];
        Dot* dot4=tutorialTile4.tileArray[2][0];
        Dot* dot5=tutorialTile4.tileArray[2][1];
        Dot* dot6=tutorialTile4.tileArray[2][2];
        [dot1.animationManager runAnimationsForSequenceNamed:(@"Animation")];
        [dot2.animationManager runAnimationsForSequenceNamed:(@"Animation")];
        [dot3.animationManager runAnimationsForSequenceNamed:(@"Animation")];
        [dot4.animationManager runAnimationsForSequenceNamed:(@"Animation")];
        [dot5.animationManager runAnimationsForSequenceNamed:(@"Animation")];
        [dot6.animationManager runAnimationsForSequenceNamed:(@"Animation")];
        [self scheduleBlock:^(CCTimer *timer) {
            greatText.visible=YES;
            [greatText.animationManager runAnimationsForSequenceNamed:(@"Animation")];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(resetSecondAnimation) userInfo:nil repeats:NO];
        } delay:.4];
    }
}

-(void)resetAnimation{
    [greatJob.animationManager runAnimationsForSequenceNamed:(@"Default Timeline")];
    continueTimer=[NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(continueButtonVisible) userInfo:nil repeats:NO];
}

-(void)continueButtonVisible{
    continueButton.visible=YES;
    continueBackground.visible=YES;
    [continueTimer invalidate];
}

-(void)nextScreen{
    if (numberScene==1) {
        continueButton.visible=NO;
        continueBackground.visible=NO;
        newScreen.visible=YES;
        tutorialTile3.visible=YES;
        tutorialTile4.visible=YES;
        secondText.visible=YES;
        numberScene+=1;
    }
    else if (numberScene==2){
        continueButton.visible=NO;
        continueBackground.visible=NO;
        tutorialTile3.visible=NO;
        tutorialTile4.visible=NO;
        secondText.visible=NO;
        greatText.visible=NO;
        newButton.visible=YES;
        newText.visible=YES;
        play.visible=YES;
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
