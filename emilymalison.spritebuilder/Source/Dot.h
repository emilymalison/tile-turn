//
//  Dot.h
//  emilymalison
//
//  Created by Emily Malison on 8/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

typedef enum { //the three different colors dots can be
    green,
    white,
    blue
} DotColor;

@interface Dot : CCNode //defining the dot class

//defining dot properties
@property (nonatomic, assign)NSUInteger DotColor; //color
@property (nonatomic, assign)int dotX; //which column a dot is in
@property (nonatomic, assign)int dotY; //which row a dot is in
@property (nonatomic, assign)BOOL match; //whether a dot is part of a match or not

@end
