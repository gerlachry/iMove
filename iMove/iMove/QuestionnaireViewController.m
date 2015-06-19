//
//  QuestionnaireViewController.m
//  iMove
//
//  Created by Barros, Myles V. on 6/18/15.
//  Copyright (c) 2015 merck. All rights reserved.
//

#import "QuestionnaireViewController.h"

@interface QuestionnaireViewController ()

@end

@implementation QuestionnaireViewController{
    NSMutableData *_responseData;
    BOOL moved;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    if (self.age.isFirstResponder) {
        [self.age resignFirstResponder];
    }
    else if (self.weight.isFirstResponder) {
        [self.weight resignFirstResponder];
    }
    else if (self.ldl.isFirstResponder) {
        [self.ldl resignFirstResponder];
    }
    else if (self.hdl.isFirstResponder) {
        [self.hdl resignFirstResponder];
    }
    else if (self.bloodPressure.isFirstResponder) {
        [self.bloodPressure resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitRiskAssesment:(id)sender {
    BOOL validForm = [self assessmentFormIsValid];
    
    if (validForm) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://10.5.51.46:7777/v1/risk"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        
        NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSNumber *ldl = [NSNumber numberWithInt:[self.ldl.text intValue]];
        NSNumber *hdl = [NSNumber numberWithInt:[self.hdl.text intValue]];
        NSNumber *age = [NSNumber numberWithInt:[self.age.text intValue]];
        NSNumber *weight = [NSNumber numberWithInt:[self.weight.text intValue]];
        NSNumber *smoker;
        if (self.smokerState.on == true) {
            smoker = [NSNumber numberWithBool:true];
        }
        else {
            smoker = [NSNumber numberWithBool:false];
        }
        NSNumber *sysp = [NSNumber numberWithInt:[self.bloodPressure.text intValue]];
        NSNumber *diap = [NSNumber numberWithInt:90];
        
        NSDictionary *jsonValues = [[NSDictionary alloc] initWithObjectsAndKeys: @"0001-0002-0003-0004", @"userId", ldl, @"ldl", hdl, @"hdl", @"M", @"gender", age, @"age", sysp, @"sysp", diap, @"diap", smoker, @"smoke", nil];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonValues options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        NSLog([NSString stringWithFormat:@"%@", jsonString]);

        [request setValue:[NSString stringWithFormat:@"%lu",
                           (unsigned long)[jsonString length]]
        forHTTPHeaderField:@"Content-length"];
        
        [request setHTTPBody:[jsonString
                              dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    else {
        self.alert.hidden = NO;
        self.alertMessage.hidden = NO;
    }
}

- (Boolean)assessmentFormIsValid {
    if ([[self.age text] intValue] == 0) {
        return NO;
    }
    else if ([[self.weight text] intValue] == 0) {
        return NO;
    }
    else if ([[self.hdl text] intValue] == 0) {
        return NO;
    }
    else if ([[self.ldl text] intValue] == 0) {
        return NO;
    }
    else if ([[self.bloodPressure text] intValue] == 0) {
        return NO;
    }
    
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:_responseData
                                                         options:kNilOptions
                                                           error:&error];
    NSDictionary *results = [json objectForKey:@"result"];
    NSDictionary *goal = [results objectForKey:@"goal"];
    NSNumber *goal_days = [NSNumber numberWithInt:[goal[@"goal_days"] intValue]];
    NSNumber *out_of_days = [NSNumber numberWithInt:[goal[@"out_of_days"] intValue]];
    NSNumber *steps = [NSNumber numberWithInt:[goal[@"steps"] intValue]];
    NSNumber *increment_by = [NSNumber numberWithInt:[goal[@"increment_by"] intValue]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:goal_days forKey:@"goal_days"];
    [defaults setObject:out_of_days forKey:@"out_of_days"];
    [defaults setObject:steps forKey:@"steps"];
    [defaults setObject:increment_by forKey:@"increment_by"];
    [defaults synchronize];
    
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

@end