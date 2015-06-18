//
//  Goals2ViewController.m
//  iMove
//
//  Created by Gerlach, Ryan K on 6/18/15.
//  Copyright (c) 2015 merck. All rights reserved.
//

#import "Goals2ViewController.h"

@interface Goals2ViewController ()

@end

@implementation Goals2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // populate goal details from nsuserdefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // test data
    NSString *total = @"7";
    NSString *current = @"3";
    NSString *target = @"10,000";
    [defaults setObject:total forKey:@"totalDays"];
    [defaults setObject:current forKey:@"targetDays"];
    [defaults setObject:target forKey:@"targetSteps"];
    [defaults synchronize];
    
    self.totalDays.text = [defaults objectForKey:@"totalDays"];
    self.targetDays.text = [defaults objectForKey:@"targetDays"];
    self.targetSteps.text = [defaults objectForKey:@"targetSteps"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
