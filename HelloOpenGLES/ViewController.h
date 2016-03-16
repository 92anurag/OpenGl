//
//  ViewController.h
//  HelloOpenGLES
//
//  Created by Abhishek Verma on 3/14/16.
//  Copyright © 2016 AbhishekVerma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "ShaderHelper.h"
#import "Planet1.h"

@interface ViewController : GLKViewController {
    EAGLContext* context;
    ShaderHelper* shaderHelper;
    int programObject;
    int positionIndex;
    int colorIndex;
    unsigned int triangleVBO;
    int offsetIndex;
    int modelMatrixIndex;
    int projectionMatrixIndex;
    int viewMatrixIndex;
    float xPosOffset;
    GLKMatrix4 modelMATRIX;
    float angle;
    float scale;
    GLKMatrix4 projectionMatrix;
    GLKMatrix4 viewMatrix;
    float zpos;
    int textureCoordinateIndex;
    int activeTextureIndex;
    int textureID;
    Planet* sun;
    Planet* moon;
    Planet* earth;
    GLKTextureInfo *backgroundTexture;
}
- (IBAction)updateTria:(id)sender;

@end

