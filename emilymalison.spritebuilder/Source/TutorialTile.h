//
//  TutorialTile.h
//  emilymalison
//
//  Created by Emily Malison on 7/31/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface TutorialTile : CCSprite

@property(nonatomic, assign)int number; //which number tile it is in the tutorial
@property(nonatomic, assign)int rotationMeasure; //how rotated it is, same as the property in Tile.h
@property(nonatomic, strong)NSMutableArray* tileArray; //array of dots on the tile

-(void)setUpTutorialTile;
@end
