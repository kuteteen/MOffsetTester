# MOffsetTester

MOffsetTester allows you to perform memory patches by writing data and also Log messages. 

## Installation

1) Copy the MaskPatcher folder to your project.
2) ```CustomView * cv = [[CustomView alloc]initWithFrame:CGRectMake(0, 0, main.frame.size.width/2, main.frame.size.height*1.8/3):main];``` to initialize the root view. 
3) Check the Tweak.xm for further details
4) ```#import "MaskPatcher/CustomView.h"```

## Usage

1) To log messages to the UIView, just call ```[LogView MLog:@"your_log_message_here"];```
2) To ```Add``` to add new cells and ```Patch!``` to write to memory
3) Doubel tap cells to delete a cell

## Supported devices and jailbreaks
IOS 10,11,12,electra,chimera,uncover

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change. 

<a href="url"><img src="pubg.gif" align="left" height="320" width="450" ></a>
