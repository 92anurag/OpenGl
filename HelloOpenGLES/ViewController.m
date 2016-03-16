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
-(void) initTriangleVBO;
-(int) loadtexture: (NSString*) fileName;

    
@end

@implementation ViewController

-(int) loadtexture:(NSString*) fileName {
    
    //generate the texture ID
    GLuint textureId;
    glGenTextures(1,&textureId);
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if(!spriteImage) {
        NSLog(@"Failed to lod image %@",fileName);
        exit(1);
    }
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte *spriteData = (GLubyte *)calloc(width*height*4 , sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    // bind to texture
    glBindTexture(GL_TEXTURE_2D, textureId);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    glBindTexture(GL_TEXTURE_2D,0);
    free(spriteData);
    return textureId;

}

-(void) initTriangleVBO {
    //create an identifir for the VBO
    glGenBuffers(1, &triangleVBO);
    // Bind to VBO
    glBindBuffer(GL_ARRAY_BUFFER, triangleVBO);
    // copy vertex data to VBO
    glBufferData(GL_ARRAY_BUFFER,sizeof(float)*21, vertices1, GL_STATIC_DRAW);
    //unbind from VBO
    glBindBuffer(GL_ARRAY_BUFFER, 0);
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
    //offsetIndex = glGetUniformLocation(programObject, "u_PositionOffset");
    
    modelMatrixIndex = glGetUniformLocation(programObject, "u_ModelMatrix");
    projectionMatrixIndex = glGetUniformLocation(programObject, "u_ProjectionMatrix");
    viewMatrixIndex = glGetUniformLocation(programObject, "u_ViewMatrix");
    activeTextureIndex = glGetUniformLocation(programObject, "activeTexture");
    textureCoordinateIndex = glGetAttribLocation(programObject, "a_TextureCoordinate");
    angle =0;
    scale =1;
    zpos = 5.0;
    [self initGL];
    [self initTriangleVBO];
}

- (void) initGL{
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClearDepthf(1.0);
    
    //glEnable(GL_CULL_FACE); // culling enabling
    glEnable(GL_DEPTH_TEST);
    projectionMatrix = GLKMatrix4Identity;
    // projectionMatrix = GLKMatrix4MakeFrustum(-2.0, 2.0, -2.0, 2.0, 0.1, 100.0);
    
    float aspect = (float)self.view.bounds.size.width / (float)self.view.bounds.size.height ;
    projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45), aspect, 0.1, 100.0);
    glUniformMatrix4fv(projectionMatrixIndex, 1, false, projectionMatrix.m);
    
    glEnable(GL_TEXTURE_2D);
    textureID = [self loadtexture:@"hello.png"];
    
}

-(void) drawTriangle {
    //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnableVertexAttribArray(positionIndex);
    glEnableVertexAttribArray(colorIndex);
    glBindBuffer(GL_ARRAY_BUFFER, triangleVBO);
    glVertexAttribPointer(positionIndex, 3, GL_FLOAT, false, 28, 0);
    glVertexAttribPointer(colorIndex, 4, GL_FLOAT, false, 28, (void*)12);// vertex buffer object works in bytes
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glDisableVertexAttribArray(positionIndex);
    glDisableVertexAttribArray(colorIndex);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

-(void) changeVertices{
    glBindBuffer(GL_ARRAY_BUFFER, triangleVBO);
    glBufferSubData(GL_ARRAY_BUFFER, 28, 12,right_vertices);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

-(void) drawIndices {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnableVertexAttribArray(positionIndex);
    glEnableVertexAttribArray(colorIndex);
    glVertexAttribPointer(positionIndex, 3, GL_FLOAT, false, 28, vertices1);
    glVertexAttribPointer(colorIndex, 4, GL_FLOAT, false, 28, vertices1 + 3);
    glDrawElements(GL_TRIANGLES, 3,GL_UNSIGNED_BYTE,indices);
    glDisableVertexAttribArray(positionIndex);
    glDisableVertexAttribArray(colorIndex);
}


-(void) drawSquare {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //
    glActiveTexture(GL_TEXTURE0);
    
    glBindTexture(GL_TEXTURE_2D,textureID);
    
    glUniform1i(activeTextureIndex, 0);
    glEnableVertexAttribArray(positionIndex);
    glEnableVertexAttribArray(colorIndex);
    glEnableVertexAttribArray(textureCoordinateIndex);
    glVertexAttribPointer(positionIndex, 3, GL_FLOAT, false, 36, vertices);
    glVertexAttribPointer(colorIndex, 4, GL_FLOAT, false, 36, vertices+3);
    glVertexAttribPointer(textureCoordinateIndex, 2, GL_FLOAT, false, 36, vertices + 7);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDisableVertexAttribArray(positionIndex);
    glDisableVertexAttribArray(colorIndex);
    glDisableVertexAttribArray(textureCoordinateIndex);
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    xPosOffset += 0.01;
    if(xPosOffset >= 1.0) {
        xPosOffset = -1.0;
    }
    //rending function, need to set up the clearing color
    
    angle += 1.0;
    
    if(angle >= 360.0){
        angle= 0.0;
    }
    
    scale += 0.01;
    if(scale >=2){
        scale = 0.5;
    }
    
    zpos += 0.2;
    if(zpos >15.0){
        zpos = 5.0;
    }
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    viewMatrix    = GLKMatrix4Identity;
    viewMatrix = GLKMatrix4MakeLookAt(0,0,zpos,0,0,0,0,1,0);
    glUniformMatrix4fv(viewMatrixIndex, 1,false, viewMatrix.m);
    
    
    modelMATRIX    = GLKMatrix4Identity;
    //modelMATRIX = GLKMatrix4Translate(modelMATRIX, 0.0, 0.0, -1.0);
    modelMATRIX = GLKMatrix4Rotate(modelMATRIX, GLKMathDegreesToRadians(angle), 0.0, 1.0, 0.0);
    modelMATRIX = GLKMatrix4Scale(modelMATRIX, 0.8, 0.8, 0.8);
    glUniformMatrix4fv(modelMatrixIndex, 1,false, modelMATRIX.m);
    
    
    [self drawSquare];
    
    modelMATRIX = GLKMatrix4Translate(modelMATRIX, 1.0, 0.0, 0.0);
    modelMATRIX = GLKMatrix4Rotate(modelMATRIX, -1 * GLKMathDegreesToRadians(angle), 0.0, 1.0, 0.0);
    modelMATRIX = GLKMatrix4Scale(modelMATRIX, 0.8, 0.8, 0.8);
    glUniformMatrix4fv(modelMatrixIndex, 1,false, modelMATRIX.m);
    
    [self drawTriangle];
    
    glFlush();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateTria:(id)sender {
    [self changeVertices];
}
@end
