//
//  GameProgressSettings.h
//  GP
//

#ifndef GP_GameProgressSettings_h
#define GP_GameProgressSettings_h

#import "GlobalSettings.h"

#pragma mark --- Game settings ---
#define HEIGHT_OF_PLAYER_JUMP SIZE_WIDTH / 100 * 45

//Cloud
#define COUNT_OF_CLOUDS_IN_ONE_GENERATION 3
#define DESTANTION_FOR_MOVE_CLOUD SIZE_WIDTH * 2

#define SCALE_CLOUD_FROM 1
#define SCALE_CLOUD_TO 0.5

#define CLOUD_ALPHA_FROM 1
#define CLOUD_ALPHE_TO 0.46

#pragma mark --- Time ---

#pragma mark Times
#define TIME_PLAYER_JUMP_UP 0.32
#define TIME_PLAYER_JUMP_DOWN 0.2

//Platform
#define TIME_TO_MOVE_PLATFORM_FROM 0.6
#define TIME_TO_MOVE_PLATFORM_TO 2.1

#define TIME_TO_MOVE_PLATFORM_TO_PLAYER 0.4
#define TIME_TO_MOVE_PLATFORM_TO_CENTER_IF_STOP_MOVING_BY_X 0.2
#define DELAY_TO_MOVE_PLATFORM_DOWN 0.16

#define TIME_TO_REMOVE_NEW_NODE_IF_LOSE 0.17
#define TIME_TO_REMOVE_OLD_NODE 0.2

//Ground
#define TIME_TO_MOVE_GROUND 0.5
#define TIME_TO_MOVE_GROUND_IF_FALL 0.12

//Best line
#define TIME_TO_SHOW_BEST_LINE 0.25
#define TIME_TO_HIDE_BEST_LINE 0.15

//Cloud
#define TIME_TO_GENERATION_CLOUD 4.1
#define TIME_TO_MOVE_CLOUD 15.6

#endif
