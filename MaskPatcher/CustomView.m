//
//  CustomView.m
//  CustomViewTest
//
//  Created by maskman on 6/27/19.
//  Copyright © 2019 maskman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomView.h"


/*
* Root view
* Contains two child views - LogView and WriteView
*/
@implementation CustomView
bool buttonAdded;
CGPoint lastlocation;
bool isOpen;
#define ROUND_BUTTON_WIDTH_HEIGHT 20
- (id)initWithFrame:(CGRect)frame :(UIWindow*)main
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // initilize all your UIView components
        /* Add button which opens and closes the view */
        UIButton * openButton;
        openButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        openButton.frame = CGRectMake(0, 0, ROUND_BUTTON_WIDTH_HEIGHT, ROUND_BUTTON_WIDTH_HEIGHT);
        openButton.clipsToBounds = YES;
        
        //half of the width
        openButton.layer.cornerRadius = ROUND_BUTTON_WIDTH_HEIGHT/2.0f;
        openButton.layer.borderColor=[UIColor redColor].CGColor;
        openButton.layer.borderWidth=2.0f;
        [openButton addTarget:self action:@selector(wasDragged:withEvent:)
             forControlEvents:UIControlEventTouchDragInside];
        [openButton addTarget:self action:@selector(showView)
         forControlEvents:UIControlEventTouchDownRepeat];   
        [main addSubview:openButton];
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        self.hidden = TRUE;
        isOpen = FALSE;
        lastlocation = self.bounds.origin;
        [main addSubview:self];
        [self addGestureRecognizer:panRecognizer];
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.layer.borderWidth = 1.5f;
        [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [self.layer setShadowOpacity:0.5];
        CGFloat width = main.frame.size.width;
        CGFloat height = main.frame.size.height;
        height = height*1.8;
        CGFloat widthRootView = width/2;
        CGFloat widthLogView = widthRootView/2;
        CGFloat widthWriteView = widthLogView;
        LogView * lv = [[LogView alloc]initWithFrame:CGRectMake(0, 0, widthLogView, height/3)];
        WriteView * wv = [[WriteView alloc]initWithFrame:CGRectMake(widthLogView, 0, widthWriteView, height/3)];
        [self addSubview:lv];
        [self addSubview:wv];
    }
    return self;
}
-(void)move:(UIPanGestureRecognizer*)sender {
    UIWindow *main = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [main bringSubviewToFront:sender.view];
    CGPoint translatedPoint = [sender translationInView:sender.view.superview];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        lastlocation.x = sender.view.center.x;
        lastlocation.y = sender.view.center.y;
    }
    translatedPoint = CGPointMake(sender.view.center.x+translatedPoint.x, sender.view.center.y+translatedPoint.y);
    
    [sender.view setCenter:translatedPoint];
    [sender setTranslation:CGPointZero inView:sender.view];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat velocityX = (0.2*[sender velocityInView:main].x);
        CGFloat velocityY = (0.2*[sender velocityInView:main].y);
        
        CGFloat finalX = translatedPoint.x + velocityX;
        CGFloat finalY = translatedPoint.y + velocityY;// translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        
        if (finalX < 0) {
            finalX = 0;
        } else if (finalX > main.frame.size.width) {
            finalX = main.frame.size.width;
        }
        
        if (finalY < 50) { // to avoid status bar
            finalY = 50;
        } else if (finalY > main.frame.size.height) {
            finalY = main.frame.size.height;
        }
        
        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
                
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [[sender view] setCenter:CGPointMake(finalX, finalY)];
        [UIView commitAnimations];
    }
}
- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{
    UITouch *touch = [[event touchesForView:button] anyObject];
    
    CGPoint previousLocation = [touch previousLocationInView:button];
    CGPoint location = [touch locationInView:button];
    CGFloat delta_x = location.x - previousLocation.x;
    CGFloat delta_y = location.y - previousLocation.y;
    
    button.center = CGPointMake(button.center.x + delta_x, button.center.y + delta_y);
}
- (void)showView {
    if(isOpen) {
        self.hidden = TRUE;
        [LogView MLog:@"Touch"];
        isOpen = !isOpen;
    }else {
        self.hidden = FALSE;
        [LogView MLog:@"Touch!"];
        isOpen = !isOpen;
    }
}
@end
