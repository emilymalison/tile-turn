//
//  Grid.m
//  emilymalison
//
//  Created by Emily Malison on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"

static const int GRID_SIZE=3;

@implementation Grid{
    CGFloat _columnWidth;
    CGFloat _columnHeight;
    CGFloat _tileMarginVertical;
    CGFloat _tileMarginHorizontal;
    NSMutableArray *_gridArray;
    Grid *_grid;
}

- (void)onEnter
{
    
    [super onEnter];
    
    [self setUpGrid];
    
    // accept touches on the grid
    self.userInteractionEnabled = YES;
}

-(void)setUpGrid{
    _tileMarginHorizontal=(self.contentSize.width - (GRID_SIZE *_columnWidth))/(GRID_SIZE+1);
    _tileMarginVertical=(self.contentSize.height - (GRID_SIZE *_columnHeight))/(GRID_SIZE+1);

    float x=_tileMarginHorizontal;
    float y=_tileMarginVertical;
    
    for (int i=0; i<GRID_SIZE; i++) {
        
        x=_tileMarginHorizontal;
        
        
        for (int j=0; j<GRID_SIZE; j++) {
            CCNode *tile= [CCBReader load:@"Tile"];
            _columnWidth=(_grid.contentSize.width/GRID_SIZE);
            _columnHeight=(_grid.contentSize.height/GRID_SIZE);
            [self addChild:tile];
            tile.contentSize = CGSizeMake(_columnWidth, _columnHeight);
			tile.position = ccp(x, y);
            
			x+= _columnWidth + _tileMarginHorizontal;
		}
		y += _columnHeight + _tileMarginVertical;
    }
    
}

@end

