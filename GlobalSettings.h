//
//  GlobalSettings.h
//  GP
//


#ifndef GP_GlobalSettings_h
#define GP_GlobalSettings_h

#pragma mark --- Global Game Settings ---

#define LINK_TO_RATE_US @"http://www.link.com/"
#define LEADERBOARD_ID @"leaderboard id"

#define degreesToRadians(angle) ((angle) / 180.0 * M_PI)

#pragma mark Image settings
#define FILTERED_IMAGE_IN_ALL_PROGECT false

#pragma mark Sizes
#define SIZE_WIDTH [[NSUserDefaults standardUserDefaults] floatForKey:@"sceneSizeWidth"]
#define SIZE_HEIGHT [[NSUserDefaults standardUserDefaults] floatForKey:@"sceneSizeHeight"]

#define getCGSizeFromPersent(width, height) CGSizeMake(SIZE_WIDTH / 100 * width, SIZE_HEIGHT / 100 * height)
#define getCGSizeFromPersentScaled(width, height) CGSizeMake(SIZE_WIDTH / 100 * width, SIZE_WIDTH / 100 * height)

#pragma mark Position
#define getCGPointFromPersent(x, y) CGPointMake(SIZE_WIDTH / 100 * x, SIZE_HEIGHT / 100 * y)

#pragma mark Font
#define FONT_NAME @"HelveticaNeue-Thin"

#pragma mark --- Collision category ---
#define playerCategory 0x1 << 0
#define platformCategory 0x1 << 1

#pragma mark --- Ad Settings ---

#pragma mark iAd show setting
#define MS_SHOW_IAD false
#define GS_SHOW_IAD false
#define ES_SHOW_IAD true

#endif
