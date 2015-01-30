//
//  testViewController.m
//  randomGameDeom
//
//  Created by HeZitong on 14/12/11.
//  Copyright (c) 2014年 HeZitong. All rights reserved.
//

#import "testViewController.h"

@implementation testViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    [imageView setImage:[UIImage imageNamed:@"win.png"]];
    [self.view addSubview:imageView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"高斯" style:UIBarButtonItemStyleDone target:self action:@selector(trans)];
    
}
-(void)trans{
    UIImageView *imageView02 = [[UIImageView alloc] initWithFrame:CGRectMake(150, 150, 100, 100)];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"win.png"]];
    // create gaussian blur filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:2.0] forKey:@"inputRadius"];
    // blur image
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    //CGImageRelease(cgImage);
    [imageView02 setImage:image];
    [self.view addSubview:imageView02];
    
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
