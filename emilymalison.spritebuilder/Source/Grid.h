//
//  Grid.h
//  emilymalison
//
//  Created by Emily Malison on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Tile.h"
@class Gameplay;

@interface Grid : CCNodeColor

-(void)setUpGrid;
-(void)checkTile:(Tile*)rotatedTile;
-(void)removeTiles;
-(void)checkHorizontallyTile:(Tile*)tile;
-(void)checkVerticallyTile:(Tile*)tile;


@property(nonatomic, assign)int totalScore;

@end
