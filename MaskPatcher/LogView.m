//
//  LogView.m
//  CustomViewTest
//
//  Created by maskman on 6/27/19.
//  Copyright © 2019 maskman. All rights reserved.
//

#import "LogView.h"

@interface LogView ()

@end
UITextView * txt;
@implementation LogView
- (id)initWithFrame:(CGRect)frame
{
    UIView *main = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // initilize all your UIView components        
        
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        self.buttonView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubview:self.buttonView];
        [self addButton:@"Copy Log" :CGRectMake(0, 0, self.buttonView.frame.size.width/2, self.buttonView.frame.size.height) :self.buttonView];
        [self addButton:@"Clear Log" :CGRectMake(self.buttonView.frame.size.width/2, 0, self.buttonView.frame.size.width/2, self.buttonView.frame.size.height) :self.buttonView];
        txt = [[UITextView  alloc]initWithFrame:CGRectMake(0, 30, frame.size.width, frame.size.height-30)];
        txt.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        txt.textColor = [UIColor whiteColor];
        txt.userInteractionEnabled = FALSE;
        [self textFieldShouldReturn:txt];
        
        
    }
    return self;
}

- (void)addButton:(NSString *)title :(CGRect)frame :(UIView*)view {
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [view addSubview:button];
}
- (void)buttonAction:(UIButton *)button  {
    //NSLog(@"BUTTONNAME=%@", button.titleLabel.text);
    if([button.titleLabel.text isEqualToString:@"Clear Log"]) {
        [UIView transitionWithView:button
                          duration:1.0
                           options:UITableViewRowAnimationFade
                        animations:^{ button.highlighted = YES;
                            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
                            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            anim.duration = 0.3;
                            anim.repeatCount = 1;
                            anim.autoreverses = YES;
                            anim.removedOnCompletion = YES;
                            anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
                            [button.layer addAnimation:anim forKey:nil];
                            
                        }
                        completion:^(BOOL finished) {
                            button.backgroundColor =  [UIColor clearColor];
                        }];
        [self clearTextAction];
    }else {
        [UIView transitionWithView:button
                          duration:1.0
                           options:UITableViewRowAnimationFade
                        animations:^{ button.highlighted = YES;
                            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
                            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            anim.duration = 0.3;
                            anim.repeatCount = 1;
                            anim.autoreverses = YES;
                            anim.removedOnCompletion = YES;
                            anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
                            [button.layer addAnimation:anim forKey:nil];
                            
                        }
                        completion:^(BOOL finished) {
                            button.backgroundColor =  [UIColor clearColor];
                        }];
        [self copyLogAction];
    }
}
/* empty textarea */
- (void)clearTextAction {
    txt.text = 0x0;
}
/* copy text string */
- (void)copyLogAction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = txt.text;
}
/* auto scroll text area */
+ (void)positionTextView {
    
    // scroll to the bottom of the content
    NSRange lastLine = NSMakeRange(txt.text.length - 1, 1);
    [txt scrollRangeToVisible:lastLine];
}
/* Log message to the text area */
+ (void)MLog:(NSString *)msg {
    txt.text = [NSString stringWithFormat:@"%@\n%@", txt.text, msg];
    [self positionTextView];
}

@end
