//
//  ChoiceTableViewCell.h
//  randomGameDeom
//
//  Created by HeZitong on 14/12/9.
//  Copyright (c) 2014年 HeZitong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoiceTableViewCell : UITableViewCell
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
-(id)initWithReusedIdentifier:(NSString *)reusedIdentifier;
@end
