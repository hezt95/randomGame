//
//  ChoiceTableViewCell.m
//  randomGameDeom
//
//  Created by HeZitong on 14/12/9.
//  Copyright (c) 2014年 HeZitong. All rights reserved.
//

#import "ChoiceTableViewCell.h"
#import "ChoiceTableViewCell.h"
@implementation ChoiceTableViewCell
-(id)initWithReusedIdentifier:(NSString *)reusedIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (self) {
        [self initLayout];
    }
    return self;
}

-(void)initLayout{
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 160, 160)];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
}
@end
