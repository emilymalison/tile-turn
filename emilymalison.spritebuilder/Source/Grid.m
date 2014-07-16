//
//  Grid.m
//  emilymalison
//
//  Created by Emily Malison on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "MainScene.h"
#import "Gameplay.h"
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
    int matchHorizontally;
    int matchVertically;
    Tile *tileRotated;
    int score;
    NSMutableArray *_matchArray;
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
    //NSLog(@"method called");
    tileRotated=rotatedTile;
    //trying to create variable for the rotated tile in order to make sure all the check methods aren't called on dots that aren't on dots that aren't on the original tile, unless necessary
    for (int x=0; x<3; x++) {
        for (int y=0; y<3; y++) {
            Dot* dot=rotatedTile.tileArray[x][y];
            dot.dotChecked=false;
        }
    }
    
    Dot* dot=rotatedTile.tileArray[0][0];
    matchHorizontally=1;
    matchVertically=1;
    _matchArray=[NSMutableArray array];
    dot.dotChecked=true;
    [self checkLeftOfDot:dot onTile:rotatedTile];
    [self checkBelowDot:dot onTile:rotatedTile];
    [self checkAboveDot:dot onTile:rotatedTile];
    [self checkRightOfDot:dot onTile:rotatedTile];
    
}

-(void)checkLeftOfDot:(Dot*)dot onTile:(Tile*)tile{
    //NSLog(@"left called");
    if (tile.tileRotation==0){
        if (dot.dotY!=0){
        Dot* dotLeft=tile.tileArray[dot.dotX][dot.dotY-1];
            if (dot.DotColor==dotLeft.DotColor){
                matchHorizontally+=1;
                [self checkLeftOfDot:dotLeft onTile:tile];
                if (dotLeft.dotChecked==false) {
                    dotLeft.dotChecked=true;
                    [self checkAboveDot:dotLeft onTile:tile];
                    [self checkBelowDot:dotLeft onTile:tile];
                }
            }
            else if(dot.DotColor!=dotLeft.DotColor && tile==tileRotated && dotLeft.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotLeft.dotChecked=true;
                [self checkLeftOfDot:dotLeft onTile:tile];
                [self checkAboveDot:dotLeft onTile:tile];
                [self checkBelowDot:dotLeft onTile:tile];
            }
        }
        else if (dot.dotY==0 && tile.tileY==0) {
            [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotY==0 && tile.tileY!=0){
            Tile* tileLeft=_gridArray[tile.tileX][tile.tileY-1];
            if (tileLeft.tileRotation==0) {
                Dot* dotLeft=tileLeft.tileArray[dot.dotX][2];
                if (dot.DotColor==dotLeft.DotColor) {
                    matchHorizontally+=1;
                    [self checkLeftOfDot:dotLeft onTile:tileLeft];
                }
                else if (dot.DotColor!=dotLeft.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileLeft.tileRotation==1){
                if (dot.dotX==0) {
                    Dot* dotLeft=tileLeft.tileArray[2][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotLeft=tileLeft.tileArray[2][1];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotLeft=tileLeft.tileArray[2][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotLeft=tileLeft.tileArray[1][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotLeft=tileLeft.tileArray[2][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotLeft=tileLeft.tileArray[1][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotLeft=tileLeft.tileArray[0][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                if (dotLeft.dotChecked==false) {
                    dotLeft.dotChecked=true;
                    [self checkAboveDot:dotLeft onTile:tile];
                    [self checkBelowDot:dotLeft onTile:tile];
                }
            }
            else if(dot.DotColor!=dotLeft.DotColor && tile==tileRotated && dotLeft.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotLeft.dotChecked=true;
                [self checkLeftOfDot:dotLeft onTile:tile];
                [self checkAboveDot:dotLeft onTile:tile];
                [self checkBelowDot:dotLeft onTile:tile];
            }
        }
        else if (dot.dotX==0 && tile.tileY==0){
            [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotX==0 && tile.tileY!=0){
            Tile* tileLeft=_gridArray[tile.tileX][tile.tileY-1];

            if (tileLeft.tileRotation==0) {
                if (dot.dotY==0){
                    Dot* dotLeft=tileLeft.tileArray[2][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotLeft=tileLeft.tileArray[1][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotLeft=tileLeft.tileArray[0][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
            }
            else if (tileLeft.tileRotation==1){
                Dot* dotLeft=tileLeft.tileArray[2][dot.dotY];
                if (dot.DotColor==dotLeft.DotColor) {
                    matchHorizontally+=1;
                    [self checkLeftOfDot:dotLeft onTile:tileLeft];
                }
                else if (dot.DotColor!=dotLeft.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileLeft.tileRotation==2){
                Dot* dotLeft=tileLeft.tileArray[dot.dotY][dot.dotX];
                if (dot.DotColor==dotLeft.DotColor) {
                    matchHorizontally+=1;
                    [self checkLeftOfDot:dotLeft onTile:tileLeft];
                }
                else if (dot.DotColor!=dotLeft.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileLeft.tileRotation==3){
                if (dot.dotY==0){
                    Dot* dotLeft=tileLeft.tileArray[0][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotLeft=tileLeft.tileArray[0][1];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotLeft=tileLeft.tileArray[0][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                if (dotLeft.dotChecked==false) {
                    dotLeft.dotChecked=true;
                    [self checkAboveDot:dotLeft onTile:tile];
                    [self checkBelowDot:dotLeft onTile:tile];
                }
            }
            else if(dot.DotColor!=dotLeft.DotColor && tile==tileRotated && dotLeft.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotLeft.dotChecked=true;
                [self checkLeftOfDot:dotLeft onTile:tile];
                [self checkAboveDot:dotLeft onTile:tile];
                [self checkBelowDot:dotLeft onTile:tile];
            }
        }
        else if (dot.dotY==2 && tile.tileY==0){
            [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotY==2 && tile.tileY!=0){
            Tile* tileLeft=_gridArray[tile.tileX][tile.tileY-1];

            if (tileLeft.tileRotation==0) {
                if (dot.dotX==0){
                    Dot* dotLeft=tileLeft.tileArray[2][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotLeft=tileLeft.tileArray[1][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotLeft=tileLeft.tileArray[0][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
            }
            else if (tileLeft.tileRotation==1){
                Dot* dotLeft=tileLeft.tileArray[2][dot.dotX];
                if (dot.DotColor==dotLeft.DotColor) {
                    matchHorizontally+=1;
                    [self checkLeftOfDot:dotLeft onTile:tileLeft];
                }
                else if (dot.DotColor!=dotLeft.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileLeft.tileRotation==2){
                Dot* dotLeft=tileLeft.tileArray[dot.dotX][0];
                if (dot.DotColor==dotLeft.DotColor) {
                    matchHorizontally+=1;
                    [self checkLeftOfDot:dotLeft onTile:tileLeft];
                }
                else if (dot.DotColor!=dotLeft.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileLeft.tileRotation==3){
                if (dot.dotX==0){
                    Dot* dotLeft=tileLeft.tileArray[0][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotLeft=tileLeft.tileArray[0][1];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotLeft=tileLeft.tileArray[0][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                if (dotLeft.dotChecked==false) {
                    dotLeft.dotChecked=true;
                    [self checkAboveDot:dotLeft onTile:tile];
                    [self checkBelowDot:dotLeft onTile:tile];
                }
            }
            else if(dot.DotColor!=dotLeft.DotColor && tile==tileRotated && dotLeft.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotLeft.dotChecked=true;
                [self checkLeftOfDot:dotLeft onTile:tile];
                [self checkAboveDot:dotLeft onTile:tile];
                [self checkBelowDot:dotLeft onTile:tile];
            }
        }
        else if (dot.dotX==2 && tile.tileY==0){
            [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotX==2 && tile.tileY!=0){
            Tile* tileLeft=_gridArray[tile.tileX][tile.tileY-1];
            
            if (tileLeft.tileRotation==0) {
                Dot* dotLeft=tileLeft.tileArray[dot.dotY][2];
                if (dot.DotColor==dotLeft.DotColor) {
                    matchHorizontally+=1;
                    [self checkLeftOfDot:dotLeft onTile:tileLeft];
                }
                else if (dot.DotColor!=dotLeft.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileLeft.tileRotation==1){
                if (dot.dotY==0) {
                    Dot* dotLeft=tileLeft.tileArray[2][2];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotLeft=tileLeft.tileArray[2][1];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotLeft=tileLeft.tileArray[2][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotLeft=tileLeft.tileArray[1][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotLeft=tileLeft.tileArray[0][0];
                    if (dot.DotColor==dotLeft.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotLeft onTile:tileLeft];
                    }
                    else if (dot.DotColor!=dotLeft.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }

            }
            else if (tileLeft.tileRotation==3){
                Dot* dotLeft=tileLeft.tileArray[0][dot.dotY];
                if (dot.DotColor==dotLeft.DotColor) {
                    matchHorizontally+=1;
                    [self checkLeftOfDot:dotLeft onTile:tileLeft];
                }
                else if (dot.DotColor!=dotLeft.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
        }
    }
    [self checkMoveOnTile:tile];
}

-(void)checkRightOfDot:(Dot*)dot onTile:(Tile*)tile{
   // NSLog(@"right called");
    if (tile.tileRotation==0){
        if (dot.dotY!=2){
            Dot* dotRight=tile.tileArray[dot.dotX][dot.dotY+1];
            if (dot.DotColor==dotRight.DotColor){
                matchHorizontally+=1;
                [self checkRightOfDot:dotRight onTile:tile];
                if (dotRight.dotChecked==false) {
                    dotRight.dotChecked=true;
                    [self checkAboveDot:dotRight onTile:tile];
                    [self checkBelowDot:dotRight onTile:tile];
                }
            }
            else if(dot.DotColor!=dotRight.DotColor && tile==tileRotated && dotRight.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotRight.dotChecked=true;
                [self checkRightOfDot:dotRight onTile:tile];
                [self checkAboveDot:dotRight onTile:tile];
                [self checkBelowDot:dotRight onTile:tile];
            }
        }
        else if (dot.dotY==2 && tile.tileY==2){
            [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotY==2 && tile.tileY!=2){
            Tile* tileRight=_gridArray[tile.tileX][tile.tileY+1];
            if (tileRight.tileRotation==0) {
                Dot* dotRight=tileRight.tileArray[dot.dotX][0];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
                else if (dot.DotColor!=dotRight.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileRight.tileRotation==1){
                if (dot.dotX==0) {
                    Dot* dotRight=tileRight.tileArray[0][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkLeftOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotRight=tileRight.tileArray[0][1];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotRight=tileRight.tileArray[0][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotRight=tileRight.tileArray[1][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotRight=tileRight.tileArray[0][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
            }
            else if (tileRight.tileRotation==3){
                Dot* dotRight=tileRight.tileArray[2][dot.dotX];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
                else if (dot.DotColor!=dotRight.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
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
                if (dotRight.dotChecked==false) {
                    dotRight.dotChecked=true;
                    [self checkAboveDot:dotRight onTile:tile];
                    [self checkBelowDot:dotRight onTile:tile];
                }
            }
            else if(dot.DotColor!=dotRight.DotColor && tile==tileRotated && dotRight.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotRight.dotChecked=true;
                [self checkRightOfDot:dotRight onTile:tile];
                [self checkAboveDot:dotRight onTile:tile];
                [self checkBelowDot:dotRight onTile:tile];
            }
        }
        else if (dot.dotX==2 && tile.tileY==2){
           [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotX==2 && tile.tileY!=2){
            Tile* tileRight=_gridArray[tile.tileX][tile.tileY+1];
            
            if (tileRight.tileRotation==0) {
                if (dot.dotY==0){
                    Dot* dotRight=tileRight.tileArray[2][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotRight=tileRight.tileArray[1][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotRight=tileRight.tileArray[0][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
            }
            else if (tileRight.tileRotation==1){
                Dot* dotRight=tileRight.tileArray[0][dot.dotY];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
                else if (dot.DotColor!=dotRight.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileRight.tileRotation==2){
                Dot* dotRight=tileRight.tileArray[dot.dotY][2];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
                else if (dot.DotColor!=dotRight.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileRight.tileRotation==3){
                if (dot.dotY==0){
                    Dot* dotRight=tileRight.tileArray[2][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotRight=tileRight.tileArray[2][1];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotRight=tileRight.tileArray[2][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                if (dotRight.dotChecked==false) {
                    dotRight.dotChecked=true;
                    [self checkAboveDot:dotRight onTile:tile];
                    [self checkBelowDot:dotRight onTile:tile];
                }
            }
            else if(dot.DotColor!=dotRight.DotColor && tile==tileRotated && dotRight.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotRight.dotChecked=true;
                [self checkRightOfDot:dotRight onTile:tile];
                [self checkAboveDot:dotRight onTile:tile];
                [self checkBelowDot:dotRight onTile:tile];
            }
        }
        else if (dot.dotY==0 && tile.tileY==2){
            [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotY==0 && tile.tileY!=2){
            Tile* tileRight=_gridArray[tile.tileX][tile.tileY+1];
            
            if (tileRight.tileRotation==0) {
                if (dot.dotX==0){
                    Dot* dotRight=tileRight.tileArray[2][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotRight=tileRight.tileArray[1][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotRight=tileRight.tileArray[0][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
            }
            else if (tileRight.tileRotation==1){
                Dot* dotRight=tileRight.tileArray[0][dot.dotX];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
                else if (dot.DotColor!=dotRight.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileRight.tileRotation==2){
                Dot* dotRight=tileRight.tileArray[dot.dotX][2];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
                else if (dot.DotColor!=dotRight.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileRight.tileRotation==3){
                if (dot.dotX==0){
                    Dot* dotRight=tileRight.tileArray[2][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotRight=tileRight.tileArray[2][1];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotRight=tileRight.tileArray[2][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                if (dotRight.dotChecked==false) {
                    dotRight.dotChecked=true;
                    [self checkAboveDot:dotRight onTile:tile];
                    [self checkBelowDot:dotRight onTile:tile];
                }
            }
            else if(dot.DotColor!=dotRight.DotColor && tile==tileRotated && dotRight.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotRight.dotChecked=true;
                [self checkRightOfDot:dotRight onTile:tile];
                [self checkAboveDot:dotRight onTile:tile];
                [self checkBelowDot:dotRight onTile:tile];
            }
        }
        else if (dot.dotX==0 && tile.tileY==2){
            [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotX==0 && tile.tileY!=2){
            Tile* tileRight=_gridArray[tile.tileX][tile.tileY+1];
            
            if (tileRight.tileRotation==0) {
                Dot* dotRight=tileRight.tileArray[dot.dotY][0];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
                else if (dot.DotColor!=dotRight.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileRight.tileRotation==1){
                if (dot.dotY==0) {
                    Dot* dotRight=tileRight.tileArray[0][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotRight=tileRight.tileArray[0][1];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotRight=tileRight.tileArray[0][0];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotRight=tileRight.tileArray[1][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotRight=tileRight.tileArray[0][2];
                    if (dot.DotColor==dotRight.DotColor) {
                        matchHorizontally+=1;
                        [self checkRightOfDot:dotRight onTile:tileRight];
                    }
                    else if (dot.DotColor!=dotRight.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
            }
            else if (tileRight.tileRotation==3){
                Dot* dotRight=tileRight.tileArray[2][dot.dotY];
                if (dot.DotColor==dotRight.DotColor) {
                    matchHorizontally+=1;
                    [self checkRightOfDot:dotRight onTile:tileRight];
                }
                else if (dot.DotColor!=dotRight.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
        }
    }
    [self checkMoveOnTile:tile];
}


-(void)checkAboveDot:(Dot*)dot onTile:(Tile*)tile{
    //NSLog(@"above called");
    if (tile.tileRotation==0){
        if (dot.dotX!=2){
            Dot* dotUp=tile.tileArray[dot.dotX+1][dot.dotY];
            if (dot.DotColor==dotUp.DotColor){
                matchVertically+=1;
                [self checkAboveDot:dotUp onTile:tile];
                if (dotUp.dotChecked==false) {
                    dotUp.dotChecked=true;
                    [self checkLeftOfDot:dotUp onTile:tile];
                    [self checkRightOfDot:dotUp onTile:tile];
                }
            }
            else if(dot.DotColor!=dotUp.DotColor && tile==tileRotated && dotUp.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotUp.dotChecked=true;
                [self checkRightOfDot:dotUp onTile:tile];
                [self checkAboveDot:dotUp onTile:tile];
                [self checkLeftOfDot:dotUp onTile:tile];
            }
        }
        else if (dot.dotX==2 && tile.tileX==2){
           [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotX==2 && tile.tileX!=2){
            Tile* tileUp=_gridArray[tile.tileX+1][tile.tileY];
            if (tileUp.tileRotation==0) {
                Dot* dotUp=tileUp.tileArray[0][dot.dotY];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
                else if (dot.DotColor!=dotUp.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileUp.tileRotation==1){
                Dot* dotUp=tileUp.tileArray[dot.dotY][2];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
                else if (dot.DotColor!=dotUp.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileUp.tileRotation==2){
                if (dot.dotY==0) {
                    Dot* dotUp=tileUp.tileArray[2][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotUp=tileUp.tileArray[2][1];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotUp=tileUp.tileArray[2][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotUp=tileUp.tileArray[1][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotUp=tileUp.tileArray[0][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                if (dotUp.dotChecked==false) {
                    dotUp.dotChecked=true;
                    [self checkLeftOfDot:dotUp onTile:tile];
                    [self checkRightOfDot:dotUp onTile:tile];
                }
            }
            else if(dot.DotColor!=dotUp.DotColor && tile==tileRotated && dotUp.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotUp.dotChecked=true;
                [self checkRightOfDot:dotUp onTile:tile];
                [self checkAboveDot:dotUp onTile:tile];
                [self checkLeftOfDot:dotUp onTile:tile];
            }
        }
        else if (dot.dotY==0 && tile.tileX==2){
            [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotY==0 && tile.tileX!=2){
            Tile* tileUp=_gridArray[tile.tileX+1][tile.tileY];
            
            if (tileUp.tileRotation==0) {
                Dot* dotUp=tileUp.tileArray[0][dot.dotX];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
                else if (dot.DotColor!=dotUp.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileUp.tileRotation==1){
                Dot* dotUp=tileUp.tileArray[dot.dotX][2];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
                else if (dot.DotColor!=dotUp.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileUp.tileRotation==2){
                if (dot.dotX==0) {
                    Dot* dotUp=tileUp.tileArray[2][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotUp=tileUp.tileArray[2][1];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotUp=tileUp.tileArray[2][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotUp=tileUp.tileArray[1][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotUp=tileUp.tileArray[0][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                if (dotUp.dotChecked==false) {
                    dotUp.dotChecked=true;
                    [self checkLeftOfDot:dotUp onTile:tile];
                    [self checkRightOfDot:dotUp onTile:tile];
                }
            }
            else if(dot.DotColor!=dotUp.DotColor && tile==tileRotated && dotUp.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotUp.dotChecked=true;
                [self checkRightOfDot:dotUp onTile:tile];
                [self checkAboveDot:dotUp onTile:tile];
                [self checkLeftOfDot:dotUp onTile:tile];
            }
        }
        else if (dot.dotX==0 && tile.tileX==2){
            [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotX==0 && tile.tileX!=2){
            Tile* tileUp=_gridArray[tile.tileX+1][tile.tileY];
            
            if (tileUp.tileRotation==0) {
                if (dot.dotY==0){
                    Dot* dotUp=tileUp.tileArray[0][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotUp=tileUp.tileArray[0][1];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotUp=tileUp.tileArray[0][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotUp=tileUp.tileArray[1][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotUp=tileUp.tileArray[0][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
            }
            else if (tileUp.tileRotation==2){
                Dot* dotUp=tileUp.tileArray[2][dot.dotY];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
                else if (dot.DotColor!=dotUp.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileUp.tileRotation==3){
                Dot* dotUp=tileUp.tileArray[dot.dotY][0];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
                else if (dot.DotColor!=dotUp.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
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
                if (dotUp.dotChecked==false) {
                    dotUp.dotChecked=true;
                    [self checkLeftOfDot:dotUp onTile:tile];
                    [self checkRightOfDot:dotUp onTile:tile];
                }
            }
            else if(dot.DotColor!=dotUp.DotColor && tile==tileRotated && dotUp.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotUp.dotChecked=true;
                [self checkRightOfDot:dotUp onTile:tile];
                [self checkAboveDot:dotUp onTile:tile];
                [self checkLeftOfDot:dotUp onTile:tile];
            }
        }
        else if (dot.dotY==2 && tile.tileX==2){
            [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotY==2 && tile.tileX!=2){
            Tile* tileUp=_gridArray[tile.tileX+1][tile.tileY];

            if (tileUp.tileRotation==0) {
                if (dot.dotX==0) {
                    Dot* dotUp=tileUp.tileArray[0][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotUp=tileUp.tileArray[0][1];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotUp=tileUp.tileArray[0][0];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotUp=tileUp.tileArray[1][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotUp=tileUp.tileArray[0][2];
                    if (dot.DotColor==dotUp.DotColor) {
                        matchVertically+=1;
                        [self checkAboveDot:dotUp onTile:tileUp];
                    }
                    else if (dot.DotColor!=dotUp.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
            }
            else if (tileUp.tileRotation==2){
                Dot* dotUp=tileUp.tileArray[2][dot.dotX];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
                else if (dot.DotColor!=dotUp.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileUp.tileRotation==3){
                Dot* dotUp=tileUp.tileArray[dot.dotX][0];
                if (dot.DotColor==dotUp.DotColor) {
                    matchVertically+=1;
                    [self checkAboveDot:dotUp onTile:tileUp];
                }
                else if (dot.DotColor!=dotUp.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
        }
    }
    [self checkMoveOnTile:tile];
}


-(void)checkBelowDot:(Dot*)dot onTile:(Tile*)tile{
    //NSLog(@"below called");
    if (tile.tileRotation==0){
        if (dot.dotX!=0){
            Dot* dotDown=tile.tileArray[dot.dotX-1][dot.dotY];
            if (dot.DotColor==dotDown.DotColor){
                matchVertically+=1;
                [self checkBelowDot:dotDown onTile:tile];
                if (dotDown.dotChecked==false) {
                    dotDown.dotChecked=true;
                    [self checkLeftOfDot:dotDown onTile:tile];
                    [self checkRightOfDot:dotDown onTile:tile];
                }
            }
            else if(dot.DotColor!=dotDown.DotColor && tile==tileRotated && dotDown.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotDown.dotChecked=true;
                [self checkRightOfDot:dotDown onTile:tile];
                [self checkBelowDot:dotDown onTile:tile];
                [self checkLeftOfDot:dotDown onTile:tile];
            }
        }
        else if (dot.dotX==0 && tile.tileX==0){
            [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotX==0 && tile.tileX!=0){
            Tile* tileDown=_gridArray[tile.tileX-1][tile.tileY];
            if (tileDown.tileRotation==0) {
                Dot* dotDown=tileDown.tileArray[2][dot.dotY];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
                else if (dot.DotColor!=dotDown.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileDown.tileRotation==1){
                Dot* dotDown=tileDown.tileArray[0][dot.dotX];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
                else if (dot.DotColor!=dotDown.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileDown.tileRotation==2){
                if (dot.dotY==0) {
                    Dot* dotDown=tileDown.tileArray[0][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotDown=tileDown.tileArray[0][1];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotDown=tileDown.tileArray[0][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotDown=tileDown.tileArray[1][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotDown=tileDown.tileArray[2][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                if (dotDown.dotChecked==false) {
                    dotDown.dotChecked=true;
                    [self checkLeftOfDot:dotDown onTile:tile];
                    [self checkRightOfDot:dotDown onTile:tile];
                }
            }
            else if(dot.DotColor!=dotDown.DotColor && tile==tileRotated && dotDown.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotDown.dotChecked=true;
                [self checkRightOfDot:dotDown onTile:tile];
                [self checkBelowDot:dotDown onTile:tile];
                [self checkLeftOfDot:dotDown onTile:tile];
            }
        }
        else if (dot.dotY==2 && tile.tileX==0){
            [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotY==2 && tile.tileX!=0){
            Tile* tileDown=_gridArray[tile.tileX-1][tile.tileY];

            if (tileDown.tileRotation==0) {
                Dot* dotDown=tileDown.tileArray[2][dot.dotX];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
                else if (dot.DotColor!=dotDown.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileDown.tileRotation==1){
                Dot* dotDown=tileDown.tileArray[dot.dotX][0];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
                else if (dot.DotColor!=dotDown.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileDown.tileRotation==2){
                if (dot.dotX==0) {
                    Dot* dotDown=tileDown.tileArray[0][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotDown=tileDown.tileArray[0][1];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotDown=tileDown.tileArray[0][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotDown=tileDown.tileArray[1][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotDown=tileDown.tileArray[0][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                if (dotDown.dotChecked==false) {
                    dotDown.dotChecked=true;
                    [self checkLeftOfDot:dotDown onTile:tile];
                    [self checkRightOfDot:dotDown onTile:tile];
                }
            }
            else if(dot.DotColor!=dotDown.DotColor && tile==tileRotated && dotDown.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotDown.dotChecked=true;
                [self checkRightOfDot:dotDown onTile:tile];
                [self checkBelowDot:dotDown onTile:tile];
                [self checkLeftOfDot:dotDown onTile:tile];
            }
        }
        else if (dot.dotX==2 && tile.tileX==0){
            [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotX==2 && tile.tileX!=0){
            Tile* tileDown=_gridArray[tile.tileX-1][tile.tileY];

            if (tileDown.tileRotation==0) {
                if (dot.dotY==0){
                    Dot* dotDown=tileDown.tileArray[2][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotDown=tileDown.tileArray[2][1];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotDown=tileDown.tileArray[2][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==1){
                    Dot* dotDown=tileDown.tileArray[1][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotY==2){
                    Dot* dotDown=tileDown.tileArray[0][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
            }
            else if (tileDown.tileRotation==2){
                Dot* dotDown=tileDown.tileArray[0][dot.dotY];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
                else if (dot.DotColor!=dotDown.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileDown.tileRotation==3){
                Dot* dotDown=tileDown.tileArray[dot.dotY][2];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
                else if (dot.DotColor!=dotDown.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
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
                if (dotDown.dotChecked==false) {
                    dotDown.dotChecked=true;
                    [self checkLeftOfDot:dotDown onTile:tile];
                    [self checkRightOfDot:dotDown onTile:tile];
                }
            }
            else if(dot.DotColor!=dotDown.DotColor && tile==tileRotated && dotDown.dotChecked==false){
                [self addToMatchArray:matchHorizontally and:matchVertically];
                dotDown.dotChecked=true;
                [self checkRightOfDot:dotDown onTile:tile];
                [self checkBelowDot:dotDown onTile:tile];
                [self checkLeftOfDot:dotDown onTile:tile];
            }
        }
        else if (dot.dotY==0 && tile.tileX==0){
            [self addToMatchArray:matchHorizontally and:matchVertically];
        }
        else if (dot.dotY==0 && tile.tileX!=0){
            Tile* tileDown=_gridArray[tile.tileX-1][tile.tileY];

            if (tileDown.tileRotation==0) {
                if (dot.dotX==0) {
                    Dot* dotDown=tileDown.tileArray[2][2];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotDown=tileDown.tileArray[2][1];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotDown=tileDown.tileArray[2][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
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
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==1){
                    Dot* dotDown=tileDown.tileArray[1][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
                else if (dot.dotX==2){
                    Dot* dotDown=tileDown.tileArray[0][0];
                    if (dot.DotColor==dotDown.DotColor) {
                        matchVertically+=1;
                        [self checkBelowDot:dotDown onTile:tileDown];
                    }
                    else if (dot.DotColor!=dotDown.DotColor){
                        [self addToMatchArray:matchHorizontally and:matchVertically];
                    }
                }
            }
            else if (tileDown.tileRotation==2){
                Dot* dotDown=tileDown.tileArray[0][dot.dotX];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
                else if (dot.DotColor!=dotDown.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
            else if (tileDown.tileRotation==3){
                Dot* dotDown=tileDown.tileArray[dot.dotX][2];
                if (dot.DotColor==dotDown.DotColor) {
                    matchVertically+=1;
                    [self checkBelowDot:dotDown onTile:tileDown];
                }
                else if (dot.DotColor!=dotDown.DotColor){
                    [self addToMatchArray:matchHorizontally and:matchVertically];
                }
            }
        }
    }

    [self checkMoveOnTile:tile];
}

-(void)addToMatchArray:(int)matchHorizontal and:(int)matchVertical{
    if (matchVertical>=4) {
        [_matchArray addObject:[NSNumber numberWithInt:matchVertical]];
    }
    if (matchHorizontally>=4) {
        [_matchArray addObject:[NSNumber numberWithInt:matchHorizontal]];
    }
    matchHorizontally=1;
    matchVertically=1;
}

-(void)checkMoveOnTile:(Tile*)tile{
    int dotsChecked=0;
    for (int x=0; x<3; x++) {
        for (int y=0; y<3; y++) {
            Dot* dot=tile.tileArray[x][y];
            if (dot.dotChecked==true) {
                dotsChecked+=1;
            }
        }
    }
    if (dotsChecked==9 && [_matchArray count]>0) {
        [self calculateScore];
    };
    NSLog(@"%@", _matchArray);
}

-(void)calculateScore{
    for (int x=0; x<[_matchArray count]; x++) {
        int addOn=[(NSNumber *)[_matchArray objectAtIndex:x] intValue];
        score+=addOn;
    }
    
    [self.gameplay addScore:score];
    NSLog(@"%i", score);
    score=0;
}
        
@end

