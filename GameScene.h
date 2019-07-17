//
//  GameScene.h
//  GP
//

#import "GlobalScene.h"

#import "GameSceneSettings.h"
#import "GameProgressSettings.h"

#import "PlayerNode.h"
#import "PlatformNode.h"
#import "OldPlatformNode.h"

@interface GameScene : GlobalScene <SKPhysicsContactDelegate> {
    int score;
    BOOL gameIsPlay;
    
    NSTimer *timeToGenerateClouds;
    NSTimer *timeToChangeScene;
    
    NSTimer *timeToJumpPlayer;
    
    BOOL avaliableToCreateNewPlatform;
    BOOL avaliableToStopPlatform;
}

@property SimpleNode *background;
@property SimpleNode *ground;
@property SimpleNode *cloud;

@property SimpleLabel *labelScore;

@property PlayerNode *player;
@property PlatformNode *platform;
@property OldPlatformNode *oldPlatform;

@property SimpleNode *bestLine;

@end
