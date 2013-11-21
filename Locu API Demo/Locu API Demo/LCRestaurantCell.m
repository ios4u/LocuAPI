//
//  RestaurantCell.m
//  garcon
//
//  Created by Canopus on 11/7/13.
//  Copyright (c) 2013 angularis. All rights reserved.
//

#import "LCRestaurantCell.h"
#import <QuartzCore/QuartzCore.h>
#import "LCService.h"

@implementation LCRestaurantCell
{
	UILabel         *labelRestaurantAddress;
    UILabel         *labelCuisineType;
    UILabel         *labelPhoneNo;
    UILabel         *labelWebsiteURL;
}

@synthesize restaurantProperty = _restaurantProperty;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        labelRestaurantAddress = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 30)];
        [labelRestaurantAddress setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [labelRestaurantAddress setBaselineAdjustment:UIBaselineAdjustmentNone];
        [labelRestaurantAddress setBackgroundColor:[UIColor clearColor]];
		[labelRestaurantAddress setNumberOfLines:0];
        [labelRestaurantAddress setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.contentView addSubview:labelRestaurantAddress];
        
        labelCuisineType = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 310, 12)];
        [labelCuisineType setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [labelCuisineType setBackgroundColor:[UIColor clearColor]];
        [labelCuisineType setFont:[labelCuisineType.font fontWithSize:10.0]];
        [self.contentView addSubview:labelCuisineType];
        
        labelPhoneNo=[[UILabel alloc]initWithFrame:CGRectMake(5, 47, 310, 12)];
        [labelPhoneNo setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [labelPhoneNo setBackgroundColor:[UIColor clearColor]];
        [labelPhoneNo setFont:[labelPhoneNo.font fontWithSize:10.0]];
        [self.contentView addSubview:labelPhoneNo];
        
        labelWebsiteURL=[[UILabel alloc]initWithFrame:CGRectMake(5, 58, 310, 12)];
        [labelWebsiteURL setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [labelWebsiteURL setBackgroundColor:[UIColor clearColor]];
        [labelWebsiteURL setFont:[labelWebsiteURL.font fontWithSize:10.0]];
        [self.contentView addSubview:labelWebsiteURL];
    }
    return self;
}

-(void)setRestaurantProperty:(NSDictionary *)restaurantProperty
{
    _restaurantProperty=restaurantProperty;
    
    NSMutableString *address = [[NSMutableString alloc] init];
    
    if ([_restaurantProperty objectForKey:LCKeyStreetAddress] && ![[_restaurantProperty objectForKey:LCKeyStreetAddress] isKindOfClass:[NSNull class]])
        [address appendFormat:@"%@, ",[_restaurantProperty objectForKey:LCKeyStreetAddress]];
    if ([_restaurantProperty objectForKey:LCKeyLocality] && ![[_restaurantProperty objectForKey:LCKeyLocality] isKindOfClass:[NSNull class]])
        [address appendFormat:@"%@, ",[_restaurantProperty objectForKey:LCKeyLocality]];
    if ([_restaurantProperty objectForKey:LCKeyRegion] && ![[_restaurantProperty objectForKey:LCKeyRegion] isKindOfClass:[NSNull class]])
        [address appendFormat:@"%@, ",[_restaurantProperty objectForKey:LCKeyRegion]];
    if ([_restaurantProperty objectForKey:LCKeyPostalCode] && ![[_restaurantProperty objectForKey:LCKeyPostalCode] isKindOfClass:[NSNull class]])
        [address appendFormat:@"%@, ",[_restaurantProperty objectForKey:LCKeyPostalCode]];
    if ([_restaurantProperty objectForKey:LCKeyCountry] && ![[_restaurantProperty objectForKey:LCKeyCountry] isKindOfClass:[NSNull class]])
        [address appendFormat:@"%@, ",[_restaurantProperty objectForKey:LCKeyCountry]];
    
    if (address.length >2)
        [labelRestaurantAddress setText:[NSString stringWithFormat:@"Address: %@",[address substringFromIndex:2]]];
    ////
    if ([[_restaurantProperty objectForKey:LCKeyCuisines] count])
    {
        [labelCuisineType setText:[NSString stringWithFormat:@"Cuisine Types: %@",[[_restaurantProperty objectForKey:LCKeyCuisines] componentsJoinedByString:@", "]]];
    }
    ////
    NSString *phoneNumber= [_restaurantProperty objectForKey:LCKeyPhone];
    if(phoneNumber!=nil && ![phoneNumber isKindOfClass:[NSNull class]])
        [labelPhoneNo setText:[NSString stringWithFormat:@"Phone No.: %@",[NSString stringWithFormat:@"%@",phoneNumber]]];
    ////
    NSString *websiteURL= [_restaurantProperty objectForKey:LCKeyWebsiteURL];
    if(websiteURL!=nil && ![websiteURL isKindOfClass:[NSNull class]])
        [labelWebsiteURL setText:[NSString stringWithFormat:@"Website: %@",[_restaurantProperty objectForKey:LCKeyWebsiteURL]]];
    ////
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
