//
//  ChoiceTableViewController.m
//  randomGameDeom
//
//  Created by HeZitong on 14/12/8.
//  Copyright (c) 2014年 HeZitong. All rights reserved.
//

#import "ChoiceTableViewController.h"
#import "ChoiceTableViewCell.h"
#import "WinViewController.h"
#import "LoseViewController.h"
@implementation ChoiceTableViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleDone target:self action:@selector(btnPressed)];
    self.navigationItem.rightBarButtonItem = btn;
}

-(void)btnPressed{
    NSURL *URL = [NSURL URLWithString:@"http://blog.chenzhangyu.com:8888/demo/get_selected"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [aleart show];
        }
        else{
            NSError *convertError;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&convertError];
            BOOL status = [[dic objectForKey:@"status"] boolValue];
            if (status) {
                //game have start
                NSInteger total = [[dic objectForKey:@"total"] integerValue];
                [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"total"];
                NSArray *selected = [dic objectForKey:@"selected"];
                NSLog(@"%@",selected);
                [[NSUserDefaults standardUserDefaults] setObject:selected forKey:@"selected"];
                NSInteger result;
                if ([dic objectForKey:@"result"]) {
                    result = [[dic objectForKey:@"result" ] integerValue];
                    NSInteger selfSelected = [[NSUserDefaults standardUserDefaults] integerForKey:@"selfSelected"];
                    if (result == selfSelected) {
                        WinViewController *winViewCtrl = [[WinViewController alloc] init];
                        winViewCtrl.title = @"You Win";
                        [self.navigationController pushViewController:winViewCtrl animated:YES];
                    }
                    else{
                        LoseViewController *loseViewCtrl = [[LoseViewController alloc] init];
                        loseViewCtrl.title = [NSString stringWithFormat:@"You Lose.Winner is No.%d",result+1];
                        [self.navigationController pushViewController:loseViewCtrl animated:YES];
                    }
                }
                else{
                    [self.tableView reloadData];
                }
                
            }
            else{
                //no game start
                UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There is no game." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [aleart show];

            }
        }
    }];
    
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    ChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ChoiceTableViewCell alloc] initWithReusedIdentifier:identifier];
    }
    cell.leftButton.contentMode = UIViewContentModeBottom;
    cell.rightButton.contentMode = UIViewContentModeBottom;
    
    [cell.leftButton addTarget:self action:@selector(imagePressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rightButton addTarget:self action:@selector(imagePressed:) forControlEvents:UIControlEventTouchUpInside];
    NSString *leftImageName;
    NSString *rightImageName;
    NSInteger total = [[NSUserDefaults standardUserDefaults] integerForKey:@"total"];
    NSArray *selected = [[NSUserDefaults standardUserDefaults] objectForKey:@"selected"];
    NSInteger cellTotal;
    if ((total)%2) {
        cellTotal = ((total/2)+1);
    }
    else{
        cellTotal = total/2;
    }
    if ((total%2) && ((indexPath.row+1) == cellTotal)) {
        leftImageName = [NSString stringWithFormat:@"a%d.jpg",total];
        cell.leftButton.tag = total;
        NSInteger ctrl = 0;
        for (NSNumber *select in selected) {
            if (cell.leftButton.tag == [select integerValue]+1) {
                CIContext *context = [CIContext contextWithOptions:nil];
                CIImage *inputImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:leftImageName]];
                // create gaussian blur filter
                CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
                [filter setValue:inputImage forKey:kCIInputImageKey];
                [filter setValue:[NSNumber numberWithFloat:7.0] forKey:@"inputRadius"];
                // blur image
                CIImage *result = [filter valueForKey:kCIOutputImageKey];
                CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
                UIImage *leftImage = [UIImage imageWithCGImage:cgImage];
                [cell.leftButton setImage:leftImage forState:UIControlStateNormal];
                ctrl = 1;
            }
        }
        if (ctrl == 0) {
            [cell.leftButton setImage:[UIImage imageNamed:leftImageName] forState:UIControlStateNormal];
        }
    }
    else{
        leftImageName = [NSString stringWithFormat:@"a%d.jpg",(indexPath.row+1)*2-1];
        rightImageName = [NSString stringWithFormat:@"a%d.jpg",(indexPath.row+1)*2];
        cell.leftButton.tag = (indexPath.row+1)*2-1;
        cell.rightButton.tag = (indexPath.row+1)*2;
        NSInteger ctrlRight = 0;
        NSInteger ctrlLeft = 0;
        for (NSNumber *select in selected) {
            if (cell.leftButton.tag == [select integerValue]+1) {
                CIContext *context = [CIContext contextWithOptions:nil];
                CIImage *inputImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:leftImageName]];
                // create gaussian blur filter
                CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
                [filter setValue:inputImage forKey:kCIInputImageKey];
                [filter setValue:[NSNumber numberWithFloat:7.0] forKey:@"inputRadius"];
                // blur image
                CIImage *result = [filter valueForKey:kCIOutputImageKey];
                CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
                UIImage *leftImage = [UIImage imageWithCGImage:cgImage];
                [cell.leftButton setImage:leftImage forState:UIControlStateNormal];
                ctrlLeft = 1;
            }
        }
        for (NSNumber *select in selected) {
            if (cell.rightButton.tag == [select integerValue]+1) {
                CIContext *context = [CIContext contextWithOptions:nil];
                CIImage *inputImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:rightImageName]];
                // create gaussian blur filter
                CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
                [filter setValue:inputImage forKey:kCIInputImageKey];
                [filter setValue:[NSNumber numberWithFloat:7.0] forKey:@"inputRadius"];
                // blur image
                CIImage *result = [filter valueForKey:kCIOutputImageKey];
                CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
                UIImage *rightImage = [UIImage imageWithCGImage:cgImage];
                [cell.rightButton setImage:rightImage forState:UIControlStateNormal];
                ctrlRight = 1;
            }
        }
        if (ctrlLeft == 0) {
            [cell.leftButton setImage:[UIImage imageNamed:leftImageName] forState:UIControlStateNormal];
        }
        if (ctrlRight == 0) {
            [cell.rightButton setImage:[UIImage imageNamed:rightImageName] forState:UIControlStateNormal];
        }
    }
    return cell;
}

