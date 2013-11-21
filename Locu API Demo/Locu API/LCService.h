//
//  LCService.h
//
//  Created by Iftekhar on 04/10/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.

#import <Foundation/Foundation.h>
#import "LCNSValue+Location.h"

/*Read Locu API document for more information
 https://dev.locu.com/documentation/
 */

typedef void(^CompletionHandler)(NSDictionary *dict, NSError* error);

@interface LCService : NSObject

@property(nonatomic, assign, getter = isLogEnabled) BOOL logEnabled;

+(LCService*)service;

//VENUE
-(void)venueSearchWithQueryParameters:(NSDictionary*)parameters WithcompletionHandler:(CompletionHandler)completionHandler;
-(void)venueDetailsWithVenueID:(NSString*)venueID WithcompletionHandler:(CompletionHandler)completionHandler;
-(void)venueInsightWithDimension:(NSString*)dimension queryParameters:(NSDictionary*)parameters WithcompletionHandler:(CompletionHandler)completionHandler;

//MENU ITEM
-(void)menuItemSearchWithQueryParameters:(NSDictionary*)parameters WithcompletionHandler:(CompletionHandler)completionHandler;
-(void)menuItemDetailsWithMenuItemID:(NSString*)menuItemID WithcompletionHandler:(CompletionHandler)completionHandler;
-(void)menuItemInsightWithDimension:(NSString*)dimension queryParameters:(NSDictionary*)parameters WithcompletionHandler:(CompletionHandler)completionHandler;

@end


#pragma mark - Request Keys
extern NSString *const LCKeyErrorMessage;     //String
extern NSString *const LCKeyApiKey;           //String (required)
extern NSString *const LCKeyName;             //String
extern NSString *const LCKeyHasMenu;          //Boolean
extern NSString *const LCKeyCategory;         //String
extern NSString *const LCKeyCuisine;          //String
extern NSString *const LCKeyWebsiteURL;       //String
extern NSString *const LCKeyOpenAt;           //String
extern NSString *const LCKeyStreetAddress;    //String
extern NSString *const LCKeyLocality;         //String
extern NSString *const LCKeyRegion;           //String
extern NSString *const LCKeyPostalCode;       //String
extern NSString *const LCKeyCountry;          //String
extern NSString *const LCKeyLocation;         //(lat,long)Tuple of floats
extern NSString *const LCKeyRadius;           //Float
extern NSString *const LCKeyBounds;           //(lat,long|lat,long)	2 tuples of floats separated by '|'

extern NSString *const kCategoryRestaurant;
extern NSString *const kCategorySpa;
extern NSString *const kCategoryBeauty;
extern NSString *const kCategorySalon;
extern NSString *const kCategoryGym;
extern NSString *const kCategoryLaundry;
extern NSString *const kCategoryHairCare;
extern NSString *const kCategoryOther;





//Vanue Insight
//parameters key+ all vanue search keys
extern NSString *const LCKeyDimension;  //String (required)
//Vanue Insight dimension parameters value
extern NSString *const kDimensionLocality;
extern NSString *const kDimensionRegion;
extern NSString *const kDimensionCategory;
extern NSString *const kDimensionCuisine;



//menu item search parameters key
extern NSString *const LCKeyDescription;  //String
extern NSString *const LCKeyPrice;  //String
extern NSString *const LCKeyPriceGT;  //String
extern NSString *const LCKeyPriceLT;  //String
extern NSString *const LCKeyPriceGTE;  //String
extern NSString *const LCKeyPriceLTE;  //String




#pragma mark - response keys
extern NSString *const LCKeyMeta;
extern NSString *const LCKeyCacheExpiry;
extern NSString *const LCKeyLimit;
extern NSString *const LCKeyObjects;
extern NSString *const LCKeyID;
extern NSString *const LCKeyPhone;
extern NSString *const LCKeyResourceURI;
extern NSString *const LCKeyLat;
extern NSString *const LCKeyLong;
extern NSString *const LCKeyCategories;
extern NSString *const LCKeyCuisines;
extern NSString *const LCKeyNotFound;
extern NSString *const LCKeyOpenHours;
extern NSString *const LCKeyMonday;
extern NSString *const LCKeyTuesday;
extern NSString *const LCKeyWednesday;
extern NSString *const LCKeyThursday;
extern NSString *const LCKeyFriday;
extern NSString *const LCKeySaturday;
extern NSString *const LCKeySunday;
extern NSString *const LCKeyFacebookURL;
extern NSString *const LCKeyTwitterID;
extern NSString *const LCKeySimilarVenues;
extern NSString *const LCKeyRedirectedFrom;
extern NSString *const LCKeyMenus;
extern NSString *const LCKeyMenuName;
extern NSString *const LCKeySections;
extern NSString *const LCKeySectionName;
extern NSString *const LCKeySubsections;
extern NSString *const LCKeySubsectionName;
extern NSString *const LCKeyContents;
extern NSString *const LCKeyType;
extern NSString *const LCKeyText;
extern NSString *const LCKeyOptionGroups;
extern NSString *const LCKeyOptions;
extern NSString *const LCKeyVenue;
extern NSString *const LCKeyMean;
extern NSString *const LCKeyStdDeviation;
extern NSString *const LCKeyHistogram;
extern NSString *const LCKeyFreq;
extern NSString *const LCKeyKey;
extern NSString *const LCKeyCurrencySymbol;







