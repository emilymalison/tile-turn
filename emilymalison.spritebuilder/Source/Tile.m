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
#import "OALSimpleAudio.h"

@implementation Tile{
    CGFloat _dotMarginHorizontal;
    CGFloat _dotMarginVertical;
    CGFloat _tileColumnWidth;
    CGFloat _tileColumnHeight;
    Dot *dot;
    BOOL canTouch;
    CCSprite *_tile;
}
- (void)onEnter
{
    [super onEnter];
    [self setUpTile];
    
    NSURL *turnSoundURL=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"cardSlide1-2-3" ofType:@"mp3"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)turnSoundURL, &turnSound);
    
    self.userInteractionEnabled = YES;
    canTouch = YES;
    
    self.remove=NO;
    self.rotationMeasure=0;
    self.match=NO;
    self.checking=NO;
    self.physicsBody.collisionMask=@[];
    
    //[[OALSimpleAudio sharedInstance] preloadEffect:@"cardSlide1-2.mp3"];
}

#pragma mark - Filling Tile with Dots

-(void)setUpTile{
    _tileColumnHeight=self.contentSize.height/3;
    _tileColumnWidth=self.contentSize.width/3;
    
    _dotMarginHorizontal=_tileColumnWidth/2;
    _dotMarginVertical=_tileColumnHeight/2;
    
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
                [dot setScaleX:(((_tileColumnWidth)/dot.contentSize.width))/2.2];
                [dot setScaleY:(((_tileColumnHeight)/dot.contentSize.height))/2.2];
                [_tile addChild:dot];
                dot.contentSize = CGSizeMake(_tileColumnWidth, _tileColumnHeight);
                dot.position = ccp(x, y);
                self.tileArray[i][j]=dot;
                dot.dotX=i;
                dot.dotY=j;
                dot.match=NO;
                [self.dotColorArray[i] addObject:[NSNumber numberWithInteger: dot.DotColor]];
            }
            else if(numberDot==1){
                dot=(Dot*)[CCBReader load: @"Dot2"];
                dot.DotColor=green;
                [dot setScaleX:(((_tileColumnWidth)/dot.contentSize.width))/2.2];
                [dot setScaleY:(((_tileColumnHeight)/dot.contentSize.height))/2.2];
                [_tile addChild:dot];
                dot.contentSize=CGSizeMake(_tileColumnWidth, _tileColumnHeight);
                dot.position=ccp(x, y);
                [self.dotColorArray[i] addObject:[NSNumber numberWithInteger:dot.DotColor]];
                self.tileArray[i][j]=dot;
                dot.dotX=i;
                dot.dotY=j;
                dot.match=NO;
            }
            else if(numberDot==2){
                dot=(Dot*)[CCBReader load: @"Dot3"];
                dot.DotColor=white;
                [dot setScaleX:(((_tileColumnWidth)/dot.contentSize.width))/2.2];
                [dot setScaleY:(((_tileColumnHeight)/dot.contentSize.height))/2.2];
                [_tile addChild:dot];
                dot.contentSize=CGSizeMake(_tileColumnWidth, _tileColumnHeight);
                dot.position=ccp(x, y);
                [self.dotColorArray[i] addObject:[NSNumber numberWithInteger:dot.DotColor]];
                self.tileArray[i][j]=dot;
                dot.dotX=i;
                dot.dotY=j;
                dot.match=NO;
            }
            
            x+=_tileColumnWidth;
        }
        y+=_tileColumnHeight;
    }
    self.dotColorArrayCopy=self.dotColorArray;
}

#pragma mark - Rotating Tile When Tapped

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if (canTouch) {
        self.physicsBody.collisionMask=@[];
        canTouch = NO;
        CCActionRotateBy *rotateTile= [CCActionRotateBy actionWithDuration:.4 angle:90];
        if (self.sound==YES) {
            AudioServicesPlaySystemSound(turnSound);
            //OALSimpleAudio *audio=[OALSimpleAudio sharedInstance];
            //audio.effectsVolume=1.0;
            //[[OALSimpleAudio sharedInstance] playEffect:@"cardSlide1-2.mp3"];
        }
        CCActionCallBlock *resetTouch = [CCActionCallBlock actionWithBlock:^{
            canTouch= YES;
            self.physicsBody.collisionMask = nil;
        }];
        [self runAction:[CCActionSequence actionOne:rotateTile two:resetTouch]];
        
        self.dotColorArray=[self rotateColorMatrix:self.dotColorArray];
        self.dotColorArrayCopy=self.dotColorArray;
        self.tileArray=[self rotateColorMatrix:self.tileArray];
        
        [(Grid*)self.parent checkTile:self];
    }
}


-(NSMutableArray*)rotateColorMatrix:(NSMutableArray*)matrix{
    return [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:matrix[0][2], matrix[1][2], matrix[2][2], nil], [NSMutableArray arrayWithObjects:matrix[0][1], matrix[1][1], matrix[2][1], nil], [NSMutableArray arrayWithObjects:matrix[0][0], matrix[1][0], matrix[2][0], nil], nil];
}

#pragma mark - Rotating Tile Backwards

-(void)rotateBackwards{
    self.rotation -= 90;
    self.rotationMeasure+=1;
    if (self.rotationMeasure==3) {
        NSLog(@"rotation=3");
        self.remove=YES;
        self.checking=YES;
        [(Grid*)self.parent removeTiles];
    }
    self.dotColorArray=[self rotateColorMatrix:self.dotColorArray];
    self.dotColorArray=[self rotateColorMatrix:self.dotColorArray];
    self.dotColorArray=[self rotateColorMatrix:self.dotColorArray];
    self.dotColorArrayCopy=self.dotColorArray;
    
    self.tileArray=[self rotateColorMatrix:self.tileArray];
    self.tileArray=[self rotateColorMatrix:self.tileArray];
    self.tileArray=[self rotateColorMatrix:self.tileArray];
    
    [(Grid*)self.parent checkVerticallyTile:self];
    [(Grid*)self.parent checkHorizontallyTile:self];
    
}

#pragma mark - Particle Effect When Removed
- (void)tileRemoved{
    CCParticleSystem *tileRemoved = (CCParticleSystem *)[CCBReader load:@"Tile Removed"];
    tileRemoved.autoRemoveOnFinish = TRUE;
    tileRemoved.position = ccp(self.position.x, self.position.y +(2*self.contentSize.height));
    Grid *_grid=self.parent;
    CCNode *_node=_grid.parent;
    [_node.parent addChild:tileRemoved];
}


@end
