//
//  Dot.h
//  emilymalison
//
//  Created by Emily Malison on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

typedef enum {
    green,
    blue,
    white
} DotColor;

@interface Dot : CCSprite

@property (nonatomic, assign)NSInteger matchingNeighbors;
@property (nonatomic, assign)NSUInteger DotColor;


@end
