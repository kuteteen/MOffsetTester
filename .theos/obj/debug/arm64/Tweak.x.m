#line 1 "Tweak.x"
#import "Macros.h"


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class IOSAppDelegate; 
static void (*_logos_orig$_ungrouped$IOSAppDelegate$applicationDidBecomeActive$)(_LOGOS_SELF_TYPE_NORMAL IOSAppDelegate* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$IOSAppDelegate$applicationDidBecomeActive$(_LOGOS_SELF_TYPE_NORMAL IOSAppDelegate* _LOGOS_SELF_CONST, SEL, id); 

#line 3 "Tweak.x"


static void _logos_method$_ungrouped$IOSAppDelegate$applicationDidBecomeActive$(_LOGOS_SELF_TYPE_NORMAL IOSAppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg0) {
    
    
    
    
    
    UIWindow *main = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    CGFloat width = main.frame.size.width;
    CGFloat height = main.frame.size.height;
    height = height*1.8;
    CGFloat widthRootView = width/2; 
    UIButton * openButton;
    openButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    openButton.frame = CGRectMake(0, 0, ROUND_BUTTON_WIDTH_HEIGHT, ROUND_BUTTON_WIDTH_HEIGHT);
    openButton.clipsToBounds = YES;
    
    
    openButton.layer.cornerRadius = ROUND_BUTTON_WIDTH_HEIGHT/2.0f;
    openButton.layer.borderColor=[UIColor redColor].CGColor;
    openButton.layer.borderWidth=2.0f;
    [openButton addTarget:self action:@selector(wasDragged:withEvent:)
         forControlEvents:UIControlEventTouchDragInside];
    [openButton addTarget:self action:@selector(showView)
         forControlEvents:UIControlEventTouchDownRepeat];   
    

    if(!buttonAdded){
        timer(5){
            UIWindow *main = [UIApplication sharedApplication].keyWindow.rootViewController.view;
            cv = [[CustomView alloc]initWithFrame:CGRectMake(0, 0, widthRootView, height/3):main];
            cv.hidden = TRUE;
            isOpen = FALSE;
            lastlocation = cv.bounds.origin;
            UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
            [main addSubview:openButton];
            [main addSubview:cv];
            [cv addGestureRecognizer:panRecognizer];

            buttonAdded = true;
        });
    }
    
     
    _logos_orig$_ungrouped$IOSAppDelegate$applicationDidBecomeActive$(self, _cmd, arg0);
}







    





    


    



        


        





        





        

        

        













    




    













static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$IOSAppDelegate = objc_getClass("IOSAppDelegate"); MSHookMessageEx(_logos_class$_ungrouped$IOSAppDelegate, @selector(applicationDidBecomeActive:), (IMP)&_logos_method$_ungrouped$IOSAppDelegate$applicationDidBecomeActive$, (IMP*)&_logos_orig$_ungrouped$IOSAppDelegate$applicationDidBecomeActive$);} }
#line 123 "Tweak.x"
