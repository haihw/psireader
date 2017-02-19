//
//  DataController.m
//  PSIReader
//
//  Created by Hai Hw on 19/2/17.
//  Copyright © 2017 Hai Hw. All rights reserved.
//
#import "DataController.h"
#import "BackendConnector.h"
#import "RegionalPSI.h"
static NSString *kKeyLastestPSIInfos = @"regionalPSIInfos";


@implementation DataController
+(id)sharedController{
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}
- (void)clearData{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kKeyLastestPSIInfos];

}
- (NSArray *)getLatesPSI{
    NSData *serialized = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyLastestPSIInfos];
    NSMutableArray *savedPSIInfos = [NSKeyedUnarchiver unarchiveObjectWithData:serialized];
    id latesData = savedPSIInfos.lastObject;
    return [self psiInfosFromJsonObject:latesData];
}
- (NSDate *)dateFromString:(NSString *)string{
    NSDateFormatter *dateFormatterWithTZ = [[NSDateFormatter alloc] init];
    dateFormatterWithTZ.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    NSDate *dateWithTZ = [dateFormatterWithTZ dateFromString:string];
    return dateWithTZ;
}
- (NSArray *)psiInfosFromJsonObject:(id)jsonObject{
    //Parse json to object
    
    NSDictionary *psiReadingDictionary = [jsonObject valueForKeyPath:@"items.readings"];
    NSArray *regionMetaData = [jsonObject valueForKeyPath:@"region_metadata"];
    
    NSMutableArray *allRegions = [NSMutableArray array];
    for (NSDictionary * region in regionMetaData){
        RegionalPSI *regionalPsi = [[RegionalPSI alloc] init];
        regionalPsi.region = [region objectForKey:@"name"];
        regionalPsi.time = [self dateFromString:[jsonObject valueForKeyPath:@"items.update_timestamp.@firstObject"]];
        regionalPsi.psiValues = [NSMutableDictionary dictionary];
        
        for (NSDictionary *psiInfo in psiReadingDictionary){
            for (NSString *psiType in psiInfo.allKeys){
                NSDictionary *psiValues = [psiInfo objectForKey:psiType];
                [regionalPsi.psiValues setValue:[psiValues objectForKey:regionalPsi.region] forKey:psiType];
            }
        }
        
        [allRegions addObject:regionalPsi];
    }
    return allRegions;
}
- (void)saveNewPSIData:(id)data{
    NSData *serialized = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyLastestPSIInfos];
    NSMutableArray *savedPSIInfos = [NSKeyedUnarchiver unarchiveObjectWithData:serialized];
    if (!savedPSIInfos){
        savedPSIInfos = [NSMutableArray array];
    }
    [savedPSIInfos addObject:data];
    serialized = [NSKeyedArchiver archivedDataWithRootObject:savedPSIInfos];
    [[NSUserDefaults standardUserDefaults] setObject:serialized forKey:kKeyLastestPSIInfos];
   
}
- (void)getCurrentPSIWithResponse:(void (^)(BOOL success, NSString *message, NSArray *result))block{
    [[BackendConnector sharedConnector] getPSIForDateTime:[NSDate date]
                                                 response:^(BOOL success, NSString *message, id result) {
                                                     if (success){
                                                         [self saveNewPSIData:result];
                                                     }
                                                     block(success, message, result);
                                                 }];

}
- (NSArray *)getAllPSIRecords{
    NSData *serialized = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyLastestPSIInfos];
    NSMutableArray *savedPSIInfos = [NSKeyedUnarchiver unarchiveObjectWithData:serialized];
    NSMutableArray *allPSIRecords = [NSMutableArray array];
    for (id object in savedPSIInfos){
        NSArray *psiInfo = [self psiInfosFromJsonObject:object];
        [allPSIRecords addObject:psiInfo];
    }
    return allPSIRecords;
}

@end
