//
//  DCAboutViewController.m
//  Declarations
//
//  Created by Vera Tkachenko on 13.10.14.
//  Copyright (c) 2014 Chesno. All rights reserved.
//

#import "DCAboutViewController.h"

@interface DCAboutViewController ()

@end

@implementation DCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feedBackAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:gudvadym@gmail.com"]];
}

- (IBAction)clickLogoAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://chesno.org"]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
