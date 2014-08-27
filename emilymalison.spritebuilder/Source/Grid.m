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
#import "OALSimpleAudio.h"

static const int GRID_SIZE=3;

@implementation Grid{
    CGFloat _columnWidth;
    CGFloat _columnHeight;
    CGFloat _tileMarginVertical;
    CGFloat _tileMarginHorizontal;
    CCSprite *tileSprite;
    NSMutableArray *_gridArray;
    Tile *tileRotated;
    int score;
    BOOL possibleMatch;
    NSMutableArray *_tileMatchArray;
    BOOL moveIndicated;
    NSTimer* indicateTimer;
    NSMutableArray *_newTileArray;
    Gameplay *_gameplayScene;
    BOOL shuffling;
    NSTimer *shufflingTimer;
    NSMutableArray *_newTileArray0;
    NSMutableArray *_newTileArray1;
    NSMutableArray *_newTileArray2;
    int tilesNotMoving;
    BOOL falling;
    BOOL newGrid;
    BOOL afterFalling;
    int tilesChecked;
    CCLabelTTF *comboText;
    int timeLeft;
    NSTimer *secondTimer;
}

- (void)onEnter
{
    [super onEnter];
    timeLeft=0;
    possibleMatch=NO;
    
    newGrid=YES;
    [self setUpGrid];
    
    moveIndicated=NO;
    _newTileArray=[NSMutableArray array];
    
    shuffling=NO;
    _newTileArray0=[NSMutableArray array];
    _newTileArray1=[NSMutableArray array];
    _newTileArray2=[NSMutableArray array];
    falling=NO;
    self.timerExpired=NO;
    tilesChecked=9;
    self.newHint=NO;
    
    NSURL *turnSoundURL=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"jingles_PIZZA00-4" ofType:@"mp3"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)turnSoundURL, &matchSound);
    
    self.pause=NO;
}

-(void)update:(CCTime)delta{
    tilesNotMoving=0;
    CCNode *_node=self.parent;
    Gameplay* _gameplay=(Gameplay*)_node.parent;
    for (Tile* tile in self.children) {
        tile.sound=_gameplay.sound;
        tile.tileX=round((tile.position.y/tile.contentSize.height)/2);
        tile.tileY=round((tile.position.x/tile.contentSize.width)/2);
        if (tile.tileX<=2) {
            _gridArray[tile.tileX][tile.tileY]=tile;
        }
        if (tile.physicsBody.affectedByGravity==NO && falling==YES) {
            tilesNotMoving+=1;
        }
        CCNode *_node=self.parent;
        Gameplay *gameplay=(Gameplay*)_node.parent;
        if (gameplay.shuffling==YES) {
            tile.userInteractionEnabled=NO;
        }
    }
    if (tilesNotMoving==9 && falling==YES && self.pause==NO) {
        [self tilesDoneFalling];
        if (self.timerExpired==YES && shuffling==NO && tilesChecked==9) {
            CCNode *_node=self.parent;
            [self scheduleBlock:^(CCTimer *timer) {
                [(Gameplay*)_node.parent gameOver];
            } delay:.3];
        }
    }
    else if (falling==NO){
        if (self.timerExpired==YES && shuffling==NO && tilesChecked==9) {
            CCNode *_node=self.parent;
            [self scheduleBlock:^(CCTimer *timer) {
                if (falling==NO){
                    [(Gameplay*)_node.parent gameOver];
                }
            } delay:.3];
        }
    }
    if (self.timerExpired==YES || self.newHint==YES) {
        [indicateTimer invalidate];
        [secondTimer invalidate];
    }
}

-(void)tilesDoneFalling{
    tilesChecked=0;
    falling=NO;
    for (int x=0; x<GRID_SIZE; x++) {
        for (int y=0; y<GRID_SIZE; y++) {
            Tile *tile=_gridArray[x][y];
            tilesChecked+=1;
            if (tile.remove==NO) {
                [self checkTile:tile];
            }
        }
    }
    [self checkForMoves];
}

#pragma mark - UI and Gravity
-(void)disableUserInteraction{
    for (int x=0; x<GRID_SIZE; x++) {
        for (int y=0; y<GRID_SIZE; y++) {
            Tile *tile=_gridArray[x][y];
            tile.userInteractionEnabled=NO;
        }
    }
    if (shuffling==YES) {
        [indicateTimer invalidate];
    }
    else if (self.pause==YES){
        [indicateTimer invalidate];
    }
    else if (self.timerExpired==YES){
        [indicateTimer invalidate];
    }
}