-(void)imagePressed:(UIButton*)button{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selfSelected"]) {
        UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have selected" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aleart show];
    }
    else{
        NSURL *URL = [NSURL URLWithString:@"http://blog.chenzhangyu.com:8888/demo/select"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        [request setHTTPMethod:@"POST"];
        NSString *postStr = [NSString stringWithFormat:@"num=%d",button.tag-1];
        NSData *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postDataLength = [NSString stringWithFormat:@"%d",[postData length]];
        [request setValue:postDataLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [aleart show];
            }
            else{
                NSError *convertError;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&convertError];
                BOOL status = [[dic objectForKey:@"status"] boolValue];
                if (status) {
                    CIContext *context = [CIContext contextWithOptions:nil];
                    CIImage *inputImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"a%d.jpg",button.tag]]];
                    // create gaussian blur filter
                    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
                    [filter setValue:inputImage forKey:kCIInputImageKey];
                    [filter setValue:[NSNumber numberWithFloat:7.0] forKey:@"inputRadius"];
                    // blur image
                    CIImage *result = [filter valueForKey:kCIOutputImageKey];
                    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
                    UIImage *image = [UIImage imageWithCGImage:cgImage];
                    //CGImageRelease(cgImage);
                    [button setImage:image forState:UIControlStateNormal];
                    UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have selected the picture" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [aleart show];
                    NSInteger total = [[dic objectForKey:@"total"] integerValue];
                    NSArray *selected = [dic objectForKey:@"selected"];
                    NSInteger selfSelected = button.tag-1;
                    [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"total"];
                    [[NSUserDefaults standardUserDefaults] setObject:selected forKey:@"selected"];
                    [[NSUserDefaults standardUserDefaults] setInteger:selfSelected forKey:@"selfSelected"];
                }
                else{
                    UIAlertView *aleart = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You can not select it" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [aleart show];
                }
            }
        }];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger total = [[NSUserDefaults standardUserDefaults] integerForKey:@"total"];
    NSInteger cellTotal;
    if ((total)%2) {
        cellTotal = ((total/2)+1);
    }
    else{
        cellTotal = total/2;
    }

    NSLog(@"rows:%d",cellTotal);
    return cellTotal;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
@end
