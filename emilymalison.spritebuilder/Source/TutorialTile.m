//
//  TutorialTile.m
//  emilymalison
//
//  Created by Emily Malison on 7/31/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TutorialTile.h"

@implementation TutorialTile{
    BOOL canTouch;
}

-(void)onEnter{
    [super onEnter];
    
    self.userInteractionEnabled=YES;
    canTouch=YES;
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if (canTouch) {
        canTouch = NO;
        CCActionRotateBy *rotateTile= [CCActionRotateBy actionWithDuration:.4 angle:90];
        CCActionCallBlock *resetTouch = [CCActionCallBlock actionWithBlock:^{
            canTouch= YES;
        }];
        [self runAction:[CCActionSequence actionOne:rotateTile two:resetTouch]];
        
    }
}




@end
