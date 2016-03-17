//
//  ShaderHelper.m
//  HelloOpenGLES
//
//  Created by Abhishek Verma on 3/14/16.
//  Copyright © 2016 AbhishekVerma. All rights reserved.
//

#import "ShaderHelper.h"
#import <OPENGLES/ES2/gl.h>


const char* V_SRC = "attribute vec4 a_Position;     \n"
                    "attribute vec4 a_color;  \n"
                    "varying vec4 v_color;   \n"
                    "uniform mat4 u_ModelMatrix;   \n"
                    "uniform mat4 u_ProjectionMatrix;\n"
                    "void main() {          \n"
                    "   gl_Position =  u_ProjectionMatrix * u_ModelMatrix * a_Position;\n"
                    "   v_color = a_color;      \n   "
                    " gl_PointSize = 4.0; \n"
                    "}";


const char* F_SRC = ""
                    "precision highp float; \n"
                    " varying vec4 v_color;   \n"
                    "void main() {          \n"
                    "   gl_FragColor = v_color;\n"
                    "}";

@interface ShaderHelper()
-(int) createShaderOfType:(GLenum) type WithSrc:(const char*)src;
@end


@implementation ShaderHelper

-(int) createShaderOfType:(GLenum) type WithSrc:(const char*)src{
    int shaderObj = glCreateShader(type);
    
    if( shaderObj < 0){
        NSLog(@"Unable to create shader object of type %d", type);
        return -1;
    }
    
    //add source code to the shader object
    glShaderSource(shaderObj, 1, &src, 0);
    
    //compile the shader
    glCompileShader(shaderObj);
    
    //get the shader compilation status
    GLint success;
    glGetShaderiv(shaderObj, GL_COMPILE_STATUS, &success);
    
    if( success == GL_TRUE){
        NSLog(@"Shader Compiled Successfully");
        return shaderObj;
    } else {
        //getting the lenght of the log from the compiler
        GLint length;
        glGetShaderiv(shaderObj, GL_INFO_LOG_LENGTH, &length);
        
        char * info = (char *)malloc(length);
        GLsizei l;
        glGetShaderInfoLog(shaderObj, length, &l, info);
        
        printf("Compiler error %s", info);
        return -1;
    }
    
    return -1;
}

-(int) createProgramObject{
    int vertShaderObj = [self createShaderOfType:GL_VERTEX_SHADER WithSrc:V_SRC];
    int fragShaderObj = [self createShaderOfType:GL_FRAGMENT_SHADER WithSrc:F_SRC];
    
    if ( vertShaderObj < 0 || fragShaderObj < 0){
        return -1;
    }
    
    //crate a program object
    int programObject = glCreateProgram();
    
    //attach vertext shader object and fragment shader object to program object
    glAttachShader(programObject, vertShaderObj);
    glAttachShader(programObject, fragShaderObj);
    
    //link shader
    glLinkProgram(programObject);
    
    //check if linking successful
    GLint success;
    glGetProgramiv(programObject, GL_LINK_STATUS, &success);
    if( success == GL_TRUE){
        NSLog(@"Shader Linker successfully");
        return programObject;
    } else {
        NSLog(@"Shader linking failed");
    }
    
    return -1;
}

@end
