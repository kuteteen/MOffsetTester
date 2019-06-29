//
//  WriteView.h
//  CustomViewTest
//
//  Created by maskman on 6/27/19.
//  Copyright © 2019 maskman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteView : UIView <UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *table;
@property (strong,nonatomic) UIView * buttonView;
- (void)addButton:(NSString *)title :(CGRect)frame :(UIView*)view;
- (void)buttonAction:(UIButton *)button;
- (void)addAction;
- (void)enterAction;
- (BOOL)isAddressCorrect:(NSString *)address;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
