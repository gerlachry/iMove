//
//  DashboardTableViewController.m
//  iMove
//
//  Created by Raju, Antony Prakash on 6/18/15.
//  Copyright (c) 2015 merck. All rights reserved.
//

#import "DashboardTableViewController.h"


@interface DashboardTableViewController ()
{
    NSMutableData *webData;
    NSMutableDictionary *dataForEachDate;
    float steps;
    NSArray *responseResultsArray;
}

@end

@implementation DashboardTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.distanceProgressValue = 0.0f;
    
    self.caloriesBurnedProgressValue = 0.0f;
    
    [self getDashboardData];
    
    
    
    // [self increaseDistanceProgressValue];
    // [self increaseCaloriesBurnedProgressValue];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) getDashboardData
{
    //NSString *requestURLString = [NSString stringWithFormat:@"http://54.175.137.37:7777/v1/data/0001-0002-0003-0004"];
    //NSString *requestURLString = [NSString stringWithFormat:api_dashboard_url];
    
    // NSString *requestURLString = [NSString stringWithFormat:@"%@/%@",kOutsidePartiesSearchAPIURL, searchText];
    
    NSURL *requestURL = [NSURL URLWithString:[api_dashboard_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    
    /* NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", [RequestToken getTokenFromCache]];
     
     
     [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
     [request setValue:@"application/json; odata=verbose" forHTTPHeaderField:@"Accept"];
     [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];*/
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(theConnection)
        webData = [NSMutableData data];
    else
        NSLog(@"theConnection is null");
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSString *errorMessage = [NSString stringWithFormat:@"Error Code:%ld. Please retry",(long)[httpResponse statusCode]];
    
    NSLog(@"%@", httpResponse);
    if ([httpResponse statusCode] >= 400)
    {
        // do error handling here
        // NSLog(@"remote url returned error %d %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Request Failed" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
    }
    else if ([httpResponse statusCode] ==200)
    {
        [webData setLength:0];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Request Failed" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"sendingCheckUserIdCall didFailWithError %@", error);
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Request Failed" message:@"Please check your network settings and retry" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    NSError *jsonError;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:webData options:kNilOptions error:&jsonError];
    
    NSLog(@"json  - %@",json);
    
    // NSDictionary *responseDictionary = [json objectForKey:@"result"];
    
    responseResultsArray = [json objectForKey:@"result"];  //[NSArray arrayWithObject:responseDictionary];
    
    NSLog(@"responseResultsArray size %lu",(unsigned long)[responseResultsArray count] );
    
    
    //  NSLog(@"responseResultsArray %@",responseResultsArray );
    
    [self getDataForAllDates:responseResultsArray index:1];
    
    
}

-(void)getDataForAllDates:(NSArray *)resultsArray index:(NSInteger)arrayIndex
{
    dataForEachDate = [[NSMutableDictionary alloc] init];
    
    NSString *currentDate;
    
    NSLog(@" Index : %ld",(long)arrayIndex);
    
    /* for (int i=arrayIndex; i<[resultsArray count]; i++)
     {
     
     // NSLog(@" i[%d] : %@",i,[resultsArray objectAtIndex:i]);
     
     if([[[resultsArray objectAtIndex:i] objectForKey:@"date"] isEqualToString:@"19-Jun-2015"])
     {
     currentDate = @"19-Jun-2015";
     
     [dataForEachDate setValue:[resultsArray objectAtIndex:i] forKey:@"19-Jun-2015"];
     }
     
     else if([[[resultsArray objectAtIndex:i] objectForKey:@"date"] isEqualToString:@"20-Jun-2015"])
     {
     currentDate = @"20-Jun-2015";
     
     [dataForEachDate setValue:[resultsArray objectAtIndex:i] forKey:@"20-Jun-2015"];
     }
     
     else if([[[resultsArray objectAtIndex:i] objectForKey:@"date"] isEqualToString:@"21-Jun-2015"])
     {
     currentDate = @"21-Jun-2015";
     
     [dataForEachDate setValue:[resultsArray objectAtIndex:i] forKey:@"21-Jun-2015"];
     }
     
     // NSLog(@" i[%d] : %@",i,[[[responseResultsArray objectAtIndex:0] objectAtIndex:i] objectForKey:@"name"]);
     // NSLog(@" i[%d] : %@",i,[[[responseResultsArray objectAtIndex:0] objectAtIndex:i] objectForKey:@"headquarter_city"]);
     
     
     }*/
    
    
    
    
    
    
    
    
    
    
    
    currentDate = [[resultsArray objectAtIndex:arrayIndex] objectForKey:@"date"];
    
    self.dateLabel.text = currentDate;
    
    [dataForEachDate setValue:[resultsArray objectAtIndex:arrayIndex] forKey:currentDate];
    
    
    NSLog(@" Data for %@ %@",currentDate, [dataForEachDate objectForKey:currentDate]);
    
    // NSLog(@"Steps %@", [[dataForEachDate objectForKey:@"18-Jun-2015"]  objectForKey:@"steps"]);
    
    
    self.stepsValueLabel.text = [NSString stringWithFormat:@"%@",[[dataForEachDate objectForKey:currentDate]  objectForKey:@"steps"]];
    // [self.dashboardTableView reloadData];
    
    self.distanceValueLabel.text = [NSString stringWithFormat:@"%@",[[dataForEachDate objectForKey:currentDate]  objectForKey:@"distance"]];
    
    self.caloriesBurnedValueLabel.text = [NSString stringWithFormat:@"%@",[[dataForEachDate objectForKey:currentDate]  objectForKey:@"calories"]];
    
    [self showStepsWithProgress:currentDate];
    
    [self showDistanceWithProgress:currentDate];
    
    
    [self showCaloriesBurnedWithProgress:currentDate];
    
    
    
}



-(void)showStepsWithProgress:(NSString *)currentDate

{
    
    
    self.stepsProgressValue = [[[dataForEachDate objectForKey:currentDate]  objectForKey:@"steps"] floatValue]/10000.0f;
    
    NSLog(@"Steps %f", self.stepsProgressValue);
    
    [self.stepsProgressView setProgress:self.stepsProgressValue animated:YES];
    
    /* self.stepsProgressView.progress  = self.stepsProgressValue;
     
     if(self.stepsProgressView.progress<1)
     
     [self performSelector:@selector(increaseStepsProgressValue) withObject:nil afterDelay:0.3];*/
    
}

/*
 -(void) increaseStepsProgressValue
 {
 
 self.stepsProgressValue = [[[dataForEachDate objectForKey:@"18-Jun-2015"]  objectForKey:@"steps"] floatValue];
 
 self.stepsProgressView.progress  = self.stepsProgressValue;
 
 
 if(self.stepsProgressValue < 1.0f)
 
 {
 
 self.stepsProgressValue = self.stepsProgressValue + 0.3f;
 
 self.stepsProgressView.progress = self.stepsProgressValue;
 
 // [self performSelector:@selector(increaseStepsProgressValue) withObject:self afterDelay:0.3];
 
 }
 }*/

-(void)showDistanceWithProgress:(NSString *)currentDate


{
    
    self.distanceProgressValue = [[[dataForEachDate objectForKey:currentDate]  objectForKey:@"distance"] floatValue]/10.0f;
    
    [self.distanceProgressView setProgress:self.distanceProgressValue animated:YES];
    
    /*self.distanceProgressView.progress  = self.distanceProgressValue;
     
     if(self.distanceProgressView.progress<1)
     
     [self performSelector:@selector(increaseDistanceProgressValue) withObject:nil afterDelay:0.3];*/
    
}


-(void)showCaloriesBurnedWithProgress:(NSString *)currentDate


{
    
    self.caloriesBurnedProgressValue = [[[dataForEachDate objectForKey:currentDate]  objectForKey:@"calories"] floatValue]/100.0f;
    
    [self.caloriesBurnedProgressView setProgress:self.caloriesBurnedProgressValue animated:YES];
    
    /* self.caloriesBurnedProgressView.progress  = self.caloriesBurnedProgressValue;
     
     if(self.caloriesBurnedProgressView.progress<1)
     
     [self performSelector:@selector(increaseCaloriesBurnedProgressValue) withObject:nil afterDelay:0.3];*/
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 3
 
 return cell;
 }*/







/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)previousDayButtonAction:(UIButton *)sender
{
    [self getDataForAllDates:responseResultsArray index:0];
}

- (IBAction)nextDayButtonAction:(UIButton *)sender
{
    [self getDataForAllDates:responseResultsArray index:2];
    
}
@end