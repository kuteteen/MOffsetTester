
/* Example on how to use the MOffsetTester */

#import "Macros.h"

%hook IOSAppDelegate

- (void)applicationDidBecomeActive:(id)arg0 {
    UIWindow *main = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    if(!buttonAdded){
        timer(5){
            UIWindow *main = [UIApplication sharedApplication].keyWindow.rootViewController.view;
            CustomView * cv = [[CustomView alloc]initWithFrame:CGRectMake(0, 0, main.frame.size.width/2, main.frame.size.height*1.8/3):main];
            buttonAdded = true;
        });
    }
    %orig;
}
%end