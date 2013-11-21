//
//  LCService.m
//
//  Created by Iftekhar on 04/10/13.
//  Copyright (c) 2013 Iftekhar. All rights reserved.


//POST
NSString *WEBSERVICE_VENUE_SEARCH                   =   @"/venue/search/";
NSString *WEBSERVICE_VENUE_DETAILS                  =   @"/venue/";
NSString *WEBSERVICE_VENUE_INSIGHT                  =   @"/venue/insight/";
NSString *WEBSERVICE_MENU_ITEM_SEARCH               =   @"/menu_item/search/";
NSString *WEBSERVICE_MENU_ITEM_DETAILS              =   @"/menu_item/";
NSString *WEBSERVICE_MENU_ITEM_INSIGHT              =   @"/menu_item/insight/";


//Content-Types
//NSString *const application_x_www_form_urlencoded   =   @"application/x-www-form-urlencoded";
//NSString *const text_xml_charset_utf_8              =   @"text/xml; charset=utf-8";
NSString *const application_json                    =   @"application/json";

//Constants
//NSString *const HTTPMethodPOST                      =   @"POST";
NSString *const HTTPMethodGET                       =   @"GET";
NSString *const kContentType                        =	@"Content-Type";
//NSString *const kSoapAction                         =	@"SOAPAction";
//NSString *const kHost                               =	@"Host";

#import "LCService.h"
#import "LCAPIKey.h"

static LCService *sharedService;

@implementation LCService
{
    NSString *serviceURL;
    NSOperationQueue *operationQueue;
}

@synthesize logEnabled = _logEnabled;

- (id)init
{
    if ([LC_API_KEY length] == 40)
    {
        self = [super init];
        if (self)
        {
            serviceURL = @"http://api.locu.com/v1_0";
            operationQueue = [[NSOperationQueue alloc] init];
            //        [operationQueue setMaxConcurrentOperationCount:1];
        }
        return self;
    }
    else
    {
        NSLog(@"You must set LCAPIKey in LCAPIKey.h. For more information goto https://dev.locu.com/documentation");
        return nil;
    }
}

+(LCService*)service
{
    if (sharedService == nil)
    {
        sharedService = [[LCService alloc] init];
    }

    return sharedService;
}

-(void)setLogEnabled:(BOOL)logEnabled
{
	_logEnabled = logEnabled;
}

-(BOOL)isLogEnabled
{
	return _logEnabled;
}

+(NSMutableURLRequest*)requestWithURL:(NSURL*)url httpMethod:(NSString*)httpMethod contentType:(NSString*)contentType body:(NSData*)body
{
    if (url != nil)
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        if ([httpMethod length])    [request setHTTPMethod:httpMethod];
        if ([contentType length])   [request addValue:contentType forHTTPHeaderField:kContentType];
        if ([body length])          [request setHTTPBody:body];

        return request;
    }
    else
    {
        return nil;
    }
}

