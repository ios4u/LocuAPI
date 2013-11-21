//
//  NSValue+LocationCoordinate2D.m
//
//  Created by Iftekhar on 04/10/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.



#import "LCNSValue+Location.h"

@implementation NSValue (LocationCoordinate2D)

+ (id)valueWithLocation:(CLLocationCoordinate2D)location
{
    return [NSValue value:&location withObjCType:@encode(CLLocationCoordinate2D)];
}

- (CLLocationCoordinate2D)locationValue
{
    CLLocationCoordinate2D location; [self getValue:&location]; return location;
}

@end