-(void)enableUserInteraction{
    for (int x=0; x<GRID_SIZE; x++) {
        for (int y=0; y<GRID_SIZE; y++) {
            Tile *tile=_gridArray[x][y];
            tile.userInteractionEnabled=YES;
        }
    }
}


#pragma mark - Filling Grid with Tiles

-(void)setUpGrid{
    if (shuffling==YES) {
        for (int x=0; x<GRID_SIZE; x++) {
            for (int y=0; y<GRID_SIZE; y++) {
                Tile *toBeRemoved=_gridArray[x][y];
                [self removeChild:toBeRemoved];
            }
        }
    }
    if (newGrid==YES) {
        self.visible=NO;
    }
    
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
            
			x+= _columnWidth + 1;
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
    [self disableUserInteraction];
    int match;
    BOOL firstDot;
    int scoreAddOn=0;
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
                                        scoreAddOn+=5;
                                        Dot* dot1=currentTile.tileArray[j][k];
                                        dot1.match=YES;
                                        if (k==2) {
                                            Dot* dot2=currentTile.tileArray[j][k-1];
                                            Dot* dot3=currentTile.tileArray[j][k-2];
                                            Dot* dot4=tileBefore.tileArray[j][2];
                                            Dot* dot5=tileBefore.tileArray[j][1];
                                            dot2.match=YES;
                                            dot3.match=YES;
                                            dot4.match=YES;
                                            dot5.match=YES;
                                        }
                                        else if (k==1){
                                            Dot* dot2=currentTile.tileArray[j][k-1];
                                            Dot* dot3=tileBefore.tileArray[j][2];
                                            Dot* dot4=tileBefore.tileArray[j][1];
                                            Dot* dot5=tileBefore.tileArray[j][0];
                                            dot2.match=YES;
                                            dot3.match=YES;
                                            dot4.match=YES;
                                            dot5.match=YES;
                                        }
                                    }
                                    else if (match>5){
                                        Dot* dot6=currentTile.tileArray[j][k];
                                        dot6.match=YES;
                                        scoreAddOn+=1;
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
                                        scoreAddOn+=5;
                                        Tile* tileBeforeBefore=_gridArray[currentTile.tileX][currentTile.tileY-2];
                                        tileBeforeBefore.remove=TRUE;
                                        Dot* dot1=currentTile.tileArray[j][k];
                                        dot1.match=YES;
                                        if (k==0){
                                            Dot* dot2=tileBefore.tileArray[j][2];
                                            Dot* dot3=tileBefore.tileArray[j][1];
                                            Dot* dot4=tileBefore.tileArray[j][0];
                                            Dot* dot5=tileBeforeBefore.tileArray[j][2];
                                            dot2.match=YES;
                                            dot3.match=YES;
                                            dot4.match=YES;
                                            dot5.match=YES;
                                        }
                                    }
                                    else if (match>5){
                                        Dot* dot6=currentTile.tileArray[j][k];
                                        dot6.match=YES;
                                        scoreAddOn+=1;
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
                                        scoreAddOn+=5;
                                        Dot* dot1=currentTile.tileArray[k][j];
                                        dot1.match=YES;
                                        if (k==2) {
                                            Dot* dot2=currentTile.tileArray[k-1][j];
                                            Dot* dot3=currentTile.tileArray[k-2][j];
                                            Dot* dot4=tileBefore.tileArray[2][j];
                                            Dot* dot5=tileBefore.tileArray[1][j];
                                            dot2.match=YES;
                                            dot3.match=YES;
                                            dot4.match=YES;
                                            dot5.match=YES;
                                        }
                                        else if (k==1){
                                            Dot* dot2=currentTile.tileArray[k-1][j];
                                            Dot* dot3=tileBefore.tileArray[2][j];
                                            Dot* dot4=tileBefore.tileArray[1][j];
                                            Dot* dot5=tileBefore.tileArray[0][j];
                                            dot2.match=YES;
                                            dot3.match=YES;
                                            dot4.match=YES;
                                            dot5.match=YES;
                                        }
                                    }
                                    else if (match>5){
                                        Dot* dot6=currentTile.tileArray[k][j];
                                        dot6.match=YES;
                                        scoreAddOn+=1;
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
                                        Tile* tileBeforeBefore=_gridArray[currentTile.tileX-2][currentTile.tileY];
                                        tileBeforeBefore.remove=TRUE;
                                        scoreAddOn+=5;
                                        Dot* dot1=currentTile.tileArray[k][j];
                                        dot1.match=YES;
                                        if (k==0){
                                            Dot* dot2=tileBefore.tileArray[2][j];
                                            Dot* dot3=tileBefore.tileArray[1][j];
                                            Dot* dot4=tileBefore.tileArray[0][j];
                                            Dot* dot5=tileBeforeBefore.tileArray[2][j];
                                            dot2.match=YES;
                                            dot3.match=YES;
                                            dot4.match=YES;
                                            dot5.match=YES;
                                        }
                                    }
                                    else if (match>5){
                                        Dot* dot6=currentTile.tileArray[k][j];
                                        dot6.match=YES;
                                        scoreAddOn+=1;
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
    if (scoreAddOn>0) {
        [indicateTimer invalidate];
        [secondTimer invalidate];
        if (scoreAddOn>9 && falling==NO) {
            score=score+(2*scoreAddOn);
            [self scheduleBlock:^(CCTimer *timer) {
                CCNode *_node=self.parent;
                [(Gameplay*)_node.parent combo];
            } delay:.5];
        }
        else{
            score=score+scoreAddOn;
        }
        _totalScore=score;
        tilesChecked=0;
        [self disableUserInteraction];
       for (Tile* toBeRemoved in self.children){
            if (toBeRemoved.remove==YES) {
                [self scheduleBlock:^(CCTimer *timer) {
                    [self matchAnimationOnTile:toBeRemoved];
                } delay:1];
                for (int x=0; x<3; x++){
                    for (int y=0; y<3; y++) {
                        Dot* matchDot=toBeRemoved.tileArray[x][y];
                        if (matchDot.match==YES) {
                            [self scheduleBlock:^(CCTimer *timer) {
                                [self dotAnimation:matchDot];
                                if (toBeRemoved.sound==YES) {
                                    AudioServicesPlaySystemSound(matchSound);
                                }
                            } delay:.5];
                        }
                    }
                }
            }
        }
    }
    else if (scoreAddOn==0 && falling==NO && tilesChecked==9 && self.timerExpired==NO){
        [self enableUserInteraction];
    }
}

