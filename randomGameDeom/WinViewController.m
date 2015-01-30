//
//  WinViewController.m
//  randomGameDeom
//
//  Created by HeZitong on 14/12/11.
//  Copyright (c) 2014年 HeZitong. All rights reserved.
//

#import "WinViewController.h"

@implementation WinViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
//    imageView.contentMod e = UIViewContentModeBottom;//还是不理解
    [self.view addSubview:imageView];
    NSDictionary *dictionary = @{@"image":imageView};
    NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[image(320)]" options:0 metrics:nil views:dictionary];
    NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[image(320)]" options:0 metrics:nil views:dictionary];
    [imageView addConstraints:constraintsV];
    [imageView addConstraints:constraintsH];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [imageView setImage:[UIImage imageNamed:@"win.png"]];

}



-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
