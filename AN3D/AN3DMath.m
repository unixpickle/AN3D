//
//  AN3DMath.c
//  AN3D
//
//  Created by Alex Nichol on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AN3DMath.h"

#pragma mark - AN3D Point -

AN3DPoint AN3DPointMake(float x, float y, float z) {
    AN3DPoint point;
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
}

BOOL AN3DPointEqualToPoint(AN3DPoint point1, AN3DPoint point2) {
    return (point1.x == point2.x && point1.y == point2.y && point1.z == point2.z);
}

#pragma mark - AN3D State -

AN3DState AN3DStateMakeDefault() {
    AN3DState state;
    bzero(&state, sizeof(state));
    state.visionScale = 1;
    state.fieldOfView = 90;
    return state;
}

AN3DPoint AN3DStateTranslate(AN3DState state, AN3DPoint point) {
    AN3DPoint translated = point;
    translated.x += state.translate.x;
    translated.y += state.translate.y;
    translated.z += state.translate.z;
    return translated;
}

void AN3DStateCalculateFieldOfView(AN3DState * state, float offset, float z, float wantOffset) {
    state->fieldOfView = (state->visionScale * 2 * atan2(offset / 2.0, -z)) / wantOffset;
}

CGPoint AN3DStateConvertTo2D(AN3DState state, AN3DPoint point) {
    AN3DPoint translated = AN3DStateTranslate(state, point);
    float newX = 0, newY = 0;
    newX = (state.visionScale * 2 * atan2(translated.x / 2.0, -translated.z)) / state.fieldOfView;
    newY = (state.visionScale * 2 * atan2(translated.y / 2.0, -translated.z)) / state.fieldOfView;
    return CGPointMake(newX, newY);
}

CGPoint AN3DStateConvertToViewCoordinates(AN3DState state, CGPoint point, CGSize viewSize) {
    CGPoint newPoint = point;
    float dispWidth = 0;
    float dispHeight = 0;
    if (viewSize.width > viewSize.height) {
        dispWidth = 1;
        dispHeight = (viewSize.height / viewSize.width);
    } else {
        dispWidth = (viewSize.width / viewSize.height);
        dispHeight = 1;
    }
    newPoint.x += dispWidth / 2.0f;
    newPoint.y += dispHeight / 2.0f;
    newPoint.x *= (viewSize.width / dispWidth);
    newPoint.y *= (viewSize.height / dispHeight);
    return newPoint;
}
