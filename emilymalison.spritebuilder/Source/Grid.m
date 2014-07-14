//
//  Grid.m
//  emilymalison
//
//  Created by Emily Malison on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "MainScene.h"
#import "Tile.h"
#import "Dot.h"

static const int GRID_SIZE=3;

@implementation Grid{
    CGFloat _columnWidth;
    CGFloat _columnHeight;
    CGFloat _tileMarginVertical;
    CGFloat _tileMarginHorizontal;
    CCSprite *tileSprite;
    NSMutableArray *_gridArray;
    NSInteger *matchHorizontally;
    NSInteger *matchVertically;
    Tile *tileRotated;
}

- (void)onEnter
{
    [super onEnter];
    
    [self setUpGrid];
}

#pragma mark - Filling Grid with Tiles

-(void)setUpGrid{
    
    _gridArray=[NSMutableArray array];
    
    _columnWidth=(self.contentSize.width/GRID_SIZE);
    _columnHeight=(self.contentSize.height/GRID_SIZE);
    
    _tileMarginVertical=(_columnWidth/2);
    _tileMarginHorizontal=(_columnHeight/2);
    
    float x=_tileMarginHorizontal;
    float y=_tileMarginVertical;
    
    for (int i=0; i<GRID_SIZE; i++) {
        
        x=_tileMarginHorizontal;
        _gridArray[i]=[NSMutableArray array];
        
        
        for (int j=0; j<GRID_SIZE; j++) {
            Tile *tile= (Tile*)[CCBReader load:@"Tile"];
            
            [tile setScaleX:((_columnWidth)/tile.contentSize.width)];
            [tile setScaleY:((_columnHeight)/tile.contentSize.height)];
            
            [self addChild:tile];
            //tile.contentSize = CGSizeMake(_columnWidth, _columnHeight);
			tile.position = ccp(x, y);
            _gridArray[i][j]=tile;
            tile.tileX=i;
            tile.tileY=j;
            
			x+= _columnWidth;
		}
		y += _columnHeight;
    }
    
}

#pragma mark - Checking for Matches

-(void)checkTile:(Tile*)rotatedTile{
   //TODO find position of rotatedTile in _gridArray
    NSLog(@"method called");
    Tile *tileRotated=rotatedTile;
    //trying to create variable for the rotated tile in order to make sure all the check methods aren't called on dots that aren't on dots that aren't on the original tile, unless necessary
    Dot* dot=rotatedTile.tileArray[0][0];
    matchHorizontally=0;
    matchVertically=0;
    [self checkLeftOfDot:dot onTile:rotatedTile];
    [self checkBelowDot:dot onTile:rotatedTile];
    [self checkAboveDot:dot onTile:rotatedTile];
    [self checkRightOfDot:dot onTile:rotatedTile];
}

