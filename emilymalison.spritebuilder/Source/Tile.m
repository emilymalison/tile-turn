//
//  Tile.m
//  emilymalison
//
//  Created by Emily Malison on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tile.h"
#import "Grid.h"
#import "Dot.h"

static const int TILE_SIZE=3;

@implementation Tile{
    CGFloat _dotMarginHorizontal;
    CGFloat _dotMarginVertical;
    CGFloat _tileColumnWidth;
    CGFloat _tileColumnHeight;
    Dot *dot;
    BOOL canTouch;
}

- (void)onEnter
{
    
    [super onEnter];
    
    [self setUpTile];
    
    self.userInteractionEnabled = YES;
    canTouch = YES;
    
    self.tileRotation=0;
}

#pragma mark - Filling Tile with Dots

-(void)setUpTile{
    _tileColumnHeight=self.contentSize.height/3;
    _tileColumnWidth=self.contentSize.width/3;
    
    //float _dotBorderHorizontal=(self.contentSize.width)/2;
    //float _dotBorderVertical=(self.contentSize.height)/2;
    
    _dotMarginHorizontal=_tileColumnWidth/TILE_SIZE;
    _dotMarginVertical=_tileColumnHeight/TILE_SIZE;
    
    float x=_dotMarginHorizontal;
    float y=_dotMarginVertical;
    
    self.dotColorArray=[NSMutableArray array];
    self.tileArray=[NSMutableArray array];
    
    
    
    
    for (int i=0; i<3; i++) {
        [self.dotColorArray addObject:[NSMutableArray array]];
        self.tileArray[i]=[NSMutableArray array];
        x=_dotMarginHorizontal;
        
        for (int j=0; j<3; j++) {
            int numberDot=arc4random()%3;
            if (numberDot==0) {
                dot=(Dot*)[CCBReader load:@"Dot1"];
                dot.DotColor=blue;
                [dot setScaleX:(((_tileColumnWidth)/dot.contentSize.width))/2];
                [dot setScaleY:(((_tileColumnHeight)/dot.contentSize.height))/2];
                [self addChild:dot];
                dot.contentSize = CGSizeMake(_tileColumnWidth, _tileColumnHeight);
                dot.position = ccp(x, y);
                self.tileArray[i][j]=dot;
                dot.dotX=i;
                dot.dotY=j;
                [self.dotColorArray[i] addObject:[NSNumber numberWithInteger: dot.DotColor]];
                dot.dotChecked=false;
            }
            else if(numberDot==1){
                dot=(Dot*)[CCBReader load: @"Dot2"];
                dot.DotColor=green;
                [dot setScaleX:(((_tileColumnWidth)/dot.contentSize.width))/2];
                [dot setScaleY:(((_tileColumnHeight)/dot.contentSize.height))/2];
                [self addChild:dot];
                dot.contentSize=CGSizeMake(_tileColumnWidth, _tileColumnHeight);
                dot.position=ccp(x, y);
                [self.dotColorArray[i] addObject:[NSNumber numberWithInteger:dot.DotColor]];
                self.tileArray[i][j]=dot;
                dot.dotX=i;
                dot.dotY=j;
                dot.dotChecked=false;
            }
            else if(numberDot==2){
                dot=(Dot*)[CCBReader load: @"Dot3"];
                dot.DotColor=white;
                [dot setScaleX:(((_tileColumnWidth)/dot.contentSize.width))/2];
                [dot setScaleY:(((_tileColumnHeight)/dot.contentSize.height))/2];
                [self addChild:dot];
                dot.contentSize=CGSizeMake(_tileColumnWidth, _tileColumnHeight);
                dot.position=ccp(x, y);
                [self.dotColorArray[i] addObject:[NSNumber numberWithInteger:dot.DotColor]];
                self.tileArray[i][j]=dot;
                dot.dotX=i;
                dot.dotY=j;
                dot.dotChecked=false;
            }
            
            x+=_tileColumnWidth;
        }
        y+=_tileColumnHeight;
    }
    //NSLog(@"%@", self.tileArray);
    
}

#pragma mark - Rotating Tile

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if (canTouch) {
        canTouch = NO;
        CCActionRotateBy *rotateTile= [CCActionRotateBy actionWithDuration:.4 angle:90];
        CCActionCallBlock *resetTouch = [CCActionCallBlock actionWithBlock:^{
            canTouch= YES;
        }];
        [self runAction:[CCActionSequence actionOne:rotateTile two:resetTouch]];
        
        self.tileRotation+=1;
        
        if (self.tileRotation==4) {
            self.tileRotation=0;
        }
        //TODO: Fix Array Rotation
        self.dotColorArray=[self rotateColorMatrix:self.dotColorArray];
        
        [(Grid*)self.parent checkTile:self];
    }
}

-(NSMutableArray*)rotateColorMatrix:(NSMutableArray*)matrix{
    return [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:matrix[0][2], matrix[1][2], matrix[2][2], nil], [NSMutableArray arrayWithObjects:matrix[0][1], matrix[1][1], matrix[2][1], nil], [NSMutableArray arrayWithObjects:matrix[0][0], matrix[1][0], matrix[2][0], nil], nil];
}



@end