#pragma mark - Remove Tiles

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
                for (Tile* someTile in self.children) {
                    someTile.userInteractionEnabled=NO;
                }
                tile.remove=false;
                
                for (int x=0; x<3; x++) {
                    Tile* eachTile =_gridArray[x][tile.tileY];
                    eachTile.physicsBody.collisionMask=nil;
                    if (tile.tileX+1<=2) {
                        if (eachTile.tileX==tile.tileX+1) {
                            [self scheduleBlock:^(CCTimer *timer) {
                                eachTile.physicsBody.affectedByGravity=YES;
                            } delay:.1];
                        }
                        if (tile.tileX+2<=2) {
                            if (eachTile.tileX==tile.tileX+2) {
                                [self scheduleBlock:^(CCTimer *timer) {
                                    eachTile.physicsBody.affectedByGravity=YES;
                                } delay:.2];
                            }
                        }
                    }
                }
                
                // WARNING: MIGHT LEAD TO UNEXPECTED BEHAVIOR
                if ([self.children containsObject:tile]) {
                    [self removeChild:tile];
                    [self scheduleBlock:^(CCTimer *timer) {
                    } delay:.5];
                }
                
                Tile* newTile=(Tile*)[CCBReader load: @"Tile"];
                newTile.tileY=tile.tileY;
                [newTile setScaleX:((_columnWidth)/newTile.contentSize.width)];
                [newTile setScaleY:((_columnHeight)/newTile.contentSize.height)];
                newTile.position=ccp(tile.positionInPoints.x, self.contentSize.height+newTile.contentSize.height+5);
                newTile.remove=false;
                newTile.rotationMeasure=0;
                newTile.match=NO;
                newTile.checking=NO;
                newTile.visible=NO;
                
                [self addChild:newTile];
                
                newTile.userInteractionEnabled=NO;
                
                if (newTile.tileY==0) {
                    if ([_newTileArray0 count]==1) {
                        if (self.pause==NO) {
                           [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(dropNewTile:) userInfo:newTile repeats:NO];
                            newTile.position=ccp(newTile.position.x, newTile.position.y+250);
                            newTile.visible=NO;
                            newTile.physicsBody.collisionMask=@[];
                        }
                    }
                    else if ([_newTileArray0 count]==2){
                        if (self.pause==NO) {
                            [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(dropNewTile:) userInfo:newTile repeats:NO];
                            newTile.position=ccp(newTile.position.x, newTile.position.y+500);
                            newTile.visible=NO;
                            newTile.physicsBody.collisionMask=@[];
                        }
                    }
                    else if ([_newTileArray0 count]==0) {
                        [self scheduleBlock:^(CCTimer *timer) {
                            newTile.physicsBody.collisionMask=nil;
                            newTile.physicsBody.affectedByGravity=YES;
                            newTile.visible=YES;
                            falling=YES;
                        } delay:.2];
                    }
                    [_newTileArray0 addObject:newTile];
                }
                if (newTile.tileY==1) {
                    if ([_newTileArray1 count]==1) {
                        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(dropNewTile:) userInfo:newTile repeats:NO];
                        newTile.position=ccp(newTile.position.x, newTile.position.y+250);
                        newTile.visible=NO;
                        newTile.physicsBody.collisionMask=@[];
                        newTile.physicsBody.affectedByGravity=NO;
                    }
                    else if ([_newTileArray1 count]==2){
                        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(dropNewTile:) userInfo:newTile repeats:NO];
                        newTile.position=ccp(newTile.position.x, newTile.position.y+500);
                        newTile.visible=NO;
                        newTile.physicsBody.collisionMask=@[];
                    }
                    
                    else if ([_newTileArray1 count]==0) {
                        [self scheduleBlock:^(CCTimer *timer) {
                            newTile.physicsBody.collisionMask=nil;
                            newTile.physicsBody.affectedByGravity=YES;
                            newTile.visible=YES;
                            falling=YES;
                        } delay:.2];
                    }
                    [_newTileArray1 addObject:newTile];
                }
                if (newTile.tileY==2) {
                    if ([_newTileArray2 count]==1) {
                        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(dropNewTile:) userInfo:newTile repeats:NO];
                        newTile.position=ccp(newTile.position.x, newTile.position.y+250);
                        newTile.visible=NO;
                        newTile.physicsBody.collisionMask=@[];
                        newTile.physicsBody.affectedByGravity=NO;
                    }
                    else if ([_newTileArray2 count]==2){
                        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(dropNewTile:) userInfo:newTile repeats:NO];
                        newTile.position=ccp(newTile.position.x, newTile.position.y+500);
                        newTile.visible=NO;
                        newTile.physicsBody.collisionMask=@[];
                    }
                    else if ([_newTileArray2 count]==0) {
                        [self scheduleBlock:^(CCTimer *timer) {
                            newTile.physicsBody.collisionMask=nil;
                            newTile.physicsBody.affectedByGravity=YES;
                            newTile.visible=YES;
                            falling=YES;
                        } delay:.2];
                    }
                    [_newTileArray2 addObject:newTile];
                }
            }
            else if (tile.remove==YES && tile.checking==YES){
                removed=NO;
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


#pragma mark - Match Animations
-(void)matchAnimationOnTile:(Tile*)removedTile{
    [removedTile.animationManager runAnimationsForSequenceNamed:(@"Match Timeline")];
    [removedTile tileRemoved];
    
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(removeTiles) userInfo:nil repeats:NO];
}

