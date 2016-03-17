//
//  ViewController.h
//  ManualOpenGlSetUp
//
//  Created by Anurag Singhal on 3/17/16.
//  Copyright © 2016 Anurag Singhal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    CADisplayLink* displayLink;
}

-(void) startRendering;
-(void) stopRendering; // this is needed before application goes to background
-(void) drawFrame: (CADisplayLink* )sender;



@end

