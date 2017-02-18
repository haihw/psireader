//
//  BackendConnector.m
//  PSIReader
//
//  Created by Hai Hw on 18/2/17.
//  Copyright © 2017 Hai Hw. All rights reserved.
//

#import "BackendConnector.h"
#import "AFNetworking.h"
#import "RegionalPSI.h"
#define kBaseURL @"https://api.data.gov.sg/v1/"
#define kConsumerKey @"q20Alu9Aaj6xyfRHQtT9aKbkrdDBweK8"
@interface BackendConnector(){
    AFHTTPSessionManager *sessionManager;
}
@end
@implementation BackendConnector
+(id)sharedConnector{
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}
- (instancetype)init
{
    self = [super init];
    if (self){
        sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
        [sessionManager.requestSerializer  setValue:kConsumerKey forHTTPHeaderField:@"api-key"];
        [sessionManager.requestSerializer setTimeoutInterval:3];
    }
    return self;
}

- (void)getPSIForDateTime:(NSDate *)dateTime
                 response:(void (^)(BOOL success, NSString *message, NSArray *result))block
{
    NSURL *URL = [NSURL URLWithString:@"environment/psi" relativeToURL:sessionManager.baseURL];
    NSDictionary *params;
    if (dateTime){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
        NSString *dateTimeString = [dateFormatter stringFromDate:dateTime];
        params = [NSDictionary dictionaryWithObject:dateTimeString forKey:@"date_time"];
        NSLog(@"%@", params);
    }

    [sessionManager GET:URL.absoluteString parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        //Parse json to object

        NSDictionary *psiReadingDictionary = [responseObject valueForKeyPath:@"items.readings"];
        NSArray *regionMetaData = [responseObject valueForKeyPath:@"region_metadata"];

        NSMutableArray *allRegions = [NSMutableArray array];
        for (NSDictionary * region in regionMetaData){
            RegionalPSI *regionalPsi = [[RegionalPSI alloc] init];
            regionalPsi.region = [region objectForKey:@"name"];
            regionalPsi.time = dateTime;
            regionalPsi.psiValues = [NSMutableDictionary dictionary];
            
            for (NSDictionary *psiInfo in psiReadingDictionary){
                for (NSString *psiType in psiInfo.allKeys){
                    NSDictionary *psiValues = [psiInfo objectForKey:psiType];
                    [regionalPsi.psiValues setValue:[psiValues objectForKey:regionalPsi.region] forKey:psiType];
                }
            }
            
            [allRegions addObject:regionalPsi];
        }
        
        block (YES, @"", allRegions);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block (NO, error.localizedDescription, nil);
    }];
}
@end