-(void)dotAnimation:(Dot*)matchDot{
    [matchDot.animationManager runAnimationsForSequenceNamed:(@"Animation")];
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
    for (Tile* tile in self.children) {
        tile.tileMatchArray=[NSMutableArray array];
    }
    possibleMatch=NO;
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
                                                if (match==5) {
                                                    if (currentTile!=tile) {
                                                        [tile.tileMatchArray addObject:currentTile];
                                                    }
                                                    else if (currentTile==tile){
                                                        Tile* tileLeft=_gridArray[tile.tileX][tile.tileY-1];
                                                        [tile.tileMatchArray addObject:tileLeft];
                                                    }
                                                }
                                                else if (match>5) {
                                                    if (currentTile!=tile) {
                                                        [tile.tileMatchArray addObject:currentTile];
                                                    }
                                                }
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
                                                if (match==5) {
                                                    if (currentTile!=tile) {
                                                        [tile.tileMatchArray addObject:currentTile];
                                                    }
                                                    Tile* tileBefore=_gridArray[currentTile.tileX][currentTile.tileY-1];
                                                    if (tileBefore!=tile) {
                                                        [tile.tileMatchArray addObject:tileBefore];
                                                    }
                                                    Tile* tileBeforeBefore=_gridArray[currentTile.tileX][currentTile.tileY-1];
                                                    if (tileBeforeBefore!=tile) {
                                                        [tile.tileMatchArray addObject:tileBeforeBefore];
                                                    }
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
                                                if (match==5) {
                                                    if (currentTile!=tile) {
                                                        [tile.tileMatchArray addObject:currentTile];
                                                    }
                                                    else if (currentTile==tile){
                                                        Tile* tileLeft=_gridArray[tile.tileX-1][tile.tileY];
                                                        [tile.tileMatchArray addObject:tileLeft];
                                                    }
                                                }
                                                else if (match>5) {
                                                    if (currentTile!=tile) {
                                                        [tile.tileMatchArray addObject:currentTile];
                                                    }
                                                }
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
                                                if (match==5) {
                                                    if (currentTile!=tile) {
                                                        [tile.tileMatchArray addObject:currentTile];
                                                    }
                                                    Tile* tileBefore=_gridArray[currentTile.tileX-1][currentTile.tileY];
                                                    if (tileBefore!=tile) {
                                                        [tile.tileMatchArray addObject:tileBefore];
                                                    }
                                                    Tile* tileBeforeBefore=_gridArray[currentTile.tileX-2][currentTile.tileY];
                                                    if (tileBeforeBefore!=tile) {
                                                        [tile.tileMatchArray addObject:tileBeforeBefore];
                                                    }
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
    if (possibleMatch==NO || [_tileMatchArray count]==0) {
        shuffling=YES;
        if (newGrid==NO) {
            CCNode *_node=self.parent;
            [(Gameplay*)_node.parent noPossibleMatches];
            shuffling=YES;
            [self setUpGrid];
            shufflingTimer=[NSTimer scheduledTimerWithTimeInterval:.7 target:self selector:@selector(resetShuffling) userInfo:nil repeats:NO];
        }
        else if (newGrid==YES){
            [self setUpGrid];
        }
    }
    
    else if (possibleMatch==YES || [_tileMatchArray count]>0){
        possibleMatch=NO;
        self.indicatedTile=[_tileMatchArray objectAtIndex:(arc4random()% [_tileMatchArray count])];
        if (self.newHint==NO) {
            [indicateTimer invalidate];
            [secondTimer invalidate];
            timeLeft=8;
            indicateTimer=[NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(indicateMove) userInfo:nil repeats:NO];
            secondTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(second) userInfo:nil repeats:YES];
        }
        else if (self.newHint==YES){
            [indicateTimer invalidate];
            [secondTimer invalidate];
            self.newHint=NO;
            indicateTimer=[NSTimer scheduledTimerWithTimeInterval:timeLeft target:self selector:@selector(indicateMove) userInfo:nil repeats:NO];
            secondTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(second) userInfo:nil repeats:YES];
        }
        if (newGrid==YES) {
            newGrid=NO;
            self.visible=YES;
        }
    }
}

-(void)resetShuffling{
    shuffling=NO;
    CCNode *_node=self.parent;
    [(Gameplay*)_node.parent shufflingDone];
}

#pragma mark - Indicate Move
-(void)second{
    if (timeLeft>0) {
        timeLeft-=1;
    }
}
-(void)indicateMove{
    if (falling==NO) {
        [self.indicatedTile.animationManager runAnimationsForSequenceNamed:(@"Animation")];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(resetAnimation) userInfo:nil repeats:NO];
        indicateTimer=[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(indicateMove) userInfo:nil repeats:NO];
        timeLeft=4;
    }
}

-(void)resetAnimation{
    [self.indicatedTile.animationManager runAnimationsForSequenceNamed:(@"Default Timeline")];
}

@end

