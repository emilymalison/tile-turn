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
    Tile *tileRotated;
    Tile *indicatedTile;
    int score;
    BOOL possibleMatch;
    NSMutableArray *_tileMatchArray;
    BOOL moveIndicated;
    NSTimer* indicateTimer;
    NSMutableArray *_newTileArray0;
    NSMutableArray *_newTileArray1;
    NSMutableArray *_newTileArray2;
    Tile *fallingTile;
    CCTimer *fallingTimer;
    int newYPosition;
    NSMutableArray *_tilesToFallArray;
    //NSNull *noTile;
}

- (void)onEnter
{
    [super onEnter];
    possibleMatch=NO;
    
    [self setUpGrid];
    
    moveIndicated=NO;
    _newTileArray0=[NSMutableArray array];
    _newTileArray1=[NSMutableArray array];
    _newTileArray2=[NSMutableArray array];
    _tilesToFallArray=[NSMutableArray array];
    
    //noTile=[NSNull null];
}

-(void)update:(CCTime)delta{
    /*for (int x=0; x<GRID_SIZE; x++) {
        for (int y=0; y<GRID_SIZE; y++) {
            if (_gridArray[x][y]!=noTile) {
                Tile* tile=_gridArray[x][y];
                tile.tileX=round((tile.position.y/tile.contentSize.height)/2);
                tile.tileY=round((tile.position.x/tile.contentSize.width)/2);
                _gridArray[tile.tileX][tile.tileY]=tile;
            }
        }
    }*/
    for (Tile* tile in self.children) {
        tile.tileX=round((tile.position.y/tile.contentSize.height)/2);
        tile.tileY=round((tile.position.x/tile.contentSize.width)/2);
        if (tile.tileX<=2) {
            _gridArray[tile.tileX][tile.tileY]=tile;
        }
    }
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
			tile.position = ccp(x, y);
            _gridArray[i][j]=tile;
            tile.tileX=i;
            tile.tileY=j;
            
			x+= _columnWidth;
		}
		y += _columnHeight;
    }
    [self checkHorizontallyTile:_gridArray[0][0]];
    [self checkHorizontallyTile:_gridArray[1][0]];
    [self checkHorizontallyTile:_gridArray[2][0]];
    [self checkVerticallyTile:_gridArray[0][0]];
    [self checkVerticallyTile:_gridArray[0][1]];
    [self checkVerticallyTile:_gridArray[0][2]];
    [self checkForMoves];
}

#pragma mark - Checking for Matches

