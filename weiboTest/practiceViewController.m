//
//  practiceViewController.m
//  weiboTest
//
//  Created by Haian Liu on 3/26/14.
//  Copyright (c) 2014 Haian Liu. All rights reserved.
//

#import "practiceViewController.h"
#import "practiceWeiboInfo.h"


@interface practiceViewController ()

@end

@implementation practiceViewController

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;//开始不允许跳转，只有当验证账号和密码正确可以进入后由登录代码执行切换
}

- (IBAction)btnLink:(id)sender {
    [[practiceWeiboInfo getInstance] weiboObjInit];
    [[practiceWeiboInfo getInstance] login];
    [self performSegueWithIdentifier:@"afterLogin" sender:sender];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
