//
//  Goals2ViewController.m
//  iMove
//
//  Created by Gerlach, Ryan K on 6/18/15.
//  Copyright (c) 2015 merck. All rights reserved.
//

#import "Goals2ViewController.h"

@interface Goals2ViewController ()
@property (nonatomic, strong) NSArray *goal;
@property (nonatomic, strong) NSDictionary *results;
@end

@implementation Goals2ViewController
@synthesize goal = _goal;
@synthesize results = _results;

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSError *error = nil;
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:api_reward_url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    
    self.results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    self.goal = [self.results objectForKey:@"goal"];
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    NSLog(@"Goal %@", self.goal);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger section = [[self.results objectForKey:@"result"] count] + 1;
    NSLog(@"%ld\n", section);
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 3;
    else {
        return [[[[self.results objectForKey:@"result"] objectAtIndex:(section -1)] objectForKey:@"data"] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Current Goal";
    }
    else {
        NSDictionary *week = [[self.results objectForKey:@"result"] objectAtIndex:(section -1)];
        NSNumber *num = [week objectForKey:@"num"];
        NSString *ret = [NSString stringWithFormat:@"Week - %@", num];
        return ret;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"goal";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    if(indexPath.section == 0) {
        NSDictionary *goal = [self.goal objectAtIndex:0];
        switch (indexPath.row) {
               
            case 0:
                cell.textLabel.text = @"Target Steps";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [goal objectForKey:@"steps"]];
                break;
            case 1:
                cell.textLabel.text = @"Goal Days";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [goal objectForKey:@"goal_days"]];
                break;
            case 2:
                cell.textLabel.text = @"Out of days";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [goal objectForKey:@"out_of_days"]];
                break;
            
            default:
                break;

        }
    }
    else {
        NSDictionary *week = [[self.results objectForKey:@"result"] objectAtIndex:(indexPath.section -1)];
        NSArray *data = [week objectForKey:@"data"];
    
        NSNumber *day = [[data objectAtIndex:indexPath.row] objectForKey:@"day"];
        NSString *goal = [[data objectAtIndex:indexPath.row] objectForKey:@"goal"];
        NSNumber *points = [[data objectAtIndex:indexPath.row] objectForKey:@"points"];
        NSNumber *steps = [[data objectAtIndex:indexPath.row] objectForKey:@"steps"];
        UIImage *image;
        if([goal isEqualToString:@"true"]) {
            NSString *file = [NSString  stringWithFormat:@"%@ Green Circle-50.png", day];
            image = [UIImage imageNamed:file];
        }
        else {
            NSString *file = [NSString  stringWithFormat:@"%@ Red Circle-50.png", day];
            image = [UIImage imageNamed:file];
        }
        
        UIImageView *img = [[UIImageView alloc] initWithImage:image];
        cell.textLabel.text = [NSString stringWithFormat:@"Day - %@", day];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = img;
        //cell.detailTextLabel.text = [NSString stringWithFormat:@"Points - %@", points];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Steps - %@", steps];

  
    }
    return cell;
}
@end
