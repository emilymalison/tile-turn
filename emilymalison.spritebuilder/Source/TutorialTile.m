//
//  TutorialTile.m
//  emilymalison
//
//  Created by Emily Malison on 7/31/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TutorialTile.h"
#import "Dot.h"
#import "Tutorial.h"

@implementation TutorialTile{
    BOOL canTouch;
    CGFloat _tileColumnHeight;
    CGFloat _tileColumnWidth;
    CGFloat _dotMarginHorizontal;
    CGFloat _dotMarginVertical;
    Dot *dot;
    Tutorial *_tutorial;
}


-(void)onEnter{
    [super onEnter];
    
    self.userInteractionEnabled=YES;
    canTouch=YES;
    self.rotation=0;
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if (canTouch) {
        canTouch = NO;
        CCActionRotateBy *rotateTile= [CCActionRotateBy actionWithDuration:.4 angle:90];
        CCActionCallBlock *resetTouch = [CCActionCallBlock actionWithBlock:^{
            canTouch= YES;
            self.rotationMeasure+=1;
            CCNode *_node=self.parent;
            [(Tutorial*)_node.parent check];
        }];
        [self runAction:[CCActionSequence actionOne:rotateTile two:resetTouch]];
    }
    self.tileArray=[self rotateColorMatrix:self.tileArray];
}

-(NSMutableArray*)rotateColorMatrix:(NSMutableArray*)matrix{
    return [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:matrix[0][2], matrix[1][2], matrix[2][2], nil], [NSMutableArray arrayWithObjects:matrix[0][1], matrix[1][1], matrix[2][1], nil], [NSMutableArray arrayWithObjects:matrix[0][0], matrix[1][0], matrix[2][0], nil], nil];
}

