//
//  GameScene.m
//  GP
//


#import "GameScene.h"

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    //iAd
    if (GS_SHOW_IAD) [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil];
    else [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil];
    
    //Setting game
    [self initSound];
    [self initAnimation];
    gameIsPlay = true;
    avaliableToCreateNewPlatform = true;
    avaliableToStopPlatform = true;
    score = 0;
    
    //Load physic world
    self.physicsWorld.gravity = CGVectorMake(0, -0.5);
    self.physicsWorld.contactDelegate = self;
    
    //Add nodes
    _background = [[SimpleNode alloc] initWithImageName:GS_IMG_NAME_BACKGROUND size:GS_SIZE_BACKGROUND position:GS_POSITION_BACKGROUND andZPosition:GS_ZPOSITION_BACKGROUND];
    _ground = [[SimpleNode alloc] initWithImageName:GS_IMG_NAME_GROUND size:GS_SIZE_GROUND position:GS_POSITION_GROUND andZPosition:GS_ZPOSITION_GROUND];
    
    _labelScore = [[SimpleLabel alloc] initWithText:[NSString stringWithFormat:@"%d", score] fontSize:GS_FONT_SIZE_LABEL_SCORE position:GS_POSITION_LABEL_SCORE colorByHEX:GS_FONT_COLOR_LABEL_SCORE andZPosition:GS_ZPOSITION_LABEL_SCORE];
    
    _player = [[PlayerNode alloc] initWithImageName:GS_IMG_NAME_PLAYER size:GS_SIZE_PLAYER position:GS_POSITION_PLAYER andZPosition:GS_ZPOSITION_PLAYER];
    
    [self addChild:_background];
    [self addChild:_ground];
    
    [self addChild:_labelScore];
    
    [self addChild:_player];
    
    [self setNewPlatform];
    
    //Other
    [self startGame];
}

#pragma mark --- Nodes ---

- (void)setNewPlatform {
    _platform = [[PlatformNode alloc] initWithImageName:GS_IMG_NAME_PLATFORM size:GS_SIZE_PLATFORM andZPosition:GS_ZPOSITION_PLATFORM];
    [self addChild:_platform];
    
    [_platform startMoving];
}

- (void)setOldPlatformToPosition:(CGPoint)position withDelay:(BOOL)delay {
    _oldPlatform = [[OldPlatformNode alloc] initWithImageName:GS_IMG_NAME_PLATFORM size:GS_SIZE_PLATFORM position:position andZPosition:GS_ZPOSITION_PLATFORM];
    [self addChild:_oldPlatform];
    
    [_oldPlatform moveDownWithDelay:delay];
}

- (void)setBestLine {
    _bestLine = [[SimpleNode alloc] initWithImageName:GS_IMG_NAME_BESTLINE size:GS_SIZE_BESTLINE position:GS_POSITION_PLATFORM andZPosition:GS_ZPOSITION_BEST_LINE];
    [self addChild:_bestLine];
    
    [_bestLine runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0], [SKAction fadeInWithDuration:TIME_TO_SHOW_BEST_LINE]]]];
}

- (void)removeBestLine {
    [_bestLine runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:TIME_TO_HIDE_BEST_LINE], [SKAction removeFromParent]]]];
}

- (void)setCloud {
    for (int i = 0; i < COUNT_OF_CLOUDS_IN_ONE_GENERATION; i++) {
        //get position
        CGPoint positionOfCloud;
        CGSize sizeOfCloud = GS_SIZE_CLOUD;
        int randomPosition = arc4random() % 2;
        if (randomPosition == 0) positionOfCloud = CGPointMake(-(sizeOfCloud.width / 2), [self randomFloatBetween:0.0f and:SIZE_HEIGHT]);
        else positionOfCloud = CGPointMake(SIZE_WIDTH + sizeOfCloud.width / 2, [self randomFloatBetween:0.0f and:SIZE_HEIGHT]);
        
        //Set node
        _cloud = [[SimpleNode alloc] initWithImageName:GS_IMG_NAME_CLOUD size:sizeOfCloud position:positionOfCloud andZPosition:GS_ZPOSITION_CLOUD];
        _cloud.alpha = [self randomFloatBetween:CLOUD_ALPHA_FROM and:CLOUD_ALPHE_TO];
        [_cloud setScale:[self randomFloatBetween:SCALE_CLOUD_FROM and:SCALE_CLOUD_TO]];
        [self addChild:_cloud];
        
        //Set animation
        if (randomPosition) [_cloud runAction:[SKAction sequence:@[[SKAction moveToX:_cloud.position.y - DESTANTION_FOR_MOVE_CLOUD duration:TIME_TO_MOVE_CLOUD], [SKAction removeFromParent]]]];
        else [_cloud runAction:[SKAction sequence:@[[SKAction moveToX:_cloud.position.y + DESTANTION_FOR_MOVE_CLOUD duration:TIME_TO_MOVE_CLOUD], [SKAction removeFromParent]]]];
    }
}

