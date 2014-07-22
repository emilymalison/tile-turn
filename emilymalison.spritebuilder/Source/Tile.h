//
//  Tile.h
//  emilymalison
//
//  Created by Emily Malison on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Tile: CCNode

-(void)rotateBackwards;
-(NSMutableArray*)rotateColorMatrix:(NSMutableArray*)matrix;

@property(nonatomic, strong)NSMutableArray* dotColorArray;
@property(nonatomic, strong)NSMutableArray* tileArray;
@property(nonatomic, strong)NSMutableArray* dotColorArrayCopy;
@property(nonatomic, assign)int tileX;
@property(nonatomic, assign)int tileY;
@property(nonatomic, assign)BOOL remove;
@property(nonatomic, assign)int rotationMeasure;
@property(nonatomic, assign)BOOL match;

@end
