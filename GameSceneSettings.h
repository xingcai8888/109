//
//  GameSceneSettings.h
//  GP
//


#ifndef GP_GameSceneSettings_h
#define GP_GameSceneSettings_h

#import "GlobalSettings.h"

#pragma mark Times
#define GS_TIME_TO_CHANGE_SCENE 1

#pragma mark Image names
#define GS_IMG_NAME_BACKGROUND @"background_GameScene"
#define GS_IMG_NAME_PLAYER @"player"
#define GS_IMG_NAME_PLAYER_DEAD @"playerDead"
#define GS_IMG_NAME_PLATFORM @"platform"
#define GS_IMG_NAME_CLOUD @"cloud"
#define GS_IMG_NAME_GROUND @"ground"
#define GS_IMG_NAME_BESTLINE @"bestLine"

#define GS_FONT_COLOR_LABEL_SCORE @"#ffffff"

#pragma mark Font Size
#define GS_FONT_SIZE_LABEL_SCORE 94

#pragma mark Sizes
#define GS_SIZE_BACKGROUND getCGSizeFromPersent(100, 100)
#define GS_SIZE_PLAYER getCGSizeFromPersentScaled(8.1, 8.7)
#define GS_SIZE_PLATFORM getCGSizeFromPersentScaled(18.6, 3.2)
#define GS_SIZE_CLOUD getCGSizeFromPersentScaled(30.1, 12.4)
#define GS_SIZE_GROUND getCGSizeFromPersentScaled(100, 52.9)
#define GS_SIZE_BESTLINE getCGSizeFromPersentScaled(100, 5)

#pragma mark Positions
#define GS_POSITION_BACKGROUND getCGPointFromPersent(50, 50)

#define GS_POSITION_LABEL_SCORE getCGPointFromPersent(50, 74)

#define GS_POSITION_PLAYER getCGPointFromPersent(50, 11.8)
#define GS_POSITION_PLATFORM getCGPointFromPersent(50, 25.8)
#define GS_POSITION_PLATFORM_LEFT getCGPointFromPersent(0, 100)
#define GS_POSITION_PLATFORM_RIGHT getCGPointFromPersent(100, 100)
#define GS_POSITION_CLOUD getCGPointFromPersent(50, 50)
#define GS_POSITION_GROUND getCGPointFromPersent(50, 14.8)

#pragma mark zPosition
#define GS_ZPOSITION_BACKGROUND 0
#define GS_ZPOSITION_BEST_LINE 2

#define GS_ZPOSITION_LABEL_SCORE 4

#define GS_ZPOSITION_PLAYER 5
#define GS_ZPOSITION_PLATFORM 6

#define GS_ZPOSITION_CLOUD 1
#define GS_ZPOSITION_GROUND 3

#endif
