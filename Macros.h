#include <substrate.h>
#include <initializer_list>
#include <vector>
#include <mach-o/dyld.h>
#include <pthread/pthread.h>
#include <string>
#include <iostream>
#import "MaskPatcher/CustomView.h"

using namespace std;

bool buttonAdded;

/* source - shmoo's menu */
#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^ 