-(void)sendAsyncronousRequest:(NSURLRequest*)request withCompletionHandler:(CompletionHandler)completionHandler
{
	if (_logEnabled)
	{
		NSLog(@"RequestURL:- %@",request.URL);
		NSLog(@"HTTPHeaderFields:- %@",request.allHTTPHeaderFields);
		NSLog(@"Body:- %@",[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
	}
	
    [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
	 {
		 NSDictionary* jsonData;
		 if (data)	jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

		 if (_logEnabled)
		 {
			 NSLog(@"URL:- %@",request.URL);
			 
			 if (error)	NSLog(@"error:- %@",error);
			 else		NSLog(@"Response:- %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
		 }
		 
		 if (completionHandler != NULL)
		 {
			 dispatch_async(dispatch_get_main_queue(), ^{
				 completionHandler(jsonData, error);
			 });
		 }
	 }];
}

-(void)venueSearchWithQueryParameters:(NSDictionary*)parameters WithcompletionHandler:(CompletionHandler)completionHandler;
{
    //    http://api.locu.com/v1_0/venue/search/?api_key={your api_key}
    
    NSMutableString *stringURL = [[NSMutableString alloc] initWithFormat:@"%@%@?api_key=%@",serviceURL,WEBSERVICE_VENUE_SEARCH,LC_API_KEY];
    
    if ([[parameters allKeys] count])
    {
        for (NSString *aKey in [parameters allKeys])
        {
            //Strings
            if ([aKey isEqualToString:LCKeyName]
                || [aKey isEqualToString:LCKeyCategory]
                || [aKey isEqualToString:LCKeyCuisine]
                || [aKey isEqualToString:LCKeyWebsiteURL]
                || [aKey isEqualToString:LCKeyOpenAt]
                || [aKey isEqualToString:LCKeyStreetAddress]
                || [aKey isEqualToString:LCKeyLocality]
                || [aKey isEqualToString:LCKeyRegion]
                || [aKey isEqualToString:LCKeyPostalCode]
                || [aKey isEqualToString:LCKeyCountry]
            
                //Float
                || [aKey isEqualToString:LCKeyRadius]
                )
            {
                [stringURL appendFormat:@"&%@=%@",aKey,[parameters objectForKey:aKey]];
            }
            //Bool
            else if ([aKey isEqualToString:LCKeyHasMenu])
            {
                [stringURL appendFormat:@"&%@=%@",aKey,[[parameters objectForKey:aKey] boolValue]?@"true":@"false"];
            }
            //Tuple of floats
            else if ([aKey isEqualToString:LCKeyLocation])
            {
                CLLocationCoordinate2D location = [[parameters objectForKey:aKey] locationValue];
                [stringURL appendFormat:@"&%@=%f,%f",aKey,location.latitude,location.longitude];
            }
            //2 tuples of floats
            else if ([aKey isEqualToString:LCKeyBounds])
            {
                NSArray *locations = [parameters objectForKey:aKey];
                CLLocationCoordinate2D beginLocation = [[locations objectAtIndex:0] locationValue];
                CLLocationCoordinate2D endLocation = [[locations objectAtIndex:1] locationValue];
                
                [stringURL appendFormat:@"&%@=%f,%f|%f,%f",aKey,beginLocation.latitude,beginLocation.longitude,endLocation.latitude,endLocation.longitude];
            }
        }
    }
    
    NSURL *url = [NSURL URLWithString:stringURL];

    NSURLRequest *request = [LCService requestWithURL:url httpMethod:HTTPMethodGET contentType:application_json body:nil];
	[self sendAsyncronousRequest:request withCompletionHandler:completionHandler];
}

-(void)venueDetailsWithVenueID:(NSString*)venueID WithcompletionHandler:(CompletionHandler)completionHandler
{
    //    http://api.locu.com/v1_0/venue/{venue Locu id}/?api_key={your API key}
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@/?api_key=%@",serviceURL,WEBSERVICE_VENUE_DETAILS,venueID,LC_API_KEY]];
    
    NSURLRequest *request = [LCService requestWithURL:url httpMethod:HTTPMethodGET contentType:application_json body:nil];
	[self sendAsyncronousRequest:request withCompletionHandler:completionHandler];
}

-(void)venueInsightWithDimension:(NSString*)dimension queryParameters:(NSDictionary*)parameters WithcompletionHandler:(CompletionHandler)completionHandler
{
    //http://api.locu.com/v1_0/venue/insight/?api_key={your api_key}&dimension=locality
    
    NSMutableString *stringURL = [[NSMutableString alloc] initWithFormat:@"%@%@?api_key=%@&%@=%@",serviceURL,WEBSERVICE_VENUE_INSIGHT,LC_API_KEY,LCKeyDimension,dimension];
    
    if ([[parameters allKeys] count])
    {
        for (NSString *aKey in [parameters allKeys])
        {
            //Strings
            if ([aKey isEqualToString:LCKeyName]
                || [aKey isEqualToString:LCKeyCategory]
                || [aKey isEqualToString:LCKeyCuisine]
                || [aKey isEqualToString:LCKeyWebsiteURL]
                || [aKey isEqualToString:LCKeyOpenAt]
                || [aKey isEqualToString:LCKeyStreetAddress]
                || [aKey isEqualToString:LCKeyLocality]
                || [aKey isEqualToString:LCKeyRegion]
                || [aKey isEqualToString:LCKeyPostalCode]
                || [aKey isEqualToString:LCKeyCountry]
               
                //Float
                || [aKey isEqualToString:LCKeyRadius]
                )
            {
                [stringURL appendFormat:@"&%@=%@",aKey,[parameters objectForKey:aKey]];
            }
            //Bool
            else if ([aKey isEqualToString:LCKeyHasMenu])
            {
                [stringURL appendFormat:@"&%@=%@",aKey,[[parameters objectForKey:aKey] boolValue]?@"true":@"false"];
            }
            //Tuple of floats
            else if ([aKey isEqualToString:LCKeyLocation])
            {
                CLLocationCoordinate2D location = [[parameters objectForKey:aKey] locationValue];
                [stringURL appendFormat:@"&%@=%f,%f",aKey,location.latitude,location.longitude];
            }
            //2 tuples of floats
            else if ([aKey isEqualToString:LCKeyBounds])
            {
                NSArray *locations = [parameters objectForKey:aKey];
                CLLocationCoordinate2D beginLocation = [[locations objectAtIndex:0] locationValue];
                CLLocationCoordinate2D endLocation = [[locations objectAtIndex:1] locationValue];
                
                [stringURL appendFormat:@"&%@=%f,%f|%f,%f",aKey,beginLocation.latitude,beginLocation.longitude,endLocation.latitude,endLocation.longitude];
            }
        }
    }
    
    NSURL *url = [NSURL URLWithString:stringURL];
    
    NSURLRequest *request = [LCService requestWithURL:url httpMethod:HTTPMethodGET contentType:application_json body:nil];
	[self sendAsyncronousRequest:request withCompletionHandler:completionHandler];
}

-(void)menuItemSearchWithQueryParameters:(NSDictionary*)parameters WithcompletionHandler:(CompletionHandler)completionHandler;
{
    //http://api.locu.com/v1_0/menu_item/search/? api_key={Your API Key}
    
    NSMutableString *stringURL = [[NSMutableString alloc] initWithFormat:@"%@%@?api_key=%@",serviceURL,WEBSERVICE_MENU_ITEM_SEARCH,LC_API_KEY];
    
    if ([[parameters allKeys] count])
    {
        for (NSString *aKey in [parameters allKeys])
        {
            //Strings
            if ([aKey isEqualToString:LCKeyName]
                || [aKey isEqualToString:LCKeyDescription]
                || [aKey isEqualToString:LCKeyCategory]
                || [aKey isEqualToString:LCKeyStreetAddress]
                || [aKey isEqualToString:LCKeyLocality]
                || [aKey isEqualToString:LCKeyRegion]
                || [aKey isEqualToString:LCKeyPostalCode]
                || [aKey isEqualToString:LCKeyCountry]
            
                //Float
                || [aKey isEqualToString:LCKeyPrice]
                || [aKey isEqualToString:LCKeyPriceGT]
                || [aKey isEqualToString:LCKeyPriceGTE]
                || [aKey isEqualToString:LCKeyPriceLT]
                || [aKey isEqualToString:LCKeyPriceLTE]
                || [aKey isEqualToString:LCKeyRadius]
                )
            {
                [stringURL appendFormat:@"&%@=%@",aKey,[parameters objectForKey:aKey]];
            }
            //Tuple of floats
            else if ([aKey isEqualToString:LCKeyLocation])
            {
                CLLocationCoordinate2D location = [[parameters objectForKey:aKey] locationValue];
                [stringURL appendFormat:@"&%@=%f,%f",aKey,location.latitude,location.longitude];
            }
            //2 tuples of floats
            else if ([aKey isEqualToString:LCKeyBounds])
            {
                NSArray *locations = [parameters objectForKey:aKey];
                CLLocationCoordinate2D beginLocation = [[locations objectAtIndex:0] locationValue];
                CLLocationCoordinate2D endLocation = [[locations objectAtIndex:1] locationValue];
                
                [stringURL appendFormat:@"&%@=%f,%f|%f,%f",aKey,beginLocation.latitude,beginLocation.longitude,endLocation.latitude,endLocation.longitude];
            }
        }
    }
    
    NSURL *url = [NSURL URLWithString:stringURL];
    
    NSURLRequest *request = [LCService requestWithURL:url httpMethod:HTTPMethodGET contentType:application_json body:nil];
	[self sendAsyncronousRequest:request withCompletionHandler:completionHandler];
}

-(void)menuItemDetailsWithMenuItemID:(NSString*)menuItemID WithcompletionHandler:(CompletionHandler)completionHandler
{
    //    http://api.locu.com/v1_0/menu_item/{menu item Locu id}/?api_key={your API key}
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@/?api_key=%@",serviceURL,WEBSERVICE_MENU_ITEM_DETAILS,menuItemID,LC_API_KEY]];
    
    NSURLRequest *request = [LCService requestWithURL:url httpMethod:HTTPMethodGET contentType:application_json body:nil];
	[self sendAsyncronousRequest:request withCompletionHandler:completionHandler];
}

-(void)menuItemInsightWithDimension:(NSString*)dimension queryParameters:(NSDictionary*)parameters WithcompletionHandler:(CompletionHandler)completionHandler;
{
    //http://api.locu.com/v1_0/menu_item/insight/? dimension=locality
    
    NSMutableString *stringURL = [[NSMutableString alloc] initWithFormat:@"%@%@?api_key=%@&%@=%@",serviceURL,WEBSERVICE_MENU_ITEM_INSIGHT,LC_API_KEY,LCKeyDimension,dimension];
    
    if ([[parameters allKeys] count])
    {
        for (NSString *aKey in [parameters allKeys])
        {
            //Strings
            if ([aKey isEqualToString:LCKeyName]
                || [aKey isEqualToString:LCKeyDescription]
                || [aKey isEqualToString:LCKeyStreetAddress]
                || [aKey isEqualToString:LCKeyLocality]
                || [aKey isEqualToString:LCKeyRegion]
                || [aKey isEqualToString:LCKeyPostalCode]
                || [aKey isEqualToString:LCKeyCountry]
            
                //Float
                || [aKey isEqualToString:LCKeyPrice]
                || [aKey isEqualToString:LCKeyPriceGT]
                || [aKey isEqualToString:LCKeyPriceGTE]
                || [aKey isEqualToString:LCKeyPriceLT]
                || [aKey isEqualToString:LCKeyPriceLTE]
                || [aKey isEqualToString:LCKeyRadius]
                )
            {
                [stringURL appendFormat:@"&%@=%@",aKey,[parameters objectForKey:aKey]];
            }
            //Tuple of floats
            else if ([aKey isEqualToString:LCKeyLocation])
            {
                CLLocationCoordinate2D location = [[parameters objectForKey:aKey] locationValue];
                [stringURL appendFormat:@"&%@=%f,%f",aKey,location.latitude,location.longitude];
            }
            //2 tuples of floats
            else if ([aKey isEqualToString:LCKeyBounds])
            {
                NSArray *locations = [parameters objectForKey:aKey];
                CLLocationCoordinate2D beginLocation = [[locations objectAtIndex:0] locationValue];
                CLLocationCoordinate2D endLocation = [[locations objectAtIndex:1] locationValue];
                
                [stringURL appendFormat:@"&%@=%f,%f|%f,%f",aKey,beginLocation.latitude,beginLocation.longitude,endLocation.latitude,endLocation.longitude];
            }
        }
    }
    
    NSURL *url = [NSURL URLWithString:stringURL];
    
    NSURLRequest *request = [LCService requestWithURL:url httpMethod:HTTPMethodGET contentType:application_json body:nil];
	[self sendAsyncronousRequest:request withCompletionHandler:completionHandler];
}



@end

//Keys


NSString *const LCKeyErrorMessage         =   @"error_message";  //String
NSString *const LCKeyApiKey               =   @"api_key";  //String (required)
NSString *const LCKeyName                 =   @"name";    //String
NSString *const LCKeyHasMenu              =   @"has_menu";  //Boolean
NSString *const LCKeyCategory             =   @"category";   //String
NSString *const LCKeyCuisine              =   @"cuisine";    //String
NSString *const LCKeyWebsiteURL           =   @"website_url";  //String
NSString *const LCKeyOpenAt               =   @"open_at";    //String (YYYY-MM-DDTHH:MM:SS ) in the business' local time zone.
NSString *const LCKeyStreetAddress        =   @"street_address";    //String
NSString *const LCKeyLocality             =   @"locality";    //String
NSString *const LCKeyRegion               =   @"region";    //String
NSString *const LCKeyPostalCode           =   @"postal_code";    //String
NSString *const LCKeyCountry              =   @"country";    //String
NSString *const LCKeyLocation             =   @"location";    //(lat,long)Tuple of floats
NSString *const LCKeyRadius               =   @"radius";    //Float
NSString *const LCKeyBounds               =   @"bounds";    //(lat,long|lat,long)	2 tuples of floats separated by '|'

NSString *const LCKeyDimension            =   @"dimension";  //String (required)


NSString *const LCKeyDescription            =   @"description";  //String
NSString *const LCKeyPrice            =   @"price";  //String
NSString *const LCKeyPriceGT            =   @"price__gt";  //String
NSString *const LCKeyPriceLT            =   @"price__lt";  //String
NSString *const LCKeyPriceGTE            =   @"price__gte";  //String
NSString *const LCKeyPriceLTE            =   @"price__lte";  //String

//Values
//category
NSString *const kCategoryRestaurant         =   @"restaurant";
NSString *const kCategorySpa                =   @"spa";
NSString *const kCategoryBeauty             =   @"beauty";
NSString *const kCategorySalon              =   @"salon";
NSString *const kCategoryGym                =   @"gym";
NSString *const kCategoryLaundry            =   @"laundry";
NSString *const kCategoryHairCare           =   @"hair care";
NSString *const kCategoryOther              =   @"other";

//dimension
NSString *const kDimensionLocality          =   @"locality";
NSString *const kDimensionRegion            =   @"region";
NSString *const kDimensionCategory          =   @"category";
NSString *const kDimensionCuisine           =   @"cuisine";


#pragma mark - response keys
NSString *const LCKeyMeta             =   @"meta";
NSString *const LCKeyCacheExpiry      =   @"cache-expiry";
NSString *const LCKeyLimit            =   @"limit";
NSString *const LCKeyObjects          =   @"objects";
NSString *const LCKeyID               =   @"id";
NSString *const LCKeyPhone            =   @"phone";
NSString *const LCKeyResourceURI      =   @"resource_uri";
NSString *const LCKeyLat              =   @"lat";
NSString *const LCKeyLong             =   @"long";
NSString *const LCKeyCategories       =   @"categories";
NSString *const LCKeyCuisines         =   @"cuisines";
NSString *const LCKeyNotFound         =   @"not_found";
NSString *const LCKeyOpenHours        =   @"open_hours";
NSString *const LCKeyMonday           =   @"Monday";
NSString *const LCKeyTuesday          =   @"Tuesday";
NSString *const LCKeyWednesday        =   @"Wednesday";
NSString *const LCKeyThursday         =   @"Thursday";
NSString *const LCKeyFriday           =   @"Friday";
NSString *const LCKeySaturday         =   @"Saturday";
NSString *const LCKeySunday           =   @"Sunday";
NSString *const LCKeyFacebookURL      =   @"facebook_url";
NSString *const LCKeyTwitterID        =   @"twitter_id";
NSString *const LCKeySimilarVenues    =   @"similar_venues";
NSString *const LCKeyRedirectedFrom   =   @"redirected_from";
NSString *const LCKeyMenus            =   @"menus";
NSString *const LCKeyMenuName         =   @"menu_name";
NSString *const LCKeySections         =   @"sections";
NSString *const LCKeySectionName      =   @"section_name";
NSString *const LCKeySubsections      =   @"subsections";
NSString *const LCKeySubsectionName   =   @"subsection_name";
NSString *const LCKeyContents         =   @"contents";
NSString *const LCKeyType             =   @"type";
NSString *const LCKeyText             =   @"text";
NSString *const LCKeyOptionGroups     =   @"option_groups";
NSString *const LCKeyOptions          =   @"options";
NSString *const LCKeyVenue            =   @"venue";
NSString *const LCKeyMean             =   @"mean";
NSString *const LCKeyStdDeviation     =   @"std_deviation";
NSString *const LCKeyHistogram        =   @"histogram";
NSString *const LCKeyFreq             =   @"freq";
NSString *const LCKeyKey              =   @"key";
NSString *const LCKeyCurrencySymbol   =   @"currency_symbol";
