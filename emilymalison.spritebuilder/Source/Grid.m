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
    //NSMutableArray *_gridArray;
    Tile *tileRotated;
    Tile *indicatedTile;
    int score;
    BOOL possibleMatch;
    NSMutableArray *_tileMatchArray;
    BOOL moveIndicated;
    CCTimer* indicateTimer;
}

- (void)onEnter
{
    [super onEnter];
    possibleMatch=NO;
    
    [self setUpGrid];
    
    moveIndicated=NO;
}


#pragma mark - Filling Grid with Tiles

-(void)setUpGrid{
    
    self.gridArray=[NSMutableArray array];
    
    _columnWidth=(self.contentSize.width/GRID_SIZE);
    _columnHeight=(self.contentSize.height/GRID_SIZE);
    
    _tileMarginVertical=(_columnWidth/2);
    _tileMarginHorizontal=(_columnHeight/2);
    
    float x=_tileMarginHorizontal;
    float y=_tileMarginVertical;
    
    for (int i=0; i<GRID_SIZE; i++) {
        
        x=_tileMarginHorizontal;
        self.gridArray[i]=[NSMutableArray array];
        
        
        for (int j=0; j<GRID_SIZE; j++) {
            Tile *tile= (Tile*)[CCBReader load:@"Tile"];
            
            [tile setScaleX:((_columnWidth)/tile.contentSize.width)];
            [tile setScaleY:((_columnHeight)/tile.contentSize.height)];
            
            [self addChild:tile];
            //tile.contentSize = CGSizeMake(_columnWidth, _columnHeight);
			tile.position = ccp(x, y);
            self.gridArray[i][j]=tile;
            tile.tileX=i;
            tile.tileY=j;
            
			x+= _columnWidth;
		}
		y += _columnHeight;
    }
    [self checkHorizontallyTile:self.gridArray[0][0]];
    [self checkHorizontallyTile:self.gridArray[1][0]];
    [self checkHorizontallyTile:self.gridArray[2][0]];
    [self checkVerticallyTile:self.gridArray[0][0]];
    [self checkVerticallyTile:self.gridArray[0][1]];
    [self checkVerticallyTile:self.gridArray[0][2]];
    [self checkForMoves];
}

#pragma mark - Checking for Matches

-(void)checkTile:(Tile *)rotatedTile{
    int match;
    BOOL firstDot;
    for (int j=0; j<3; j++) {
        match=1;
        firstDot=true;
        for (int i=-2; i<GRID_SIZE; i++) {
            if (rotatedTile.tileY+i>=0 && rotatedTile.tileY+i<=2) {
                Tile* currentTile=self.gridArray[rotatedTile.tileX][rotatedTile.tileY+i];
                for (int k=0; k<3; k++) {
                    if (!firstDot){
                        if (k!=0) {
                            if (currentTile.dotColorArray[j][k]==currentTile.dotColorArray[j][k-1]) {
                                match++;
                                if (match>=5) {
                                    currentTile.remove=true;
                                    Tile* tileBefore=self.gridArray[currentTile.tileX][currentTile.tileY-1];
                                    tileBefore.remove=true;
                                    if (match==5) {
                                        score+=5;
                                    }
                                    else if (match>5){
                                        score+=1;
                                    }
                                }

                            }
                            else{
                                match=1;
                            }
                        }
                        else if (k==0){
                            Tile* tileBefore=self.gridArray[currentTile.tileX][currentTile.tileY-1];
                            if (currentTile.dotColorArray[j][k]==tileBefore.dotColorArray[j][2]) {
                                match++;
                                if (match>=5) {
                                    currentTile.remove=true;
                                    tileBefore.remove=true;
                                    if (match==5) {
                                        score+=5;
                                    }
                                    else if (match>5){
                                        score+=1;
                                    }
                                }
                            }
                            else{
                                match=1;
                            }
                        }
                    }
                    else{
                        firstDot=false;
                    }
                }
            }
        }
    }
    
    for (int j=0; j<3; j++) {
        match=1;
        firstDot=true;
        for (int i=-2; i<GRID_SIZE; i++) {
            if (rotatedTile.tileX+i>=0 && rotatedTile.tileX+i<=2) {
                Tile* currentTile=self.gridArray[rotatedTile.tileX+i][rotatedTile.tileY];
                for (int k=0; k<3; k++) {
                    if (!firstDot) {
                        if (k!=0) {
                            if (currentTile.dotColorArray[k][j]==currentTile.dotColorArray[k-1][j]) {
                                match++;
                                if (match>=5) {
                                    currentTile.remove=true;
                                    Tile* tileBefore=self.gridArray[currentTile.tileX-1][currentTile.tileY];
                                    tileBefore.remove=true;
                                    if (match==5) {
                                        score+=5;
                                    }
                                    else if (match>5){
                                        score+=1;
                                    }
                                }
                            }
                            else{
                                match=1;
                            }
                        }
                        else if (k==0){
                            Tile* tileBefore=self.gridArray[currentTile.tileX-1][currentTile.tileY];
                            if (currentTile.dotColorArray[k][j]==tileBefore.dotColorArray[2][j]) {
                                match++;
                                if (match>=5) {
                                    currentTile.remove=true;
                                    tileBefore.remove=true;
                                    if (match==5) {
                                        score+=5;
                                    }
                                    else if (match>5){
                                        score+=1;
                                    }
                                }
                            }
                            else{
                                match=1;
                            }
                        }
                    }
                    else{
                        firstDot=false;
                    }
                }
            }
        }
    }
    _totalScore=score;
    CCTimer* myTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(removeTiles) userInfo:nil repeats:NO];
}

