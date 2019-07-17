//
//  GameScene.m
//  GP
//


#import "GlobalScene.h"

#import "MenuScene.h"
#import "GameScene.h"
#import "EndScene.h"

@implementation GlobalScene

#pragma mark Initital Components

- (void)initSound {
    sound = [[Sound alloc] init];
}

- (void)initAnimation {
    animation = [[Animation alloc] init];
}

#pragma mark Work with data

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

#pragma mark Screen Shot

- (void)makeScreenShot {
    //Get a UIImage from the UIView
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *endGameScreenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Save screen shot
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(endGameScreenShot) forKey:@"nowScreenShot"];
}

#pragma mark Change Scene

- (void)changeSceneToSceneName:(NSString *)nameScene andAnimationName:(NSString *)nameAnimation {
    SKScene *scene = [self getSceneByName:nameScene];
    SKTransition *animation = [self getAnimationForChangeSceneByName:nameAnimation];
    
    if (scene) {
        if (animation) [self.view presentScene:scene transition:animation];
        else [self.view presentScene:scene];
    }
}

- (SKScene *)getSceneByName:(NSString *)name {
    if ([name isEqual:@"MenuScene"]) return [[MenuScene alloc] initWithSize:self.size];
    else if ([name isEqualToString:@"GameScene"]) return [[GameScene alloc] initWithSize:self.size];
    else if ([name isEqualToString:@"EndScene"]) return [[EndScene alloc] initWithSize:self.size];
    else return nil;
}

- (SKTransition *)getAnimationForChangeSceneByName:(NSString *)name {
    if ([name isEqualToString:@"Fade"]) return [SKTransition fadeWithDuration:1];
    else if ([name isEqualToString:@"MoveDown"]) return [SKTransition moveInWithDirection:SKTransitionDirectionDown duration:1];
    else if ([name isEqualToString:@"MoveUp"]) return [SKTransition moveInWithDirection:SKTransitionDirectionUp duration:1];
    else return nil;
}

@end