-(void)setUpTutorialTile{
    _tileColumnHeight=self.contentSize.height/3;
    _tileColumnWidth=self.contentSize.width/3;
    
    _dotMarginHorizontal=_tileColumnWidth/2;
    _dotMarginVertical=_tileColumnHeight/2;
    
    
    self.tileArray=[NSMutableArray array];
    float x=_dotMarginHorizontal;
    float y=_dotMarginVertical;
    
    if (self.number==1) {
        self.userInteractionEnabled=NO;
        for (int i=0; i<3; i++) {
            self.tileArray[i]=[NSMutableArray array];
            x=_dotMarginHorizontal;
            for (int j=0; j<3; j++) {
                if (i==0 && j==0) {
                    dot=(Dot*)[CCBReader load:@"Dot1"];
                }
                else if (i==0 && j==1){
                    dot=(Dot*)[CCBReader load:@"Dot2"];
                }
                else if (i==0 && j==2){
                    dot=(Dot*)[CCBReader load:@"Dot3"];
                }
                else if (i==1 && j==0){
                    dot=(Dot*)[CCBReader load:@"Dot3"];
                }
                else if (i==1 && j==1){
                    dot=(Dot*)[CCBReader load:@"Dot3"];
                }
                else if (i==1 && j==2){
                    dot=(Dot*)[CCBReader load:@"Dot2"];
                }
                else if (i==2 && j==0){
                    dot=(Dot*)[CCBReader load:@"Dot1"];
                }
                else if (i==2 && j==1){
                    dot=(Dot*)[CCBReader load:@"Dot1"];
                }
                else if (i==2 && j==2){
                    dot=(Dot*)[CCBReader load:@"Dot1"];
                }
                [dot setScaleX:(((_tileColumnWidth)/dot.contentSize.width))/2.2];
                [dot setScaleY:(((_tileColumnHeight)/dot.contentSize.height))/2.2];
                [self addChild:dot];
                dot.contentSize = CGSizeMake(_tileColumnWidth, _tileColumnHeight);
                dot.position = ccp(x, y);
                self.tileArray[i][j]=dot;

                
                x+=_tileColumnWidth;
            }
            y+=_tileColumnHeight;
        }
    }
    else if (self.number==2) {
        for (int i=0; i<3; i++) {
            self.tileArray[i]=[NSMutableArray array];
            x=_dotMarginHorizontal;
            for (int j=0; j<3; j++) {
                if (i==0 && j==0) {
                    dot=(Dot*)[CCBReader load:@"Dot1"];
                }
                else if (i==0 && j==1){
                    dot=(Dot*)[CCBReader load:@"Dot3"];
                }
                else if (i==0 && j==2){
                    dot=(Dot*)[CCBReader load:@"Dot3"];
                }
                else if (i==1 && j==0){
                    dot=(Dot*)[CCBReader load:@"Dot1"];
                }
                else if (i==1 && j==1){
                    dot=(Dot*)[CCBReader load:@"Dot1"];
                }
                else if (i==1 && j==2){
                    dot=(Dot*)[CCBReader load:@"Dot1"];
                }
                else if (i==2 && j==0){
                    dot=(Dot*)[CCBReader load:@"Dot2"];
                }
                else if (i==2 && j==1){
                    dot=(Dot*)[CCBReader load:@"Dot3"];
                }
                else if (i==2 && j==2){
                    dot=(Dot*)[CCBReader load:@"Dot2"];
                }
                [dot setScaleX:(((_tileColumnWidth)/dot.contentSize.width))/2.2];
                [dot setScaleY:(((_tileColumnHeight)/dot.contentSize.height))/2.2];
                [self addChild:dot];
                dot.contentSize = CGSizeMake(_tileColumnWidth, _tileColumnHeight);
                dot.position = ccp(x, y);
                self.tileArray[i][j]=dot;

                
                
                x+=_tileColumnWidth;
            }
            y+=_tileColumnHeight;
        }
    }
    else if (self.number==3){
        self.userInteractionEnabled=NO;
        for (int i=0; i<3; i++) {
            self.tileArray[i]=[NSMutableArray array];
            x=_dotMarginHorizontal;
            for (int j=0; j<3; j++) {
                if (i==0 && j==0) {
                    dot=(Dot*)[CCBReader load:@"Dot3"];
                }
                else if (i==0 && j==1){
                    dot=(Dot*)[CCBReader load:@"Dot2"];
                }
                else if (i==0 && j==2){
                    dot=(Dot*)[CCBReader load:@"Dot1"];
                }
                else if (i==1 && j==0){
                    dot=(Dot*)[CCBReader load:@"Dot1"];
                }
                else if (i==1 && j==1){
                    dot=(Dot*)[CCBReader load:@"Dot1"];
                }
                else if (i==1 && j==2){
                    dot=(Dot*)[CCBReader load:@"Dot2"];
                }
                else if (i==2 && j==0){
                    dot=(Dot*)[CCBReader load:@"Dot3"];
                }
                else if (i==2 && j==1){
                    dot=(Dot*)[CCBReader load:@"Dot3"];
                }
                else if (i==2 && j==2){
                    dot=(Dot*)[CCBReader load:@"Dot3"];
                }
                [dot setScaleX:(((_tileColumnWidth)/dot.contentSize.width))/2.2];
                [dot setScaleY:(((_tileColumnHeight)/dot.contentSize.height))/2.2];
                [self addChild:dot];
                dot.contentSize = CGSizeMake(_tileColumnWidth, _tileColumnHeight);
                dot.position = ccp(x, y);
                self.tileArray[i][j]=dot;

                
                
                x+=_tileColumnWidth;
            }
            y+=_tileColumnHeight;
        }
    }
    else if (self.number==4){
        for (int i=0; i<3; i++) {
            self.tileArray[i]=[NSMutableArray array];
            x=_dotMarginHorizontal;
            for (int j=0; j<3; j++) {
                if (i==0 && j==0) {
                    dot=(Dot*)[CCBReader load:@"Dot1"];
                }
                else if (i==0 && j==1){
                    dot=(Dot*)[CCBReader load:@"Dot1"];
                }
                else if (i==0 && j==2){
                    dot=(Dot*)[CCBReader load:@"Dot3"];
                }
                else if (i==1 && j==0){
                    dot=(Dot*)[CCBReader load:@"Dot2"];
                }
                else if (i==1 && j==1){
                        dot=(Dot*)[CCBReader load:@"Dot3"];
                }
                else if (i==1 && j==2){
                    dot=(Dot*)[CCBReader load:@"Dot3"];
                }
                else if (i==2 && j==0){
                    dot=(Dot*)[CCBReader load:@"Dot2"];
                }
                else if (i==2 && j==1){
                    dot=(Dot*)[CCBReader load:@"Dot1"];
                }
                else if (i==2 && j==2){
                    dot=(Dot*)[CCBReader load:@"Dot3"];
                }
                [dot setScaleX:(((_tileColumnWidth)/dot.contentSize.width))/2.2];
                [dot setScaleY:(((_tileColumnHeight)/dot.contentSize.height))/2.2];
                [self addChild:dot];
                dot.contentSize = CGSizeMake(_tileColumnWidth, _tileColumnHeight);
                dot.position = ccp(x, y);
                self.tileArray[i][j]=dot;

                x+=_tileColumnWidth;
            }
            y+=_tileColumnHeight;
        }
    }
}




@end
