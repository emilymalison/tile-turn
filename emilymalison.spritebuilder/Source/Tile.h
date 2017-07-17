//
//  Tile.h
//  emilymalison
//
//  Created by Emily Malison on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Tile: CCNode{ //defines the Tile class, which are children of the Grid object
    SystemSoundID turnSound;
}

-(void)rotateBackwards;
-(NSMutableArray*)rotateColorMatrix:(NSMutableArray*)matrix;
-(void)tileRemoved;

@property(nonatomic, strong)NSMutableArray* dotColorArray; //multidimensional array containing colors of dots on the tile that reflects each dots location
@property(nonatomic, strong)NSMutableArray* tileArray; //array containing the dot objects
@property(nonatomic, strong)NSMutableArray* dotColorArrayCopy; //copy of dot color array to be used to check for possible moves (this array is rotated when checking instead of the dotColorArray)
@property(nonatomic, assign)int tileX; //which column the tile is in
@property(nonatomic, assign)int tileY; //which row the tile is in
@property(nonatomic, assign)BOOL remove; //whether or not the tile was part of a match and needs to be removed
@property(nonatomic, assign)int rotationMeasure; //how much the tile has been rotated (0 for not at all, 1 for 90 degrees, 2 for 180 degrees, 3 for 270 degrees, and back to 0 at 360 degrees)
@property(nonatomic, assign)BOOL match; //whether the tile is part of a match or not
@property(nonatomic, assign)BOOL checking;
@property(nonatomic, assign)BOOL tutorialTile; //whether this tile is part of the tutorial
@property(nonatomic, assign)BOOL sound; //whether sound is enabled or not
@property(nonatomic, strong)NSMutableArray* tileMatchArray; //array that contains tiles that can be rotated to make a match

@end
