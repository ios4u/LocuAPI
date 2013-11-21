//
//  NSValue+LocationCoordinate2D.h
//
//  Created by Iftekhar on 04/10/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NSValue (LocationCoordinate2D)

+ (id)valueWithLocation:(CLLocationCoordinate2D)location;
- (CLLocationCoordinate2D)locationValue;

@end
