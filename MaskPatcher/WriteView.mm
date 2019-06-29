//
//  WriteView.m
//  CustomViewTest
//
//  Created by maskman on 6/27/19.
//  Copyright © 2019 maskman. All rights reserved.
//

#import "WriteView.h"
#include <vector>
#include <sstream>
#include <iostream>
#include <string>
#include <inttypes.h>
#import "writeData.h"
#import "LogView.h"
using namespace std;

#define ASLR_BIAS _dyld_get_image_vmaddr_slide(0)

uint64_t getRealOffset(uint64_t offset){
    return ASLR_BIAS + offset;
}
@interface WriteView ()

@end
@interface Hook_m : NSObject<UITextFieldDelegate>
    @property (nonatomic, strong) NSString *address;
    @property (nonatomic, strong) NSString *offset;
@end
@implementation Hook_m
@end
@class HookCell;
@protocol  HookCellTextFieldProtocol <NSObject>

@end
@interface HookCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *addressField;
@property (nonatomic, strong) UITextField *offsetField;
@property (nonatomic, retain) UISwitch *selectSwitch;
@property (nonatomic, assign) id<HookCellTextFieldProtocol> delegate;
@end
@implementation HookCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
        [self setupSubviews];
    return self;
}
/* Make out custom cell -> Add 2 textfields and a switch */
-(void)setupSubviews
{
    
    self.addressField = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height/2.5)];
    self.addressField.borderStyle = UITextBorderStyleLine;
    self.addressField.borderStyle = UITextBorderStyleRoundedRect;
    self.addressField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Address" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Georgia-BoldItalic" size:12.0]}];
    self.addressField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.addressField setFont:[UIFont fontWithName:@"AvenirNextCondensed-HeavyItalic" size:12]];
    [self textFieldShouldReturn:self.addressField];
    self.addressField.delegate = self;
    
    [self.contentView addSubview: self.addressField];
    CGFloat height = self.addressField.frame.size.height;
    self.offsetField = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.origin.x, height+5, self.frame.size.width/2, self.frame.size.height/2.5)];
    
    self.offsetField.borderStyle = UITextBorderStyleRoundedRect;
    self.offsetField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Offset" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Georgia-BoldItalic" size:12.0]}];
    self.offsetField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.offsetField setFont:[UIFont fontWithName:@"AvenirNextCondensed-HeavyItalic" size:12]];
    self.offsetField.delegate = self;
    [self textFieldShouldReturn:self.offsetField];
    [self.contentView addSubview: self.offsetField];
    
    height += self.offsetField.frame.size.height;
    CGFloat width = self.offsetField.frame.size.width;
    self.selectSwitch = [[UISwitch alloc] initWithFrame: CGRectMake(self.frame.origin.x, height+5, width/3, self.offsetField.frame.size.height/2)];
    self.selectSwitch.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [self.contentView addSubview: self.selectSwitch];
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end

@implementation WriteView
NSMutableArray *_hookArray;         /* store cells */
std::vector<uint64_t> addresses;    /* store addresses that are to be patched */
std::vector<uint64_t> offsets;      /* store offsets */
NSTimeInterval lastClick;        
NSIndexPath *lastIndexPath;
- (id)initWithFrame:(CGRect)frame
{
    UIView *main = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = 1;
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        self.buttonView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubview:self.buttonView];
        [self addButton:@"Add" :CGRectMake(0, 0, self.buttonView.frame.size.width/2, self.buttonView.frame.size.height) :self.buttonView];
        [self addButton:@"Patch!" :CGRectMake(self.buttonView.frame.size.width/2, 0, self.buttonView.frame.size.width/2, self.buttonView.frame.size.height) :self.buttonView];
        
        
        self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, frame.size.height-30) style:UITableViewStylePlain];
        self.table.tag = 3;
        self.table.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self addSubview:self.table];
        self.table.delegate = self;
        self.table.dataSource = self;
        //self.table.allowsSelection = FALSE;
        _hookArray = [[NSMutableArray alloc] init];
        [self.table reloadData];
    }
    return self;
}

- (void)addButton:(NSString *)title :(CGRect)frame :(UIView*)view {
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [view addSubview:button];
}

/* Get the button and perform action */
- (void)buttonAction:(UIButton *)button  {
    if([button.titleLabel.text isEqualToString:@"Add"]) {
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
        [self addAction];
    }else {
        [self enterAction];
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
        
    }
}
/* Perform add action - add button -> add more writedata textfields */
- (void)addAction {
    UITableView * view = [self viewWithTag:3];
    Hook_m *newPerson = [Hook_m new];
    [_hookArray addObject: newPerson];
    [view reloadData];
}

uint64_t getLongValueFromNSString(NSString * address) {
    std::string addr = std::string([address UTF8String]);
    uint64_t v;
    char *str = strdup(addr.c_str());
    v =strtoull(str, NULL, 16);
    return v;
}
std::string uint64_to_string( uint64_t value ) {
    std::ostringstream os;
    os << value;
    return os.str();
}
/* Execute writeData */
- (void)enterAction {
    for(int i=0;i<_hookArray.count;i++){
        HookCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(cell.selectSwitch.on && [self isAddressCorrect:cell.addressField.text]) {
            addresses.push_back((getLongValueFromNSString(cell.addressField.text)));
            offsets.push_back(getLongValueFromNSString(cell.offsetField.text));
            writeData(addresses[i], offsets[i]);
            string msg = "Memory writte at " + string([cell.addressField.text UTF8String]) + " and bytes written " + string([cell.offsetField.text UTF8String]);
            txt.text = [NSString stringWithFormat:@"%@\n%s", txt.text, msg.c_str()];
            //NSLog(@"%" PRId64 "\n", getLongValueFromNSString(cell.addressField.text));
        }else {
            //NSLog(@"Switch off\n");
            [LogView MLog:@"Switch Off or Invalid Address"];
        }
        
    }
    addresses.clear();
    offsets.clear();
}
/* Make sure it's a valid address */
- (BOOL)isAddressCorrect:(NSString*)address {
    if(![address hasPrefix:@"0x"]) {
        return FALSE;
    }
    if([address length] != 11) {
        return FALSE;
    }
    return TRUE;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _hookArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HookCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier: @"CellWithNameAndSurname"];
    if(!cell)
    {
        cell = [[HookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellWithNameAndSurname"];
        cell.contentView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent: 0.08f];
    }
    /* For some reason without SEL, it crashes :/ */
    SEL noParameterSelector = @selector(switchChanged:);
    [cell.selectSwitch addTarget:self action:noParameterSelector forControlEvents:UIControlEventValueChanged];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
/* Action when a cell is pressed/selected */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HookCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSTimeInterval now = [[[NSDate alloc] init] timeIntervalSince1970];
    if ((now - lastClick < 0.3) && [indexPath isEqual:lastIndexPath]) {
        // Double tap here
        [_hookArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView reloadData];
    }
    lastClick = now;
    lastIndexPath = indexPath;
}
/* Set Cell Height */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
/* Allow us to delete cells */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
/* Switch action */
- (void)switchChanged:(id)sender {
    UISwitch *switchControl = sender;
}
@end
