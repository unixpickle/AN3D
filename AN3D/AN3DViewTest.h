//
//  AN3DViewTest.h
//  AN3D
//
//  Created by Alex Nichol on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AN3DView.h"
#import <Quartz/Quartz.h>

@interface AN3DViewTest : AN3DView {
    NSTimer * animationTimer;
    float cubeX, cubeY, cubeZ;
    float xVel, yVel, zVel;
}

- (void)animationTimer;
- (void)drawWalls;

@end
