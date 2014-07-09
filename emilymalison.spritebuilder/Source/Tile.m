//
//  Tile.m
//  emilymalison
//
//  Created by Emily Malison on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tile.h"

static const int TILE_SIZE=3;

@implementation Tile{
    NSMutableArray *_dotArray;
    NSMutableArray *_tileArray;
    CGFloat _dotMarginHorizontal;
    CGFloat _dotMarginVertical;
    CGFloat _tileColumnWidth;
    CGFloat _tileColumnHeight;
}

- (void)onEnter
{
    
    [super onEnter];
    
    [self setUpTile];
}

-(void)setUpTile{
    _tileColumnHeight=self.contentSize.height/3;
    _tileColumnWidth=self.contentSize.width/3;
    
    
    _dotMarginHorizontal=_tileColumnWidth/TILE_SIZE;
    _dotMarginVertical=_tileColumnHeight/TILE_SIZE;
    
    float x=_dotMarginHorizontal;
    float y=_dotMarginVertical;
    
    
    for (int i=0; i<3; i++) {
        x=_dotMarginHorizontal;
        
        for (int j=0; j<3; j++) {
            int numberDot=arc4random()%3;
            if (numberDot==0) {
                CCSprite *dot=(CCSprite*)[CCBReader load:@"Dot1"];
                [dot setScaleX:(((_tileColumnWidth)/dot.contentSize.width))/2];
                [dot setScaleY:(((_tileColumnHeight)/dot.contentSize.height))/2];
                [self addChild:dot];
                dot.contentSize = CGSizeMake(_tileColumnWidth, _tileColumnHeight);
                dot.position = ccp(x, y);
            }
            else if(numberDot==1){
                CCSprite *dot=(CCSprite*)[CCBReader load: @"Dot2"];
                [dot setScaleX:(((_tileColumnWidth)/dot.contentSize.width))/2];
                [dot setScaleY:(((_tileColumnHeight)/dot.contentSize.height))/2];
                [self addChild:dot];
                dot.contentSize=CGSizeMake(_tileColumnWidth, _tileColumnHeight);
                dot.position=ccp(x, y);
            }
            else if(numberDot==2){
                CCSprite *dot=(CCSprite*)[CCBReader load: @"Dot3"];
                [dot setScaleX:(((_tileColumnWidth)/dot.contentSize.width))/2];
                [dot setScaleY:(((_tileColumnHeight)/dot.contentSize.height))/2];
                [self addChild:dot];
                dot.contentSize=CGSizeMake(_tileColumnWidth, _tileColumnHeight);
                dot.position=ccp(x, y);
            }
            
            x+=_tileColumnWidth;
        }
        y+=_tileColumnHeight;
    }
    
}






@end
