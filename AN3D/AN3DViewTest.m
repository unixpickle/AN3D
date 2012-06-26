//
//  AN3DViewTest.m
//  AN3D
//
//  Created by Alex Nichol on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AN3DViewTest.h"

@implementation AN3DViewTest

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        if (!animationTimer) {
            animationTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0)
                                                              target:self
                                                            selector:@selector(animationTimer)
                                                            userInfo:nil repeats:YES];
        }
        xVel = 0.26;
        yVel = 0.2;
        zVel = -0.3;
    }
    return self;
}

- (id)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
        if (!animationTimer) {
            animationTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0)
                                                              target:self
                                                            selector:@selector(animationTimer)
                                                            userInfo:nil repeats:YES];
        }
    }
    return self;
}

- (void)animationTimer {
    float xLimit = 0.375;
    float yLimit = 0.375;
    float zMax = -1.125;
    float zMin = -3;
    
    static NSDate * lastDate = nil;
    if (!lastDate) {
        lastDate = [NSDate date];
        return;
    }
    NSDate * newDate = [NSDate date];
    NSTimeInterval elapsed = [newDate timeIntervalSinceDate:lastDate];
    cubeX += elapsed * xVel;
    cubeY += elapsed * yVel;
    cubeZ += elapsed * zVel;
    if (cubeX > xLimit) {
        cubeX = xLimit;
        xVel = -ABS(xVel);
    } else if (cubeX < -xLimit) {
        cubeX = -xLimit;
        xVel = ABS(xVel);
    }
    if (cubeY > yLimit) {
        cubeY = yLimit;
        yVel = -ABS(yVel);
    } else if (cubeY < -yLimit) {
        cubeY = -yLimit;
        yVel = ABS(yVel);
    } else {
        //yVel -= 0.1 * elapsed;
        //if (yVel > 3) yVel = 3;
        //else if (yVel < -3) yVel = -3;
    }
    if (cubeZ > zMax) {
        cubeZ = zMax;
        zVel = -ABS(zVel);
    } else if (cubeZ < zMin) {
        cubeZ = zMin;
        zVel = ABS(zVel);
    }
    [self setNeedsDisplay:YES];
    lastDate = newDate;
}

- (void)drawWalls {
    float width = 0.5;
    float height = 0.5;
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    AN3DPoint leftWall[] = {AN3DPointMake(-width, height, -1),
        AN3DPointMake(-width, height, -3.125),
        AN3DPointMake(-width, -height, -3.125),
        AN3DPointMake(-width, -height, -1)};
    AN3DPoint rightWall[] = {AN3DPointMake(width, height, -1),
        AN3DPointMake(width, height, -3.125),
        AN3DPointMake(width, -height, -3.125),
        AN3DPointMake(width, -height, -1)};
    AN3DPoint topWall[] = {AN3DPointMake(-width, height, -1),
        AN3DPointMake(-width, height, -3.125),
        AN3DPointMake(width, height, -3.125),
        AN3DPointMake(width, height, -1)};
    AN3DPoint bottomWall[] = {AN3DPointMake(-width, -height, -1),
        AN3DPointMake(-width, -height, -3.125),
        AN3DPointMake(width, -height, -3.125),
        AN3DPointMake(width, -height, -1)};
    CGContextSetRGBFillColor(context, 1, 0, 0, 1);
    [self drawRectangle:bottomWall];
    [self drawRectangle:topWall];
    CGContextSetRGBFillColor(context, 0, 1, 0, 1);
    [self drawRectangle:leftWall];
    [self drawRectangle:rightWall];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [self drawWalls];
    [self drawCubeWithApothem:0.125 center:AN3DPointMake(cubeX, cubeY, cubeZ)];
}

@end
