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
    int activeTexture1Index;
    int activeTexture2Index;
    int textureID1;
    int textureID2;
    
}
- (IBAction)updateTria:(id)sender;

@end