#pragma mark --- Game progress ---

- (void)startGame {
    [self setCloud];
    timeToGenerateClouds = [NSTimer scheduledTimerWithTimeInterval:TIME_TO_GENERATION_CLOUD target:self selector:@selector(setCloud) userInfo:nil repeats:true];
}

- (void)endGame {
    [timeToGenerateClouds invalidate];
    gameIsPlay = false;
    
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"nowScore"];
    [sound playSoundByName:@"endGame"];
    
    timeToChangeScene = [NSTimer scheduledTimerWithTimeInterval:GS_TIME_TO_CHANGE_SCENE target:self selector:@selector(changeScene) userInfo:nil repeats:false];
}

- (void)changeScene {
    [self makeScreenShot];
    [self changeSceneToSceneName:@"EndScene" andAnimationName:@"Nil"];
}

- (void)changeScore {
    score++;
    _labelScore.text = [NSString stringWithFormat:@"%d", score];
    [sound playSoundByName:@"getPoint"];
}

- (void)endJump {
    if (avaliableToStopPlatform) {
        if (score == 0) {
            avaliableToCreateNewPlatform = true;
            avaliableToStopPlatform = true;
        }
        else {
            [self endGame];
            
            [self setGroundToStartPosition];
            [_player playerIsDeath];
            [_platform removePlatform];
        }
    }
    else {
        avaliableToCreateNewPlatform = true;
        avaliableToStopPlatform = true;
        
        [self changeScore];
        [self setGroundPosition];
        
        //Set best line
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"bestScore"] - 1 == score) [self setBestLine];
        else [self removeBestLine];
    }
}

- (void)setGroundPosition {
    CGSize groundSize = GS_SIZE_GROUND;
    [_ground runAction:[SKAction moveToY:groundSize.height / 2 - (groundSize.height / 10 * score) duration:TIME_TO_MOVE_GROUND]];
}

- (void)setGroundToStartPosition {
    [_ground runAction:[SKAction moveTo:GS_POSITION_GROUND duration:TIME_TO_MOVE_GROUND_IF_FALL]];
}

#pragma mark --- Action ---

#pragma mark Contact

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (gameIsPlay) {
        SKPhysicsBody *firstBody, *secondBody;
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        }
        else{
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        if ((firstBody.categoryBitMask & playerCategory) != 0) [self playerContactBegin:(SKSpriteNode *)firstBody.node didCollideWithTarget:(SKSpriteNode *)secondBody.node];
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    if (gameIsPlay) {
        SKPhysicsBody *firstBody, *secondBody;
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        }
        else{
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        if ((firstBody.categoryBitMask & playerCategory) != 0) [self playerContactEnd:(SKSpriteNode *)firstBody.node didCollideWithTarget:(SKSpriteNode *)secondBody.node];
    }
}

- (void)playerContactBegin:(SKSpriteNode *)player didCollideWithTarget:(SKSpriteNode *)target {
    if (avaliableToStopPlatform) {
        if (target.physicsBody.categoryBitMask == platformCategory) {
            avaliableToStopPlatform = false;
        }
    }
}

- (void)playerContactEnd:(SKSpriteNode *)player didCollideWithTarget:(SKSpriteNode *)target {
    if (avaliableToCreateNewPlatform) {
        if (target.physicsBody.categoryBitMask == platformCategory) {
            avaliableToCreateNewPlatform = false;
            
            if ([_player playerFallDown]) [self setOldPlatformToPosition:target.position withDelay:false];
            else [self setOldPlatformToPosition:target.position withDelay:true];
            
            [target removeAllActions];
            [target removeFromParent];
            [self setNewPlatform];
        }
    }
}

#pragma mark Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (gameIsPlay) {
        [_player jump];
        [_oldPlatform removeOldPlatform];
        
        //Rotate player
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            
            if (location.x >= SIZE_WIDTH / 2) _player.xScale = 1.0;
            else _player.xScale = -1.0;
        }
            
        timeToJumpPlayer = [NSTimer scheduledTimerWithTimeInterval:TIME_PLAYER_JUMP_DOWN + TIME_PLAYER_JUMP_UP target:self selector:@selector(endJump) userInfo:nil repeats:false];
    }
}

@end
