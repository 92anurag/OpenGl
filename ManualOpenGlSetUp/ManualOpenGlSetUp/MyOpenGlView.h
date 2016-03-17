//
//  MyOpenGlView.h
//  ManualOpenGlSetUp
//
//  Created by Anurag Singhal on 3/17/16.
//  Copyright © 2016 Anurag Singhal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOpenGlView : UIView {

    GLuint displayFrameBuffer;
    GLuint colorRenderBuffer;
    int frameBufferWidth;
    int frameBufferHeight;
    EAGLContext * context;
}
-(void) draw;
@end
