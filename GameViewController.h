//
//  GameViewController.h
//  GP
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAD.h>
#import <AVFoundation/AVFoundation.h>
#import <GameKit/GameKit.h>
#import "GlobalSettings.h"

@interface GameViewController : UIViewController <ADBannerViewDelegate>{
    ADBannerView *adView;
    
    BOOL gameCenterEnabled;
}

//@property NSString *leaderboardIdentifier;

//-(void)authenticateLocalPlayer;

@end
