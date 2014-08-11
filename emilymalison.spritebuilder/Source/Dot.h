//
//  Dot.h
//  emilymalison
//
//  Created by Emily Malison on 8/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

typedef enum {
    green,
    blue,
    white
} DotColor;

@interface Dot : CCNode

@property (nonatomic, assign)NSUInteger DotColor;
@property (nonatomic, assign)int dotX;
@property (nonatomic, assign)int dotY;
@property (nonatomic, assign)BOOL match;

@end
