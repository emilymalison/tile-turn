//
//  TutorialTile.h
//  emilymalison
//
//  Created by Emily Malison on 7/31/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface TutorialTile : CCSprite

@property(nonatomic, assign)int number;
@property(nonatomic, assign)int rotationMeasure;
@property(nonatomic, strong)NSMutableArray* tileArray;

-(void)setUpTutorialTile;
@end
