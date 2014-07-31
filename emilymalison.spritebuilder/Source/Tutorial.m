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
}
-(void)onEnter{
    [super onEnter];
    tileLeft.number=1;
    tileRight.number=2;
    [tileLeft setUpTutorialTile];
    [tileRight setUpTutorialTile];
}


@end
