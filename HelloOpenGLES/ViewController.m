//
//  ViewController.m
//  HelloOpenGLES
//
//  Created by Abhishek Verma on 3/14/16.
//  Copyright © 2016 AbhishekVerma. All rights reserved.
//

#import "ViewController.h"

float vertices[ ] = {0.5,0.5,0.0,1.0,0.0,0.0,1.0, 1,0,
                    -0.5,0.5,0.0,0.0,1.0,0.0,1.0, 0,0,
                    0.5,-0.5,0.0,0.0,0.0,1.0,1.0, 1,1,
                    -0.5,-0.5,0.0,1.0,0.0,0.0,1.0,0,1};
float right_vertices[ ] = {0.0,0.0};

float vertices1[ ] = {0.5,0.5,0.0,1.0,0.0,0.0,1.0,
                    -0.5,0.5,0.0,0.0,0.0,1.0,1.0,
                    0.5,-0.5,0.0,0.0,0.0,1.0,1.0};

//float color [] = {1.0,0.0,0.0,1.0,
//                  0.0,1.0,0.0,1.0,
//                  0.0,0.0,1.0,1.0};

unsigned char indices[] = {0,1,2};

@interface ViewController ()
-(void) initGL;
@end

@implementation ViewController


-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // get the touch point
    UITouch* touch = [touches anyObject];
    
    // get the location of the touch in the view
    CGPoint point = [touch locationInView:self.view];
    
    NSValue* value = [NSValue valueWithCGPoint:point];
    [points addObject:value];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GLKView* view = (GLKView*) self.view;
    view.context = context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    
    [EAGLContext setCurrentContext:context];
    
    shaderHelper = [[ShaderHelper alloc]init];
    programObject = [shaderHelper createProgramObject];
    
    if( programObject < 0){
        NSLog(@"Shader failed");
        return;
    } else {
        glUseProgram(programObject);
    }
    
    positionIndex = glGetAttribLocation(programObject, "a_Position");
    colorIndex = glGetAttribLocation(programObject, "a_color");
    
    modelMatrixIndex = glGetUniformLocation(programObject, "u_ModelMatrix");
    projectionMatrixIndex = glGetUniformLocation(programObject, "u_ProjectionMatrix");
    activeTextureIndex = glGetUniformLocation(programObject, "activeTexture");
    
    points = [[NSMutableArray alloc] init];
    projectionMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.width, 0, self.view.frame.size.height, 0, 1);
    glUniformMatrix4fv(projectionMatrixIndex, 1, false, projectionMatrix.m);

    [self initGL];
}

- (void) initGL{
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClearDepthf(1.0);
    
}

-(void) drawPoints {
    // write a constant value for the color attribute
    
    glVertexAttrib4f(colorIndex, 1.0, 0.0, 0.0, 1.0);
    for(NSValue* obj in points) {
        CGPoint point = [obj CGPointValue];
        float vertex[4];
        vertex[0] = point.x;
        vertex[1] = self.view.frame.size.height - point.y;
        vertex[2] = 0.0;
        vertex[3] = 1.0;
        glVertexAttrib4fv(positionIndex, vertex);
        
        glDrawArrays(GL_POINTS, 0, 1);
    }
}



- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    // clear the color buffer
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    modelMATRIX = GLKMatrix4Identity;
    glUniformMatrix4fv(modelMatrixIndex, 1, false, modelMATRIX.m);

    [self drawPoints];
    // switch to prespective projection

    glFlush();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