#pragma mark - Remove Tiles

-(void)removeTiles{
    BOOL removed=NO;
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            Tile* tile=self.gridArray[i][j];
            if (tile.remove==true) {
                removed=YES;
                tile.remove=false;
                [self removeChild:tile];
                
                Tile* newTile= (Tile*)[CCBReader load:@"Tile"];
                 
                [newTile setScaleX:((_columnWidth)/tile.contentSize.width)];
                [newTile setScaleY:((_columnHeight)/tile.contentSize.height)];
                
                newTile.position = tile.position;
                self.gridArray[i][j]=newTile;
                newTile.tileX=tile.tileX;
                newTile.tileY=tile.tileY;
                newTile.remove=false;
                
                [self addChild: newTile];
                if (tile.checking==NO) {
                    [self checkTile:newTile];

                }
                else if (tile.checking==YES){
                    tile.checking=NO;
                    [self checkVerticallyTile:newTile];
                    [self checkHorizontallyTile:newTile];
                }
            }
        }
    }
    if (removed==YES) {
        [self checkForMoves];
    }
}

#pragma mark - Checking Original Grid For Matches

-(void)checkHorizontallyTile:(Tile*)tile{
    int match;
    BOOL firstDot;
    for (int j=0; j<3; j++) {
        match=1;
        firstDot=true;
        for (int i=-2; i<3; i++) {
            if (tile.tileY+i>=0 && tile.tileY+i<=2) {
                Tile* currentTile=self.gridArray[tile.tileX][tile.tileY+i];
                for (int k=0; k<3; k++) {
                    if (!firstDot){
                        if (k!=0) {
                            if (currentTile.dotColorArray[j][k]==currentTile.dotColorArray[j][k-1]) {
                                match++;
                                if (match>=5) {
                                    [currentTile rotateBackwards];
                                    match=1;
                                }
                            }
                            else{
                                match=1;
                            }
                        }
                        else if (k==0){
                            Tile* tileBefore=self.gridArray[currentTile.tileX][currentTile.tileY-1];
                            if (currentTile.dotColorArray[j][k]==tileBefore.dotColorArray[j][2]) {
                                match++;
                                if (match>=5) {
                                    [currentTile rotateBackwards];
                                    match=1;
                                }
                            }
                            else{
                                match=1;
                            }
                        }
                    }
                    else{
                        firstDot=false;
                    }
                }
            }
        }
    }
}

-(void)checkVerticallyTile:(Tile*)tile{
    int match;
    BOOL firstDot;
    for (int j=0; j<3; j++) {
        match=1;
        firstDot=true;
        for (int i=-2; i<3; i++) {
            if (tile.tileX+i>=0 && tile.tileX+i<=2) {
                Tile* currentTile=self.gridArray[tile.tileX+i][tile.tileY];
                for (int k=0; k<3; k++) {
                    if (!firstDot) {
                        if (k!=0) {
                            if (currentTile.dotColorArray[k][j]==currentTile.dotColorArray[k-1][j]) {
                                match++;
                                if (match>=5) {
                                    [currentTile rotateBackwards];
                                    match=1;
                                }
                            }
                            else{
                                match=1;
                            }
                        }
                        else if (k==0){
                            Tile* tileBefore=self.gridArray[currentTile.tileX-1][currentTile.tileY];
                            if (currentTile.dotColorArray[k][j]==tileBefore.dotColorArray[2][j]) {
                                match++;
                                if (match>=5) {
                                    [currentTile rotateBackwards];
                                    match=1;
                                }
                            }
                            else{
                                match=1;
                            }
                        }
                    }
                    else{
                        firstDot=false;
                    }
                }
            }
        }
    }
}

#pragma mark - Checking For Possible Moves

