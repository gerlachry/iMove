//
//  DashboardTableViewController.h
//  iMove
//
//  Created by Raju, Antony Prakash on 6/18/15.
//  Copyright (c) 2015 merck. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DashboardTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *dashboardTableView;

- (IBAction)previousDayButtonAction:(UIButton *)sender;

- (IBAction)nextDayButtonAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIProgressView *stepsProgressView;

@property (nonatomic) float stepsProgressValue;

@property (strong, nonatomic) IBOutlet UILabel *stepsValueLabel;



@property (weak, nonatomic) IBOutlet UIProgressView *distanceProgressView;

@property (nonatomic) float distanceProgressValue;

@property (weak, nonatomic) IBOutlet UILabel *distanceValueLabel;



@property (weak, nonatomic) IBOutlet UIProgressView *caloriesBurnedProgressView;

@property (nonatomic) float caloriesBurnedProgressValue;

@property (weak, nonatomic) IBOutlet UILabel *caloriesBurnedValueLabel;

-(void) increaseStepsProgressValue;

-(void) increaseDistanceProgressValue;

-(void) increaseCaloriesBurnedProgressValue;



@end
