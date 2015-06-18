//
//  QuestionnaireViewController.h
//  iMove
//
//  Created by Barros, Myles V. on 6/18/15.
//  Copyright (c) 2015 merck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionnaireViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *weight;
@property (weak, nonatomic) IBOutlet UISwitch *smokerState;
@property (weak, nonatomic) IBOutlet UITextField *hdl;
@property (weak, nonatomic) IBOutlet UITextField *ldl;
@property (weak, nonatomic) IBOutlet UITextField *bloodPressure;

@property (weak, nonatomic) IBOutlet UILabel *alert;
@property (weak, nonatomic) IBOutlet UILabel *alertMessage;

- (IBAction)submitRiskAssesment:(id)sender;

@end
