//
//  AN3DView.m
//  AN3D
//
//  Created by Alex Nichol on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AN3DView.h"

@implementation AN3DView

- (id)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
        [self resetState];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self resetState];
    }
    return self;
}

- (void)setFrame:(NSRect)frameRect {
    [super setFrame:frameRect];
    [self resetState];
}

- (void)resetState {
    state = AN3DStateMakeDefault();
    state.visionScale = 1;
    AN3DStateCalculateFieldOfView(&state, 0.5, -1, 0.5);
}

- (AN3DState)state {
    return state;
}

- (void)setTranslation:(AN3DPoint)t {
    state.translate = t;
}

- (CGPoint)viewCoordinatesFor3DPoint:(AN3DPoint)point {
    CGPoint untPoint = AN3DStateConvertTo2D(state, point);
    return AN3DStateConvertToViewCoordinates(state, untPoint, self.frame.size);
}

- (void)drawTriangles:(AN3DPoint *)points pointCount:(size_t)count {
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGSize ourSize = self.frame.size;
    CGContextBeginPath(context);
    for (size_t i = 0; i < count - 2; i += 3) {
        CGPoint p1 = AN3DStateConvertTo2D(state, points[i]);
        CGPoint p2 = AN3DStateConvertTo2D(state, points[i + 1]);
        CGPoint p3 = AN3DStateConvertTo2D(state, points[i + 2]);
        p1 = AN3DStateConvertToViewCoordinates(state, p1, ourSize);
        p2 = AN3DStateConvertToViewCoordinates(state, p2, ourSize);
        p3 = AN3DStateConvertToViewCoordinates(state, p3, ourSize);
        
        CGContextMoveToPoint(context, p1.x, p1.y);
        CGContextAddLineToPoint(context, p2.x, p2.y);
        CGContextAddLineToPoint(context, p3.x, p3.y);
        CGContextAddLineToPoint(context, p1.x, p1.y);
    }
    CGContextFillPath(context);
}

- (void)drawRectangle:(AN3DPoint *)points {
    AN3DPoint triangles[6] = {points[0], points[1], points[2],
        points[2], points[3], points[0]};
    [self drawTriangles:triangles pointCount:6];
}

- (void)drawCubeWithApothem:(CGFloat)a center:(AN3DPoint)origPoint {
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    AN3DPoint point = AN3DStateTranslate(self.state, origPoint);
    
    if (point.z - a > 0) return;
    
    // drawing order
    BOOL topBlocking = NO;
    BOOL bottomBlocking = NO;
    BOOL leftBlocking = NO;
    BOOL rightBlocking = NO;
    if (point.x + a < 0) {
        rightBlocking = YES;
    } else if (point.x - a > 0) {
        leftBlocking = YES;
    }
    if (point.y + a < 0) {
        topBlocking = YES;
    } else if (point.y - a > 0) {
        bottomBlocking = YES;
    }
    
    // generate faces
    AN3DPoint leftFace[] = {AN3DPointMake(point.x - a, point.y - a, point.z - a),
        AN3DPointMake(point.x - a, point.y + a, point.z - a),
        AN3DPointMake(point.x - a, point.y + a, point.z + a),
        AN3DPointMake(point.x - a, point.y - a, point.z + a)};
    CGFloat leftColor = 0.4;
    
    AN3DPoint rightFace[] = {AN3DPointMake(point.x + a, point.y - a, point.z - a),
        AN3DPointMake(point.x + a, point.y + a, point.z - a),
        AN3DPointMake(point.x + a, point.y + a, point.z + a),
        AN3DPointMake(point.x + a, point.y - a, point.z + a)};
    CGFloat rightColor = 0.4;
    
    AN3DPoint topFace[] = {AN3DPointMake(point.x - a, point.y + a, point.z - a),
        AN3DPointMake(point.x + a, point.y + a, point.z - a),
        AN3DPointMake(point.x + a, point.y + a, point.z + a),
        AN3DPointMake(point.x - a, point.y + a, point.z + a)};
    CGFloat topColor = 0.3;
    
    AN3DPoint bottomFace[] = {AN3DPointMake(point.x - a, point.y - a, point.z - a),
        AN3DPointMake(point.x + a, point.y - a, point.z - a),
        AN3DPointMake(point.x + a, point.y - a, point.z + a),
        AN3DPointMake(point.x - a, point.y - a, point.z + a)};
    CGFloat bottomColor = 0.3;
    
    AN3DPoint backFace[] = {AN3DPointMake(point.x - a, point.y - a, point.z - a),
        AN3DPointMake(point.x + a, point.y - a, point.z - a),
        AN3DPointMake(point.x + a, point.y + a, point.z - a),
        AN3DPointMake(point.x - a, point.y + a, point.z - a)};
    CGFloat backColor = 0.5;
    
    AN3DPoint frontFace[] = {AN3DPointMake(point.x - a, point.y - a, point.z + a),
        AN3DPointMake(point.x + a, point.y - a, point.z + a),
        AN3DPointMake(point.x + a, point.y + a, point.z + a),
        AN3DPointMake(point.x - a, point.y + a, point.z + a)};
    CGFloat frontColor = 0.5;
    
    // draw back face
    CGContextSetGrayFillColor(context, backColor, 1);
    [self drawRectangle:backFace];
    
    // draw non-priority faces
    if (!topBlocking) {
        CGContextSetGrayFillColor(context, topColor, 1);
        [self drawRectangle:topFace];
    }
    if (!bottomBlocking) {
        CGContextSetGrayFillColor(context, bottomColor, 1);
        [self drawRectangle:bottomFace];
    }
    if (!leftBlocking) {
        CGContextSetGrayFillColor(context, leftColor, 1);
        [self drawRectangle:leftFace];
    }
    if (!rightBlocking) {
        CGContextSetGrayFillColor(context, rightColor, 1);
        [self drawRectangle:rightFace];
    }
    
    // draw priority faces
    if (topBlocking) {
        CGContextSetGrayFillColor(context, topColor, 1);
        [self drawRectangle:topFace];
    } else if (bottomBlocking) {
        CGContextSetGrayFillColor(context, bottomColor, 1);
        [self drawRectangle:bottomFace];
    }
    if (leftBlocking) {
        CGContextSetGrayFillColor(context, leftColor, 1);
        [self drawRectangle:leftFace];
    } else if (rightBlocking) {
        CGContextSetGrayFillColor(context, rightColor, 1);
        [self drawRectangle:rightFace];
    }
    
    // maybe draw front face
    if (point.z + a < 0) {
        CGContextSetGrayFillColor(context, frontColor, 1);
        [self drawRectangle:frontFace];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [self resetState];
}

@end
