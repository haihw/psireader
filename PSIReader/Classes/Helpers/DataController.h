//
//  DataController.h
//  PSIReader
//
//  Created by Hai Hw on 19/2/17.
//  Copyright © 2017 Hai Hw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataController : NSObject
+(id)sharedController;
- (NSArray *)getLatesPSI;
- (void)getCurrentPSIWithResponse:(void (^)(BOOL success, NSString *message, NSArray *result))block;
- (NSArray *)getAllPSIRecords;
@end