-(void)checkTile:(Tile *)rotatedTile{
    int match;
    BOOL firstDot;
    int scoreCheck=score;
    for (int j=0; j<3; j++) {
        match=1;
        firstDot=true;
        for (int i=-2; i<GRID_SIZE; i++) {
            if (rotatedTile.tileY+i>=0 && rotatedTile.tileY+i<=2) {
                Tile* currentTile=_gridArray[rotatedTile.tileX][rotatedTile.tileY+i];
                for (int k=0; k<3; k++) {
                    if (!firstDot){
                        if (k!=0) {
                            if (currentTile.dotColorArray[j][k]==currentTile.dotColorArray[j][k-1]) {
                                match++;
                                if (match>=5) {
                                    currentTile.remove=true;
                                    Tile* tileBefore=_gridArray[currentTile.tileX][currentTile.tileY-1];
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
                            Tile* tileBefore=_gridArray[currentTile.tileX][currentTile.tileY-1];
                            if (currentTile.dotColorArray[j][k]==tileBefore.dotColorArray[j][2]) {
                                match++;
                                if (match>=5) {
                                    currentTile.remove=true;
                                    tileBefore.remove=true;
                                    if (match==5) {
                                        score+=5;
                                        if (currentTile.tileY-2>=0) {
                                            Tile* tileBeforeTileBefore=_gridArray[currentTile.tileX][currentTile.tileY-2];
                                            tileBeforeTileBefore.remove=true;
                                        }
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
                Tile* currentTile=_gridArray[rotatedTile.tileX+i][rotatedTile.tileY];
                for (int k=0; k<3; k++) {
                    if (!firstDot) {
                        if (k!=0) {
                            if (currentTile.dotColorArray[k][j]==currentTile.dotColorArray[k-1][j]) {
                                match++;
                                if (match>=5) {
                                    currentTile.remove=true;
                                    Tile* tileBefore=_gridArray[currentTile.tileX-1][currentTile.tileY];
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
                            Tile* tileBefore=_gridArray[currentTile.tileX-1][currentTile.tileY];
                            if (currentTile.dotColorArray[k][j]==tileBefore.dotColorArray[2][j]) {
                                match++;
                                if (match>=5) {
                                    currentTile.remove=true;
                                    tileBefore.remove=true;
                                    if (match==5) {
                                        score+=5;
                                        if (currentTile.tileX-2>=0) {
                                            Tile* tileBeforeTileBefore=_gridArray[currentTile.tileX-2][currentTile.tileY];
                                            tileBeforeTileBefore.remove=true;
                                        }
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
    if (score>scoreCheck) {
        [NSTimer scheduledTimerWithTimeInterval:.7 target:self selector:@selector(removeTiles) userInfo:nil repeats:NO];
    }
}

#pragma mark - Removing Tiles and Adding New Tiles

-(void)removeTiles{
    _newTileArray0=[NSMutableArray array];
    _newTileArray1=[NSMutableArray array];
    _newTileArray2=[NSMutableArray array];
    BOOL removed=NO;
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            Tile* tile=_gridArray[i][j];
            if (tile.remove==true && tile.checking==NO) {
                removed=YES;
                tile.remove=false;
                
                for (int x=0; x<3; x++) {
                    Tile* eachTile =_gridArray[x][tile.tileY];
                    eachTile.physicsBody.collisionMask=nil;
                    if (eachTile.tileX>tile.tileX) {
                        eachTile.physicsBody.affectedByGravity=YES;
                    }
                }
                
                // WARNING: MIGHT LEAD TO UNEXPECTED BEHAVIOR
                if ([self.children containsObject:tile]) {
                    [self removeChild:tile];
                }
                
                Tile* newTile=(Tile*)[CCBReader load: @"Tile"];
                newTile.tileY=tile.tileY;
                [newTile setScaleX:((_columnWidth)/newTile.contentSize.width)];
                [newTile setScaleY:((_columnHeight)/newTile.contentSize.height)];
                newTile.position=ccp(tile.positionInPoints.x, self.contentSize.height+newTile.contentSize.height+1);
                newTile.remove=false;
                newTile.rotationMeasure=0;
                newTile.match=NO;
                newTile.checking=NO;
                newTile.userInteractionEnabled=NO;
                newTile.visible=NO;
                
                [self addChild:newTile];
                
                if (newTile.tileY==0) {
                    if ([_newTileArray0 count]==1) {
                        [NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(dropNewTile:) userInfo:newTile repeats:NO];
                        newTile.visible=NO;
                        newTile.physicsBody.collisionMask=@[];
                    }
                    else if ([_newTileArray0 count]==2){
                        [NSTimer scheduledTimerWithTimeInterval:2.6 target:self selector:@selector(dropNewTile:) userInfo:newTile repeats:NO];
                        newTile.visible=NO;
                        newTile.physicsBody.collisionMask=@[];
                    }
                    else if ([_newTileArray0 count]==0) {
                        newTile.physicsBody.collisionMask=nil;
                        newTile.physicsBody.affectedByGravity=YES;
                        newTile.visible=YES;
                    }
                    [_newTileArray0 addObject:newTile];
                }
                if (newTile.tileY==1) {
                    if ([_newTileArray1 count]==1) {
                        [NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(dropNewTile:) userInfo:newTile repeats:NO];
                        newTile.visible=NO;
                        newTile.physicsBody.collisionMask=@[];
                        newTile.physicsBody.affectedByGravity=NO;
                    }
                    else if ([_newTileArray1 count]==2){
                        [NSTimer scheduledTimerWithTimeInterval:2.6 target:self selector:@selector(dropNewTile:) userInfo:newTile repeats:NO];
                        newTile.visible=NO;
                        newTile.physicsBody.collisionMask=@[];
                    }

                    else if ([_newTileArray1 count]==0) {
                        newTile.physicsBody.collisionMask=nil;
                        newTile.physicsBody.affectedByGravity=YES;
                        newTile.visible=YES;
                    }
                    [_newTileArray1 addObject:newTile];
                }
                if (newTile.tileY==2) {
                    if ([_newTileArray2 count]==1) {
                        [NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(dropNewTile:) userInfo:newTile repeats:NO];
                        newTile.visible=NO;
                        newTile.physicsBody.collisionMask=@[];
                        newTile.physicsBody.affectedByGravity=NO;
                    }
                    else if ([_newTileArray2 count]==2){
                        [NSTimer scheduledTimerWithTimeInterval:2.6 target:self selector:@selector(dropNewTile:) userInfo:newTile repeats:NO];
                        newTile.visible=NO;
                        newTile.physicsBody.collisionMask=@[];
                    }
                    else if ([_newTileArray2 count]==0) {
                        newTile.physicsBody.collisionMask=nil;
                        newTile.physicsBody.affectedByGravity=YES;
                        newTile.visible=YES;
                    }
                    [_newTileArray2 addObject:newTile];
                }
                /*for (Tile* otherTile in self.children){
                    if ([_gridArray[0] containsObject:otherTile]) {
                        if (CGRectContainsRect(newTile.boundingBox, otherTile.boundingBox)) {
                            [_tilesToFallArray addObject:newTile];
                            [NSTimer timerWithTimeInterval:.7 target:self selector:@selector(newTileFall) userInfo:nil repeats:NO];
                        }
                        else{
                            newTile.physicsBody.affectedByGravity=YES;
                            newTile.physicsBody.collisionMask=nil;
                            newTile.visible=YES;
                        }
                    }
                    else if ([_gridArray[1] containsObject:otherTile]){
                        if (CGRectContainsRect(newTile.boundingBox, otherTile.boundingBox)) {
                            [_tilesToFallArray addObject:newTile];
                            [NSTimer timerWithTimeInterval:.7 target:self selector:@selector(newTileFall) userInfo:nil repeats:NO];
                        }
                        else{
                            newTile.physicsBody.affectedByGravity=YES;
                            newTile.physicsBody.collisionMask=nil;
                            newTile.visible=YES;
                        }
                    }
                    else if ([_gridArray[2] containsObject:otherTile]){
                        if (CGRectContainsRect(newTile.boundingBox, otherTile.boundingBox)) {
                            [_tilesToFallArray addObject:newTile];
                            [NSTimer timerWithTimeInterval:.7 target:self selector:@selector(newTileFall) userInfo:nil repeats:NO];
                        }
                        else{
                            newTile.physicsBody.affectedByGravity=YES;
                            newTile.physicsBody.collisionMask=nil;
                            newTile.visible=YES;
                        }
                    }
                }*/
            }
            else if (tile.remove==YES && tile.checking==YES){
                [self removeChild:tile];
                Tile* newTile=_gridArray[tile.tileX][tile.tileY];
                newTile= (Tile*)[CCBReader load:@"Tile"];
                
                [newTile setScaleX:((_columnWidth)/tile.contentSize.width)];
                [newTile setScaleY:((_columnHeight)/tile.contentSize.height)];
                
                newTile.position = tile.position;
                _gridArray[tile.tileX][tile.tileY]=newTile;
                newTile.tileX=tile.tileX;
                newTile.tileY=tile.tileY;
                newTile.remove=false;
                newTile.rotationMeasure=0;
                newTile.match=NO;
                newTile.checking=NO;
                
                [self addChild:newTile];
                [self checkVerticallyTile:newTile];
                [self checkHorizontallyTile:newTile];
            }
        }
    }
    if ([_newTileArray0 count]>0) {
        for (int i=0; i<[_newTileArray0 count]; i++) {
            //Tile* tile=_newTileArray0[i];
            //[self checkTile:tile];
        }
    }
    if ([_newTileArray1 count]>0) {
        for (int i=0; i<[_newTileArray1 count]; i++) {
            //Tile* tile=_newTileArray1[i];
            //[self checkTile:tile];
        }
    }
    if ([_newTileArray2 count]>0) {
        for (int i=0; i<[_newTileArray2 count]; i++) {
            //Tile* tile=_newTileArray2[i];
            //[self checkTile:tile];
        }
    }
    if (removed==YES) {
        //[self checkForMoves];
    }
}

-(void)dropNewTile:(NSTimer*)theTimer{
    Tile *newTile = [theTimer userInfo];
    newTile.physicsBody.affectedByGravity=YES;
    newTile.physicsBody.collisionMask=nil;
    newTile.visible=YES;
    if (newTile.tileY==0) {
        [_newTileArray0 removeObject:newTile];
    }
    else if (newTile.tileY==1) {
        [_newTileArray1 removeObject:newTile];
    }
    else if (newTile.tileY==2) {
        [_newTileArray2 removeObject:newTile];
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
                Tile* currentTile=_gridArray[tile.tileX][tile.tileY+i];
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
                            Tile* tileBefore=_gridArray[currentTile.tileX][currentTile.tileY-1];
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
                Tile* currentTile=_gridArray[tile.tileX+i][tile.tileY];
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
                            Tile* tileBefore=_gridArray[currentTile.tileX-1][currentTile.tileY];
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
            Tile* tile=_gridArray[x][y];
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
                            Tile* currentTile=_gridArray[tile.tileX][tile.tileY+i];
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
                                        Tile* tileBefore=_gridArray[currentTile.tileX][currentTile.tileY-1];
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
                            Tile* currentTile=_gridArray[tile.tileX+i][tile.tileY];
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
                                        Tile* tileBefore=_gridArray[currentTile.tileX-1][currentTile.tileY];
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
                Tile* tile=_gridArray[x][y];
                
                [self removeChild:tile];

                Tile* newTile= (Tile*)[CCBReader load:@"Tile"];
                
                [newTile setScaleX:((_columnWidth)/tile.contentSize.width)];
                [newTile setScaleY:((_columnHeight)/tile.contentSize.height)];
                
                newTile.position = tile.position;
                _gridArray[x][y]=newTile;
                newTile.tileX=tile.tileX;
                newTile.tileY=tile.tileY;
                newTile.remove=false;
                newTile.match=NO;
                newTile.checking=NO;
                
                [self addChild:newTile];
                [self checkTile:newTile];
            }
        }
        [self checkForMoves];
    }
    
    if (possibleMatch==NO) {
        NSLog(@"no possible matches");
    }
    else if (possibleMatch==YES){
        possibleMatch=NO;
        [indicateTimer invalidate];
        indicatedTile=[_tileMatchArray objectAtIndex:(arc4random()% [_tileMatchArray count])];
        indicateTimer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(indicateMove) userInfo:nil repeats:YES];
    }
}

#pragma mark - Indicate Move

-(void)indicateMove{
    [indicatedTile.animationManager runAnimationsForSequenceNamed:(@"Animation")];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(resetAnimation) userInfo:nil repeats:NO];
}

-(void)resetAnimation{
    [indicatedTile.animationManager runAnimationsForSequenceNamed:(@"Default Timeline")];
}

@end

