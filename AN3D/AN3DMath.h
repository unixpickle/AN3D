//
//  AN3DMath.h
//  AN3D
//
//  Created by Alex Nichol on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#ifndef AN3D_AN3DMath_h
#define AN3D_AN3DMath_h

#pragma mark - AN3D Point -

typedef struct {
    float x;
    float y;
    float z;
} AN3DPoint;

AN3DPoint AN3DPointMake(float x, float y, float z);
BOOL AN3DPointEqualToPoint(AN3DPoint point1, AN3DPoint point2);

#pragma mark - AN3D State -

typedef struct {
    float visionScale;
    float fieldOfView;
    AN3DPoint translate;
} AN3DState;

AN3DState AN3DStateMakeDefault();
AN3DPoint AN3DStateTranslate(AN3DState state, AN3DPoint point);
void AN3DStateCalculateFieldOfView(AN3DState * state, float offset, float z, float wantOffset);
CGPoint AN3DStateConvertTo2D(AN3DState state, AN3DPoint point);
CGPoint AN3DStateConvertToViewCoordinates(AN3DState state, CGPoint point, CGSize viewSize);

#endif
