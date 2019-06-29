//
//  LogView.h
//  CustomViewTest
//
//  Created by maskman on 6/27/19.
//  Copyright © 2019 maskman. All rights reserved.
//

#import <UIKit/UIKit.h>

/* global object for UITextView */
extern UITextView * txt;

@interface LogView : UIView
@property (strong,nonatomic) UIView * buttonView;
+ (void)positionTextView; 
+ (void)MLog:(NSString *)msg;
- (void)buttonAction:(UIButton *)button;
- (void)clearTextAction;
- (void)copyLogAction;
@end
