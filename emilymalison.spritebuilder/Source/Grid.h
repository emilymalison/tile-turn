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

@interface Grid : CCNodeColor{ //grid class, the grid object is a child of the gameplay screen and contains all the tiles that are displayed
    SystemSoundID matchSound;
}

-(void)setUpGrid; //creates 3 by 3 grid of tiles
-(void)checkTile:(Tile*)rotatedTile; //checks for matches involving whatever tile was just rotated
-(void)removeTiles; //removes any tiles that were part of a match
-(void)checkHorizontallyTile:(Tile*)tile; //checks for horizontal matches on the initial grid
-(void)checkVerticallyTile:(Tile*)tile; //checks for vertical matches on the initial grid
-(void)checkForMoves; //checks for possible moves
-(void)disableUserInteraction; //disables user interaction (when tiles are shuffling, after a match is made, etc.)
-(void)enableUserInteraction; //re-enables UI when shuffling/etc. is done
-(void)resetAnimation; //resets tile animation


@property (nonatomic, assign)BOOL timerExpired; //whether or not time is up
@property(nonatomic, assign)int totalScore; //stores score
@property(nonatomic, assign)BOOL pause; //whether or not game is paused
@property(nonatomic, strong)Tile* indicatedTile; //tile that can be moved to make a match
@property(nonatomic, assign)BOOL newHint; //whether or not the game is giving a user a hint (a hint displayed when no match is made for 10 seconds)

@end