-(void)checkLeftOfDot:(Dot*)dot onTile:(Tile*)tile{
    NSLog(@"left called");
    if (tile.tileRotation==0){
        if (dot.dotY!=0){
        Dot* dotLeft=tile.tileArray[dot.dotX][dot.dotY-1];
            if (dot.DotColor==dotLeft.DotColor){
                matchHorizontally+=1;
                [self checkLeftOfDot:dotLeft onTile:tile];
            }
            else if(dot.DotColor!=dotLeft.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkLeftOfDot:dotLeft onTile:tile];
                //[self checkAboveDot:dotLeft onTile:tile];
                //[self checkBelowDot:dotLeft onTile:tile];
            }
        }
        else if (dot.dotY==0 && tile.tileY!=0){
            Tile* tileLeft=_gridArray[tile.tileX][tile.tileY-1];
            if (tileLeft.tileRotation==0) {
                Dot* dotLeft=tileLeft.tileArray[dot.dotX][2];
                if (dot.DotColor==dotLeft.DotColor) {
                    matchHorizontally+=1;
                    [self checkLeftOfDot:dotLeft onTile:tileLeft];
                }
            }
            else if (tileLeft.tileRotation==1){
                if (dot.dotX==0) {
                    Dot* dotLeft=tileLeft.tileArray[2][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotLeft=tileLeft.tileArray[2][1];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotLeft=tileLeft.tileArray[2][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
            }
            else if (tileLeft.tileRotation==2){
                if (dot.dotX==0) {
                    Dot* dotLeft=tileLeft.tileArray[0][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotLeft=tileLeft.tileArray[1][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotLeft=tileLeft.tileArray[2][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
            }
            else if (tileLeft.tileRotation==3){
                if (dot.dotX==0) {
                    Dot* dotLeft=tileLeft.tileArray[2][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotLeft=tileLeft.tileArray[1][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotLeft=tileLeft.tileArray[0][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
            }
        }
    }
    else if (tile.tileRotation==1){
        if (dot.dotX!=0){
            Dot* dotLeft=tile.tileArray[dot.dotX-1][dot.dotY];
            if (dot.DotColor==dotLeft.DotColor){
                matchHorizontally+=1;
                [self checkLeftOfDot:dotLeft onTile:tile];
            }
            else if(dot.DotColor!=dotLeft.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkLeftOfDot:dotLeft onTile:tile];
                //[self checkAboveDot:dotLeft onTile:tile];
                //[self checkBelowDot:dotLeft onTile:tile];
            }
        }
        else if (dot.dotX==0 && tile.tileY!=0){
            Tile* tileLeft=_gridArray[tile.tileX][tile.tileY-1];
            
            //determining the position of the dot to the left on the tile to the left, based on the rotation of the tile to the left
            if (tileLeft.tileRotation==0) {
                if (dot.dotY==0){
                    Dot* dotLeft=tileLeft.tileArray[2][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotLeft=tileLeft.tileArray[1][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotLeft=tileLeft.tileArray[0][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
            }
            else if (tileLeft.tileRotation==1){
                Dot* dotLeft=tileLeft.tileArray[2][dot.dotY];
                if (dot.DotColor==dotLeft.DotColor) {
                    matchHorizontally+=1;
                    [self checkLeftOfDot:dotLeft onTile:tileLeft];
                }
            }
            else if (tileLeft.tileRotation==2){
                Dot* dotLeft=tileLeft.tileArray[dot.dotY][dot.dotX];
                if (dot.DotColor==dotLeft.DotColor) {
                    matchHorizontally+=1;
                    [self checkLeftOfDot:dotLeft onTile:tileLeft];
                }
            }
            else if (tileLeft.tileRotation==3){
                if (dot.dotY==0){
                    Dot* dotLeft=tileLeft.tileArray[0][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotLeft=tileLeft.tileArray[0][1];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotLeft=tileLeft.tileArray[0][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
            }
        }
    }
    else if (tile.tileRotation==2){
        if (dot.dotY!=2){
            Dot* dotLeft=tile.tileArray[dot.dotX][dot.dotY+1];
            if (dot.DotColor==dotLeft.DotColor){
                matchHorizontally+=1;
                [self checkLeftOfDot:dotLeft onTile:tile];
            }
            else if(dot.DotColor!=dotLeft.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkLeftOfDot:dotLeft onTile:tile];
                //[self checkAboveDot:dotLeft onTile:tile];
                //[self checkBelowDot:dotLeft onTile:tile];
            }
        }
        else if (dot.dotY==2 && tile.tileY!=0){
            Tile* tileLeft=_gridArray[tile.tileX][tile.tileY-1];
            
            //determining the position of the dot to the left on the tile to the left, based on the rotation of the tile to the left
            if (tileLeft.tileRotation==0) {
                if (dot.dotX==0){
                    Dot* dotLeft=tileLeft.tileArray[2][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotLeft=tileLeft.tileArray[1][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotLeft=tileLeft.tileArray[0][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
            }
            else if (tileLeft.tileRotation==1){
                Dot* dotLeft=tileLeft.tileArray[2][dot.dotX];
                if (dot.DotColor==dotLeft.DotColor) {
                    matchHorizontally+=1;
                    [self checkLeftOfDot:dotLeft onTile:tileLeft];
                }
            }
            else if (tileLeft.tileRotation==2){
                Dot* dotLeft=tileLeft.tileArray[dot.dotX][0];
                if (dot.DotColor==dotLeft.DotColor) {
                    matchHorizontally+=1;
                    [self checkLeftOfDot:dotLeft onTile:tileLeft];
                }
            }
            else if (tileLeft.tileRotation==3){
                if (dot.dotX==0){
                    Dot* dotLeft=tileLeft.tileArray[0][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotLeft=tileLeft.tileArray[0][1];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotLeft=tileLeft.tileArray[0][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
            }
        }
    }
    else if (tile.tileRotation==3){
        if (dot.dotX!=2){
            Dot* dotLeft=tile.tileArray[dot.dotX+1][dot.dotY];
            if (dot.DotColor==dotLeft.DotColor){
                matchHorizontally+=1;
                [self checkLeftOfDot:dotLeft onTile:tile];
            }
            else if(dot.DotColor!=dotLeft.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkLeftOfDot:dotLeft onTile:tile];
                //[self checkAboveDot:dotLeft onTile:tile];
                //[self checkBelowDot:dotLeft onTile:tile];
            }
        }
        else if (dot.dotX==2 && tile.tileY!=0){
            Tile* tileLeft=_gridArray[tile.tileX][tile.tileY-1];
            
            //determining the position of the dot to the left on the tile to the left, based on the rotation of the tile to the left
            if (tileLeft.tileRotation==0) {
                Dot* dotLeft=tileLeft.tileArray[dot.dotY][2];
                if (dot.DotColor==dotLeft.DotColor) {
                    matchHorizontally+=1;
                    [self checkLeftOfDot:dotLeft onTile:tileLeft];
                }
            }
            else if (tileLeft.tileRotation==1){
                if (dot.dotY==0) {
                    Dot* dotLeft=tileLeft.tileArray[2][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotLeft=tileLeft.tileArray[2][1];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotLeft=tileLeft.tileArray[2][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
            }
            else if (tileLeft.tileRotation==2){
                if (dot.dotY==0) {
                    Dot* dotLeft=tileLeft.tileArray[2][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotLeft=tileLeft.tileArray[1][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotLeft=tileLeft.tileArray[0][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                }

            }
            else if (tileLeft.tileRotation==3){
                Dot* dotLeft=tileLeft.tileArray[0][dot.dotY];
                if (dot.DotColor==dotLeft.DotColor) {
                    matchHorizontally+=1;
                    [self checkLeftOfDot:dotLeft onTile:tileLeft];
                }
            }
        }
    }
}

-(void)checkRightOfDot:(Dot*)dot onTile:(Tile*)tile{
    NSLog(@"right called");
    if (tile.tileRotation==0){
        if (dot.dotY!=2){
            Dot* dotRight=tile.tileArray[dot.dotX][dot.dotY+1];
            if (dot.DotColor==dotRight.DotColor){
                matchHorizontally+=1;
                [self checkRightOfDot:dotRight onTile:tile];
            }
            else if(dot.DotColor!=dotRight.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkRightOfDot:dotRight onTile:tile];
                //[self checkAboveDot:dotRight onTile:tile];
                //[self checkBelowDot:dotRight onTile:tile];
            }
        }
        else if (dot.dotY==2 && tile.tileY!=2){
            Tile* tileRight=_gridArray[tile.tileX][tile.tileY+1];
            if (tileRight.tileRotation==0) {
                Dot* dotRight=tileRight.tileArray[dot.dotX][0];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
            }
            else if (tileRight.tileRotation==1){
                if (dot.dotX==0) {
                    Dot* dotRight=tileRight.tileArray[0][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotRight=tileRight.tileArray[0][1];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotRight=tileRight.tileArray[0][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
            }
            else if (tileRight.tileRotation==2){
                if (dot.dotX==0) {
                    Dot* dotRight=tileRight.tileArray[2][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotRight=tileRight.tileArray[1][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotRight=tileRight.tileArray[0][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
            }
            else if (tileRight.tileRotation==3){
                Dot* dotRight=tileRight.tileArray[2][dot.dotX];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
            }
        }
    }
    else if (tile.tileRotation==1){
        if (dot.dotX!=2){
            Dot* dotRight=tile.tileArray[dot.dotX+1][dot.dotY];
            if (dot.DotColor==dotRight.DotColor){
                matchHorizontally+=1;
                [self checkRightOfDot:dotRight onTile:tile];
            }
            else if(dot.DotColor!=dotRight.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkRightOfDot:dotRight onTile:tile];
                //[self checkAboveDot:dotRight onTile:tile];
                //[self checkBelowDot:dotRight onTile:tile];
            }
        }
        else if (dot.dotX==2 && tile.tileY!=2){
            Tile* tileRight=_gridArray[tile.tileX][tile.tileY+1];
            
            //determining the position of the dot to the left on the tile to the left, based on the rotation of the tile to the left
            if (tileRight.tileRotation==0) {
                if (dot.dotY==0){
                    Dot* dotRight=tileRight.tileArray[2][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotRight=tileRight.tileArray[1][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotRight=tileRight.tileArray[0][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
            }
            else if (tileRight.tileRotation==1){
                Dot* dotRight=tileRight.tileArray[0][dot.dotY];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
            }
            else if (tileRight.tileRotation==2){
                Dot* dotRight=tileRight.tileArray[dot.dotY][2];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
            }
            else if (tileRight.tileRotation==3){
                if (dot.dotY==0){
                    Dot* dotRight=tileRight.tileArray[2][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotRight=tileRight.tileArray[2][1];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotRight=tileRight.tileArray[2][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
            }
        }
    }
    else if (tile.tileRotation==2){
        if (dot.dotY!=0){
            Dot* dotRight=tile.tileArray[dot.dotX][dot.dotY-1];
            if (dot.DotColor==dotRight.DotColor){
                matchHorizontally+=1;
                [self checkRightOfDot:dotRight onTile:tile];
            }
            else if(dot.DotColor!=dotRight.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkRightOfDot:dotRight onTile:tile];
                //[self checkAboveDot:dotRight onTile:tile];
                //[self checkBelowDot:dotRight onTile:tile];
            }
        }
        else if (dot.dotY==0 && tile.tileY!=2){
            Tile* tileRight=_gridArray[tile.tileX][tile.tileY+1];
            
            //determining the position of the dot to the left on the tile to the left, based on the rotation of the tile to the left
            if (tileRight.tileRotation==0) {
                if (dot.dotX==0){
                    Dot* dotRight=tileRight.tileArray[2][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotRight=tileRight.tileArray[1][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotRight=tileRight.tileArray[0][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
            }
            else if (tileRight.tileRotation==1){
                Dot* dotRight=tileRight.tileArray[0][dot.dotX];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
            }
            else if (tileRight.tileRotation==2){
                Dot* dotRight=tileRight.tileArray[dot.dotX][2];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
            }
            else if (tileRight.tileRotation==3){
                if (dot.dotX==0){
                    Dot* dotRight=tileRight.tileArray[2][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotRight=tileRight.tileArray[2][1];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotRight=tileRight.tileArray[2][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
            }
        }
    }
    else if (tile.tileRotation==3){
        if (dot.dotX!=0){
            Dot* dotRight=tile.tileArray[dot.dotX-1][dot.dotY];
            if (dot.DotColor==dotRight.DotColor){
                matchHorizontally+=1;
                [self checkRightOfDot:dotRight onTile:tile];
            }
            else if(dot.DotColor!=dotRight.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkRightOfDot:dotRight onTile:tile];
                //[self checkAboveDot:dotRight onTile:tile];
                //[self checkBelowDot:dotRight onTile:tile];
            }
        }
        else if (dot.dotX==0 && tile.tileY!=2){
            Tile* tileRight=_gridArray[tile.tileX][tile.tileY+1];
            
            //determining the position of the dot to the left on the tile to the left, based on the rotation of the tile to the left
            if (tileRight.tileRotation==0) {
                Dot* dotRight=tileRight.tileArray[dot.dotY][0];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
            }
            else if (tileRight.tileRotation==1){
                if (dot.dotY==0) {
                    Dot* dotRight=tileRight.tileArray[0][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotRight=tileRight.tileArray[0][1];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotRight=tileRight.tileArray[0][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
            }
            else if (tileRight.tileRotation==2){
                if (dot.dotY==0) {
                    Dot* dotRight=tileRight.tileArray[2][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotRight=tileRight.tileArray[1][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotRight=tileRight.tileArray[0][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                }
            }
            else if (tileRight.tileRotation==3){
                Dot* dotRight=tileRight.tileArray[2][dot.dotY];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
            }
        }
    }
}


-(void)checkAboveDot:(Dot*)dot onTile:(Tile*)tile{
    NSLog(@"above called");
    if (tile.tileRotation==0){
        if (dot.dotX!=2){
            Dot* dotUp=tile.tileArray[dot.dotX+1][dot.dotY];
            if (dot.DotColor==dotUp.DotColor){
                matchVertically+=1;
                [self checkAboveDot:dotUp onTile:tile];
            }
            else if(dot.DotColor!=dotUp.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkRightOfDot:dotUp onTile:tile];
                //[self checkAboveDot:dotUp onTile:tile];
                //[self checkLeftOfDot:dotUp onTile:tile];
            }
        }
        else if (dot.dotX==2 && tile.tileX!=2){
            Tile* tileUp=_gridArray[tile.tileX+1][tile.tileY];
            if (tileUp.tileRotation==0) {
                Dot* dotUp=tileUp.tileArray[0][dot.dotY];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
            }
            else if (tileUp.tileRotation==1){
                Dot* dotUp=tileUp.tileArray[dot.dotY][2];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
            }
            else if (tileUp.tileRotation==2){
                if (dot.dotY==0) {
                    Dot* dotUp=tileUp.tileArray[2][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotUp=tileUp.tileArray[2][1];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotUp=tileUp.tileArray[2][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
            }
            else if (tileUp.tileRotation==3){
                if (dot.dotY==0) {
                    Dot* dotUp=tileUp.tileArray[2][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotUp=tileUp.tileArray[1][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotUp=tileUp.tileArray[0][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
            }
        }
    }
    else if (tile.tileRotation==1){
        if (dot.dotY!=0){
            Dot* dotUp=tile.tileArray[dot.dotX][dot.dotY-1];
            if (dot.DotColor==dotUp.DotColor){
                matchVertically+=1;
                [self checkAboveDot:dotUp onTile:tile];
            }
            else if(dot.DotColor!=dotUp.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkRightOfDot:dotUp onTile:tile];
                //[self checkAboveDot:dotUp onTile:tile];
                //[self checkLeftOfDot:dotUp onTile:tile];
            }
        }
        else if (dot.dotY==0 && tile.tileX!=2){
            Tile* tileUp=_gridArray[tile.tileX+1][tile.tileY];
            
            //determining the position of the dot to the left on the tile to the left, based on the rotation of the tile to the left
            if (tileUp.tileRotation==0) {
                Dot* dotUp=tileUp.tileArray[0][dot.dotX];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
            }
            else if (tileUp.tileRotation==1){
                Dot* dotUp=tileUp.tileArray[dot.dotX][2];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
            }
            else if (tileUp.tileRotation==2){
                if (dot.dotX==0) {
                    Dot* dotUp=tileUp.tileArray[2][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotUp=tileUp.tileArray[2][1];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotUp=tileUp.tileArray[2][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
            }
            else if (tileUp.tileRotation==3){
                if (dot.dotX==0){
                    Dot* dotUp=tileUp.tileArray[2][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotUp=tileUp.tileArray[1][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotUp=tileUp.tileArray[0][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
            }
        }
    }
    else if (tile.tileRotation==2){
        if (dot.dotX!=0){
            Dot* dotUp=tile.tileArray[dot.dotX-1][dot.dotY];
            if (dot.DotColor==dotUp.DotColor) {
                matchVertically+=1;
                [self checkAboveDot:dotUp onTile:tile];
            }
            else if(dot.DotColor!=dotUp.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkRightOfDot:dotUp onTile:tile];
                //[self checkAboveDot:dotUp onTile:tile];
                //[self checkLeftOfDot:dotUp onTile:tile];
            }
        }
        else if (dot.dotX==0 && tile.tileX!=2){
            Tile* tileUp=_gridArray[tile.tileX+1][tile.tileY];
            
            //determining the position of the dot to the left on the tile to the left, based on the rotation of the tile to the left
            if (tileUp.tileRotation==0) {
                if (dot.dotY==0){
                    Dot* dotUp=tileUp.tileArray[0][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotUp=tileUp.tileArray[0][1];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotUp=tileUp.tileArray[0][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
            }
            else if (tileUp.tileRotation==1){
                if (dot.dotY==0) {
                    Dot* dotUp=tileUp.tileArray[2][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotUp=tileUp.tileArray[1][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotUp=tileUp.tileArray[0][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
            }
            else if (tileUp.tileRotation==2){
                Dot* dotUp=tileUp.tileArray[2][dot.dotY];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
            }
            else if (tileUp.tileRotation==3){
                Dot* dotUp=tileUp.tileArray[dot.dotY][0];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
            }
        }
    }
    else if (tile.tileRotation==3){
        if (dot.dotY!=2){
            Dot* dotUp=tile.tileArray[dot.dotX][dot.dotY+1];
            if (dot.DotColor==dotUp.DotColor) {
                matchVertically+=1;
                [self checkAboveDot:dotUp onTile:tile];
            }
            else if(dot.DotColor!=dotUp.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkRightOfDot:dotUp onTile:tile];
                //[self checkAboveDot:dotUp onTile:tile];
                //[self checkLeftOfDot:dotUp onTile:tile];
            }
        }
        else if (dot.dotY==2 && tile.tileX!=2){
            Tile* tileUp=_gridArray[tile.tileX+1][tile.tileY];
            
            //determining the position of the dot to the left on the tile to the left, based on the rotation of the tile to the left
            if (tileUp.tileRotation==0) {
                if (dot.dotX==0) {
                    Dot* dotUp=tileUp.tileArray[0][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotUp=tileUp.tileArray[0][1];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotUp=tileUp.tileArray[0][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
            }
            else if (tileUp.tileRotation==1){
                if (dot.dotX==0) {
                    Dot* dotUp=tileUp.tileArray[2][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotUp=tileUp.tileArray[1][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotUp=tileUp.tileArray[0][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                }
            }
            else if (tileUp.tileRotation==2){
                Dot* dotUp=tileUp.tileArray[2][dot.dotX];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
            }
            else if (tileUp.tileRotation==3){
                Dot* dotUp=tileUp.tileArray[dot.dotX][0];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
            }
        }
    }
}


-(void)checkBelowDot:(Dot*)dot onTile:(Tile*)tile{
    NSLog(@"below called");
    if (tile.tileRotation==0){
        if (dot.dotX!=0){
            Dot* dotDown=tile.tileArray[dot.dotX-1][dot.dotY];
            if (dot.DotColor==dotDown.DotColor){
                matchVertically+=1;
                [self checkBelowDot:dotDown onTile:tile];
            }
            else if(dot.DotColor!=dotDown.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkRightOfDot:dotDown onTile:tile];
                //[self checkBelow:dotDown onTile:tile];
                //[self checkLeftOfDot:dotDown onTile:tile];
            }
        }
        else if (dot.dotX==0 && tile.tileX!=0){
            Tile* tileDown=_gridArray[tile.tileX-1][tile.tileY];
            if (tileDown.tileRotation==0) {
                Dot* dotDown=tileDown.tileArray[2][dot.dotY];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
            }
            else if (tileDown.tileRotation==1){
                Dot* dotDown=tileDown.tileArray[0][dot.dotX];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
            }
            else if (tileDown.tileRotation==2){
                if (dot.dotY==0) {
                    Dot* dotDown=tileDown.tileArray[0][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotDown=tileDown.tileArray[0][1];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotDown=tileDown.tileArray[0][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
            }
            else if (tileDown.tileRotation==3){
                if (dot.dotY==0) {
                    Dot* dotDown=tileDown.tileArray[0][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotDown=tileDown.tileArray[1][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotDown=tileDown.tileArray[2][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
            }
        }
    }
    else if (tile.tileRotation==1){
        if (dot.dotY!=2){
            Dot* dotDown=tile.tileArray[dot.dotX][dot.dotY+1];
            if (dot.DotColor==dotDown.DotColor) {
                matchVertically+=1;
                [self checkBelowDot:dotDown onTile:tile];
            }
            else if(dot.DotColor!=dotDown.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkRightOfDot:dotDown onTile:tile];
                //[self checkBelowDot:dotDown onTile:tile];
                //[self checkLeftOfDot:dotDown onTile:tile];
            }
        }
        else if (dot.dotY==2 && tile.tileX!=0){
            Tile* tileDown=_gridArray[tile.tileX-1][tile.tileY];
            
            //determining the position of the dot to the left on the tile to the left, based on the rotation of the tile to the left
            if (tileDown.tileRotation==0) {
                Dot* dotDown=tileDown.tileArray[2][dot.dotX];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
            }
            else if (tileDown.tileRotation==1){
                Dot* dotDown=tileDown.tileArray[dot.dotX][0];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
            }
            else if (tileDown.tileRotation==2){
                if (dot.dotX==0) {
                    Dot* dotDown=tileDown.tileArray[0][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotDown=tileDown.tileArray[0][1];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotDown=tileDown.tileArray[0][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
            }
            else if (tileDown.tileRotation==3){
                if (dot.dotX==0){
                    Dot* dotDown=tileDown.tileArray[2][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotDown=tileDown.tileArray[1][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotDown=tileDown.tileArray[0][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
            }
        }
    }
    else if (tile.tileRotation==2){
        if (dot.dotX!=2){
            Dot* dotDown=tile.tileArray[dot.dotX+1][dot.dotY];
            if (dot.DotColor==dotDown.DotColor) {
                matchVertically+=1;
                [self checkBelowDot:dotDown onTile:tile];
            }
            else if(dot.DotColor!=dotDown.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkRightOfDot:dotDown onTile:tile];
                //[self checkBelowDot:dotDown onTile:tile];
                //[self checkLeftOfDot:dotDown onTile:tile];
            }
        }
        else if (dot.dotX==2 && tile.tileX!=0){
            Tile* tileDown=_gridArray[tile.tileX-1][tile.tileY];
            
            //determining the position of the dot to the left on the tile to the left, based on the rotation of the tile to the left
            if (tileDown.tileRotation==0) {
                if (dot.dotY==0){
                    Dot* dotDown=tileDown.tileArray[2][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotDown=tileDown.tileArray[2][1];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotDown=tileDown.tileArray[2][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
            }
            else if (tileDown.tileRotation==1){
                if (dot.dotY==0) {
                    Dot* dotDown=tileDown.tileArray[2][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotDown=tileDown.tileArray[1][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotDown=tileDown.tileArray[0][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
            }
            else if (tileDown.tileRotation==2){
                Dot* dotDown=tileDown.tileArray[0][dot.dotY];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
            }
            else if (tileDown.tileRotation==3){
                Dot* dotDown=tileDown.tileArray[dot.dotY][2];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
            }
        }
    }
    else if (tile.tileRotation==3){
        if (dot.dotY!=0){
            Dot* dotDown=tile.tileArray[dot.dotX][dot.dotY-1];
            if (dot.DotColor==dotDown.DotColor) {
                matchVertically+=1;
                [self checkBelowDot:dotDown onTile:tile];
            }
            else if(dot.DotColor!=dotDown.DotColor && tile==tileRotated){
                matchHorizontally=0;
                matchVertically=0;
                //[self checkRightOfDot:dotDown onTile:tile];
                //[self checkBelowDot:dotDown onTile:tile];
                //[self checkLeftOfDot:dotDown onTile:tile];
            }
        }
        else if (dot.dotY==0 && tile.tileX!=0){
            Tile* tileDown=_gridArray[tile.tileX-1][tile.tileY];
            
            //determining the position of the dot to the left on the tile to the left, based on the rotation of the tile to the left
            if (tileDown.tileRotation==0) {
                if (dot.dotX==0) {
                    Dot* dotDown=tileDown.tileArray[2][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotDown=tileDown.tileArray[2][1];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotDown=tileDown.tileArray[2][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
            }
            else if (tileDown.tileRotation==1){
                if (dot.dotX==0) {
                    Dot* dotDown=tileDown.tileArray[2][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotDown=tileDown.tileArray[1][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotDown=tileDown.tileArray[0][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                }
            }
            else if (tileDown.tileRotation==2){
                Dot* dotDown=tileDown.tileArray[0][dot.dotX];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
            }
            else if (tileDown.tileRotation==3){
                Dot* dotDown=tileDown.tileArray[dot.dotX][2];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
            }
        }
    }
}
        
@end

