//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface MainScene : CCNode <CCPhysicsCollisionDelegate> //Main Scene class, the scene that shows up when the user opens the app, contains play button, sound button, and help button

-(void)startGame; //function that starts the game by switching to gameplay screen


@end
