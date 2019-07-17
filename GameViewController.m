//
//  GameViewController.m
//  GP
//

#import "GameViewController.h"
#import "MenuScene.h"
//#import <FBAudienceNetwork/FBAudienceNetwork.h>

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //tạo PlacementID
//    FBAdView *adView = [[FBAdView alloc] initWithPlacementID:@"997528310286453_997529696952981"
//                                                      adSize:kFBAdSizeHeight50Banner
//                                          rootViewController:self];
//
//    //vị trí của banner ở trên (TOP)
//    adView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
//
//    //vị trí banner ở dưới (BOTTOM)
////     adView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - adView.frame.size.height, self.view.frame.size.width, 50);
//
//    //Show banner
//    [adView loadAd];
    [self.view addSubview:adView];
    
    
    
    //Leaderbord id
  //  _leaderboardIdentifier = LEADERBOARD_ID;
    
    //Check first launch
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        // app already launched
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
        
    }

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    MenuScene *scene = [MenuScene unarchiveFromFile:@"MenuScene"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.size = skView.frame.size;
    
    //iAd View settings
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adView.frame = CGRectOffset(adView.frame, 0, 0.0f);
    
    //Set iAd to buttom
    CGRect adFrame = adView.frame;
    adFrame.origin.y = self.view.frame.size.height-adView.frame.size.height;
    adView.frame = adFrame;
    
    adView.delegate=self;
    [adView setAlpha:0];
    [self.view addSubview:adView];
    
    //Save size of scene
    [[NSUserDefaults standardUserDefaults] setFloat:skView.frame.size.width forKey:@"sceneSizeWidth"];
    [[NSUserDefaults standardUserDefaults] setFloat:skView.frame.size.height forKey:@"sceneSizeHeight"];
    
    //iAd
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"hideAd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showAd" object:nil];
    //Share
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareToSocial) name:@"shareToSocial" object:nil];
    //Rate app
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rateAppCall) name:@"rateUs" object:nil];
    //Game Center
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeaderboard) name:@"showLeaderboard" object:nil];
    
   // [self authenticateLocalPlayer];
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) return UIInterfaceOrientationMaskAllButUpsideDown;
    else return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark iAd banner methods

//Handle Notification
- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"hideAd"]) [adView setAlpha:0];
    else if ([notification.name isEqualToString:@"showAd"]) [adView setAlpha:1];
}

#pragma mark Share

- (void)shareToSocial {
    NSString *textToShare = [NSString stringWithFormat:@"See, I scored %ld in this game!", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"nowScore"]];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"nowScreenShot"];
    UIImage* image = [UIImage imageWithData:imageData];
    NSArray *objectToShare = @[textToShare, image];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:objectToShare applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[];
    
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    //if iPad
    else {
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark Rate Us

- (void)rateAppCall {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Like this app?" message:@"Rate this app!" delegate:self cancelButtonTitle:@"No, thanks" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { /*Cancel button*/ }
    else if (buttonIndex == 1) { /*Yes button*/ [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LINK_TO_RATE_US]]; }
}

//#pragma mark Game Center
//
//- (void)authenticateLocalPlayer {
//    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
//    
//    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
//        if (viewController != nil) [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:viewController animated:YES completion:nil];
//        else {
//            if ([GKLocalPlayer localPlayer].authenticated) {
//                gameCenterEnabled = YES;
//    
//                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
//                    if (error != nil) NSLog(@"%@", [error localizedDescription]);
//                    else _leaderboardIdentifier = leaderboardIdentifier;
//                }];
//            }
//            else gameCenterEnabled = NO;
      //  }
   // };
//}

//- (void)showLeaderboard {
//    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
//    gcViewController.gameCenterDelegate = self;
//    gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
//    gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
//    [self presentViewController:gcViewController animated:YES completion:nil];
//}
//
//- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
//    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
//}

@end