-(void)checkForMoves{
    _tileMatchArray=[NSMutableArray array];
     for (int x=0; x<GRID_SIZE; x++) {
        for (int y=0; y<GRID_SIZE; y++){
            Tile* tile=self.gridArray[x][y];
            tile.match=NO;
            for (int z=1; z<4; z++) {
                tile.dotColorArrayCopy=[tile rotateColorMatrix:tile.dotColorArrayCopy];
                int match;
                BOOL firstDot;
                for (int j=0; j<3; j++) {
                    match=1;
                    firstDot=true;
                    for (int i=-2; i<GRID_SIZE; i++){
                        if (tile.tileY+i>=0 && tile.tileY+i<=2) {
                            Tile* currentTile=self.gridArray[tile.tileX][tile.tileY+i];
                            NSMutableArray *currentTileArray=currentTile.dotColorArray;
                            if (currentTile==tile) {
                                currentTileArray=currentTile.dotColorArrayCopy;
                            }
                            for (int k=0; k<3; k++) {
                                if (!firstDot){
                                    if (k!=0) {
                                        if (currentTileArray[j][k]==currentTileArray[j][k-1]) {
                                            match++;
                                            if (match>=5) {
                                                possibleMatch=YES;
                                                tile.match=YES;
                                            }
                                        }
                                        else{
                                            match=1;
                                        }
                                    }
                                    else if (k==0){
                                        Tile* tileBefore=self.gridArray[currentTile.tileX][currentTile.tileY-1];
                                        NSMutableArray *tileBeforeArray=tileBefore.dotColorArray;
                                        if (tileBefore==tile) {
                                            tileBeforeArray=tileBefore.dotColorArrayCopy;
                                        }
                                        if (currentTileArray[j][k]==tileBeforeArray[j][2]) {
                                            match++;
                                            if (match>=5) {
                                                possibleMatch=YES;
                                                tile.match=YES;
                                            }
                                        }
                                        else{
                                            match=1;
                                        }
                                    }
                                }
                                else{
                                    firstDot=false;
                                }
                            }
                        }
                    }
                }
                
                for (int j=0; j<3; j++) {
                    match=1;
                    firstDot=true;
                    for (int i=-2; i<GRID_SIZE; i++) {
                        if (tile.tileX+i>=0 && tile.tileX+i<=2) {
                            Tile* currentTile=self.gridArray[tile.tileX+i][tile.tileY];
                            NSMutableArray *currentTileArray=currentTile.dotColorArray;
                            if (currentTile==tile) {
                                currentTileArray=currentTile.dotColorArrayCopy;
                            }
                            for (int k=0; k<3; k++) {
                                if (!firstDot) {
                                    if (k!=0) {
                                        if (currentTileArray[k][j]==currentTileArray[k-1][j]) {
                                            match++;
                                            if (match>=5) {
                                                possibleMatch=YES;
                                                tile.match=YES;
                                            }
                                        }
                                        else{
                                            match=1;
                                        }
                                    }
                                    else if (k==0){
                                        Tile* tileBefore=self.gridArray[currentTile.tileX-1][currentTile.tileY];
                                        NSMutableArray *tileBeforeArray=tileBefore.dotColorArray;
                                        if (tileBefore==tile) {
                                            tileBeforeArray=tileBefore.dotColorArrayCopy;
                                        }
                                        if (currentTileArray[k][j]==tileBeforeArray[2][j]) {
                                            match++;
                                            if (match>=5) {
                                                possibleMatch=YES;
                                                tile.match=YES;
                                            }
                                        }
                                        else{
                                            match=1;
                                        }
                                    }
                                }
                                else{
                                    firstDot=false;
                                }
                            }
                        }
                    }
                }
                if (z==3) {
                    tile.dotColorArrayCopy=tile.dotColorArray;
                }
            }
            if (tile.match==YES) {
                [_tileMatchArray addObject:tile];
                tile.match=NO;
            }
        }
    }
    if (possibleMatch==NO) {
        for (int x=0; x<GRID_SIZE; x++) {
            for (int y=0; y<GRID_SIZE; y++) {
                Tile* tile=self.gridArray[x][y];
                [self removeChild:tile];
                
                Tile* newTile= (Tile*)[CCBReader load:@"Tile"];
                
                [newTile setScaleX:((_columnWidth)/tile.contentSize.width)];
                [newTile setScaleY:((_columnHeight)/tile.contentSize.height)];
                
                newTile.position = tile.position;
                self.gridArray[x][y]=newTile;
                newTile.tileX=tile.tileX;
                newTile.tileY=tile.tileY;
                newTile.remove=false;
            }
        }
    }
    else if (possibleMatch==YES){
        possibleMatch=NO;
    }
    [indicateTimer invalidate];
    indicatedTile=[_tileMatchArray objectAtIndex:(arc4random()% [_tileMatchArray count])];
    indicateTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(indicateMove) userInfo:nil repeats:YES];
}

#pragma mark - Indicate Move

-(void)indicateMove{
    [indicatedTile.animationManager runAnimationsForSequenceNamed:(@"Animation")];
    CCTimer* myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(resetAnimation) userInfo:nil repeats:NO];
}

-(void)resetAnimation{
    [indicatedTile.animationManager runAnimationsForSequenceNamed:(@"Default Timeline")];
}

@end

