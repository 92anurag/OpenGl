//
//  MyOpenGlView.m
//  ManualOpenGlSetUp
//
//  Created by Anurag Singhal on 3/17/16.
//  Copyright © 2016 Anurag Singhal. All rights reserved.
//

#import "MyOpenGlView.h"
#import <OPENGLES/ES2/gl.h>
@implementation MyOpenGlView
+(Class)layerClass {
    return [CAEAGLLayer class];
}

-(int) initializeFrameBuffer {
    glGenFramebuffers(1, &displayFrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, displayFrameBuffer);
    
    //CREATE a render buffer for the framebuffer
    GLuint rbo;
    glGenRenderbuffers(1, &rbo);
    glBindRenderbuffer(GL_RENDERBUFFER, rbo);
    colorRenderBuffer = rbo;
    CAEAGLLayer* layer = (CAEAGLLayer* ) self.layer ;
    //allocate memory for rbo
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &frameBufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &frameBufferHeight);
    
    // attach the rbo to the fbo
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, rbo);
    
    // create a depth buffer for the FBO
    
    GLuint depthRBO ;
    glGenRenderbuffers(1, &depthRBO);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRBO);
    
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, frameBufferWidth, frameBufferHeight);
    
    // attach the depth buffer to the fbo
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRBO);
    GLenum  success = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if(success == GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"successfully created a framebuffer");
    }
    
    return displayFrameBuffer;
    
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if(self) {
        // create openGl context
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        // make the context as current
        [EAGLContext setCurrentContext:context];
        
        // create the display frame buffer
        [self initializeFrameBuffer];
        
        //[self draw];
    }
    return self;
}

-(void) draw {
    // bind to the display frame buffer
    glBindFramebuffer(GL_FRAMEBUFFER, displayFrameBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    glClearColor(1.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // make opengl calls
    [context presentRenderbuffer:GL_RENDERBUFFER];
}

@end
