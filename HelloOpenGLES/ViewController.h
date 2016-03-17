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
    int textureCoordinateIndex;
    int activeTextureIndex;
    int textureID;
    
    int modelMatrixIndex;
    GLKMatrix4 modelMATRIX;
    float angle;
    float scale;
    
    int projectionMatrixIndex;
    GLKMatrix4 projectionMatrix;

    float zpos;
    GLKTextureInfo *backgroundTexture;
    NSMutableArray* points;
}
@end

