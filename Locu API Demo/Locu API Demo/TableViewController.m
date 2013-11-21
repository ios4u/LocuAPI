//
//  ViewController.m
//  Locu API Demo
//
//  Created by Iftekhar on 20/11/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.
//

#import "TableViewController.h"
#import "LCService.h"
#import "LCRestaurantCell.h"

@interface TableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
	UIActivityIndicatorView *activity;
	NSArray *restaurants;
    IBOutlet UITableView *tableViewLocu;
}
@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	activity = [[UIActivityIndicatorView alloc] init];
	[activity setHidesWhenStopped:YES];
	
	self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];

	[activity startAnimating];
	[[LCService service] venueSearchWithQueryParameters:nil WithcompletionHandler:^(NSDictionary *dict, NSError *error) {
		
		[activity stopAnimating];
		
		if (error)
		{
			[[[UIAlertView alloc] initWithTitle:@"Message" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
		}
		else if ([dict objectForKey:LCKeyErrorMessage])
		{
			[[[UIAlertView alloc] initWithTitle:@"Message" message:[dict objectForKey:LCKeyErrorMessage] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
		}
		else if(dict)
		{
			restaurants = [dict objectForKey:LCKeyObjects];
            [tableViewLocu reloadData];
//			[tableViewLocu reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}];

	// Do any additional setup after loading the view, typically from a nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return restaurants.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[restaurants objectAtIndex:section] objectForKey:LCKeyName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"restaurantCell";
    
    LCRestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == Nil)
    {
        cell = [[LCRestaurantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSDictionary *restaurantDict = [restaurants objectAtIndex:indexPath.section];
    
    [cell setRestaurantProperty:restaurantDict];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
