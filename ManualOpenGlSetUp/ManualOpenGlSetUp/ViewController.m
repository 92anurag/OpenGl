//
//  ViewController.m
//  ManualOpenGlSetUp
//
//  Created by Anurag Singhal on 3/17/16.
//  Copyright © 2016 Anurag Singhal. All rights reserved.
//

#import "ViewController.h"
#import "MYOpenGlView.h"
@interface ViewController ()

@end

@implementation ViewController


-(void) startRendering {
    if(displayLink == nil){
        displayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(drawFrame:)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

-(void) drawFrame: (CADisplayLink* )sender {
    // refresh the view
    MyOpenGlView* view = (MyOpenGlView*) self.view;
    [view draw];
    NSLog(@"Draw Frame");
}

-(void) stopRendering {
    [displayLink invalidate];
    displayLink = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self startRendering];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
