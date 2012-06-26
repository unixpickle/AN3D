//
//  AN3DView.h
//  AN3D
//
//  Created by Alex Nichol on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AN3DMath.h"

@interface AN3DView : NSView {
    AN3DState state;
}

- (void)resetState;
- (AN3DState)state;
- (void)setTranslation:(AN3DPoint)t;
- (CGPoint)viewCoordinatesFor3DPoint:(AN3DPoint)point;

- (void)drawTriangles:(AN3DPoint *)points pointCount:(size_t)count;
- (void)drawRectangle:(AN3DPoint *)points;
- (void)drawCubeWithApothem:(CGFloat)a center:(AN3DPoint)point;

@end
